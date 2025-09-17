//
//  WebSocketService.swift
//  Virgin Voyages
//
//  Created by Pajtim on 12.5.25.
//

import Foundation

protocol WebSocketServiceProtocol {
    var messageStream: AsyncStream<WebSocketEventsResponse> { get }
    func connect() async
    func disconnect()
}

final class WebSocketService: WebSocketServiceProtocol {
    static let shared = WebSocketService()

    private var webSocketTask: URLSessionWebSocketTask?
    private var continuation: AsyncStream<WebSocketEventsResponse>.Continuation?
    private var urlSession: URLSession
    private var pingTimer: Timer?
    private var reconnectAttempts = 0
    private let maxReconnectAttempts = 5
    private let urlString: String
    private var reconnecting = false
    private var isStoppedManually = false
    private var componentSettingsUseCase: ComponentSettingsUseCaseProtocol
    private var isConnected = false

    var messageStream: AsyncStream<WebSocketEventsResponse> {
        AsyncStream { continuation in
            self.continuation = continuation
        }
    }

    init(urlString: String = WebSocketConstants.url, componentSettingsUseCase: ComponentSettingsUseCaseProtocol = ComponentSettingsUseCase()) {
        self.urlString = urlString
        self.urlSession = URLSession(configuration: .default)
        self.componentSettingsUseCase = componentSettingsUseCase
    }

    func connect() async {
        guard !isConnected else {
            print("WebSocket: Already connected.")
            return
        }
        isStoppedManually = false
        reconnectAttempts = 0
        await establishConnection()
    }

    func disconnect() {
        isStoppedManually = true
        pingTimer?.invalidate()
        pingTimer = nil
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        continuation?.finish()
        webSocketTask = nil
        isConnected = false
    }

    private func establishConnection() async {
        guard let url = URL(string: urlString) else { return }

        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        print("WebSocket: Connected")
        isConnected = true
        reconnectAttempts = 0
        startPingTimer()

        await sendInitialConfig()
        await listen()
    }

    private func sendInitialConfig() async {
		let componentSettings = try? await componentSettingsUseCase.execute(useCache: true)
        let config = WebSocketConfigurations.fromComponentSettings(componentSettings)

        do {
            let jsonData = try JSONEncoder().encode(config)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("WebSocket jsonString: \(jsonString)")
                self.send(text: jsonString)
            }
        } catch {
            print("Failed to encode WebSocket config: \(error)")
        }
    }

    private func reconnect() {
        guard !isStoppedManually, reconnectAttempts < maxReconnectAttempts else {
            continuation?.finish()
            print("WebSocket: Reconnect attempts exhausted.")
            return
        }

        reconnecting = true
        reconnectAttempts += 1
        let delay = pow(2.0, Double(reconnectAttempts))
        print("WebSocket: Attempting to reconnect in \(delay)s (Attempt \(reconnectAttempts))")

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
			guard let self = self else { return }
            Task {
                await self.establishConnection()
                self.reconnecting = false
            }
        }
    }

    private func startPingTimer() {
		DispatchQueue.main.async { [weak self] in
			self?.pingTimer?.invalidate()
			self?.pingTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
				self?.sendPing()
			}
		}
    }

    private func sendPing() {
        webSocketTask?.sendPing { error in
            if let error = error {
                print("WebSocket: Ping error: \(error)")
                self.reconnect()
            } else {
                print("WebSocket: Ping successful")
            }
        }
    }

    private func listen() async {
        guard let task = webSocketTask else { return }

        while !isStoppedManually {
            do {
                let result = try await task.receive()
                switch result {
                case .string(let text):
                    if let data = text.data(using: .utf8) {
                        handleMessage(data)
                    }

                case .data(let data):
                    handleMessage(data)

                @unknown default:
                    print("WebSocket: Received unknown message type")
                }
            } catch {
                print("WebSocket: Receive error: \(error)")
                reconnect()
                break
            }
        }
    }

    private func handleMessage(_ data: Data) {
        if let event = try? JSONDecoder().decode(WebSocketEventsResponse.self, from: data) {
            print("WebSocket event: \(event)")
            continuation?.yield(event)
        }
    }

    func send(text: String) {
        guard let task = webSocketTask else {
            print("WebSocket: Not connected")
            return
        }

        task.send(.string(text)) { error in
            if let error = error {
                self.reconnect()
            }
        }
    }
}


struct WebSocketEventsResponse: Codable {
    let n: String?
    let tg: String?
    let ts: String?
    let ci: String?
    let cn: String?
}

enum MusterDrillWSEvent: String, CaseIterable {
    case CREW_PRIOR = "muster-drill:crew-prior-drill-notification"
    case GUEST_PRIOR = "muster-drill:guest-prior-drill-notification"
    case CREATED = "muster-drill:created"
    case UPDATED = "muster-drill:updated"
    case COMPLETED = "muster-drill:completed"
}
