//
//  NetworkMonitor.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/5/25.
//


import Network

enum ConnectionType {
	case wifi, cellular, ethernet, unknown
}

@MainActor
protocol NetworkMonitorObserver: AnyObject {
	func networkStatusChanged()
}

private class NetworkMonitorObserverWrapper {
	weak var observer: NetworkMonitorObserver?

	init(observer: NetworkMonitorObserver) {
		self.observer = observer
	}
}

protocol NetworkMonitorProtocol {
	var isConnected: Bool { get }
	var connectionType: ConnectionType { get }
	func startMonitoring()
	func stopMonitoring()
	func addObserver(_ observer: NetworkMonitorObserver)
	func removeObserver(_ observer: NetworkMonitorObserver)
}

final class NetworkMonitor: NetworkMonitorProtocol {

	static let shared = NetworkMonitor()

	private var observers = [NetworkMonitorObserverWrapper]()

	private let monitor = NWPathMonitor()
	private let queue = DispatchQueue.global(qos: .background)
	private var lastConnectionStatus: Bool?
	private var lastConnectionType: ConnectionType?

	private(set) var isConnected: Bool = false
	private(set) var connectionType: ConnectionType = .unknown

	private init() {
		startMonitoring()
	}

	func startMonitoring() {
		monitor.pathUpdateHandler = { [weak self] path in
			guard let self = self else { return }

			let newStatus = path.status == .satisfied
			let newConnectionType = self.getConnectionType(path)

			// Only notify observers if something actually changed
			if newStatus != self.lastConnectionStatus || newConnectionType != self.lastConnectionType {
				self.isConnected = newStatus
				self.connectionType = newConnectionType
				self.lastConnectionStatus = newStatus
				self.lastConnectionType = newConnectionType

                DispatchQueue.main.async {   
                    self.observers.forEach { $0.observer?.networkStatusChanged() }
                }
			}
		}
		monitor.start(queue: queue)
	}

	// Stop network monitoring
    func stopMonitoring() {
        monitor.cancel()
    }
    
    // Determine the connection type
    private func getConnectionType(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        }
        return .unknown
    }

	func addObserver(_ observer: NetworkMonitorObserver) {
		if !observers.contains(where: { $0.observer === observer }) {
			observers.append(NetworkMonitorObserverWrapper(observer: observer))
		}
	}

	func removeObserver(_ observer: NetworkMonitorObserver) {
		observers.removeAll(where: { $0.observer === observer || $0.observer == nil })
	}
}
