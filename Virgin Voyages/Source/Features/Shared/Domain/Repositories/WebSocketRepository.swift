//
//  WebSocketRepository.swift
//  Virgin Voyages
//
//  Created by Pajtim on 12.5.25.
//

import Foundation

protocol WebSocketRepositoryProtocol {
    var eventStream: AsyncStream<WebSocketEventsResponse> { get }
    func startListening() async
    func stopListening()
}

final class WebSocketRepository: WebSocketRepositoryProtocol {
    private let webSocketService: WebSocketServiceProtocol

    var eventStream: AsyncStream<WebSocketEventsResponse> {
        webSocketService.messageStream
    }

    init(webSocketService: WebSocketServiceProtocol = WebSocketService.shared) {
        self.webSocketService = webSocketService
    }

    func startListening() async {
        await webSocketService.connect()
    }

    func stopListening() {
        webSocketService.disconnect()
    }
}
