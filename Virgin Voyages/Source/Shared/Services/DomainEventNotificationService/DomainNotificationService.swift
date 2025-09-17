//
//  EventBus.swift
//  Virgin Voyages
//
//  Created by TX on 26.3.25.
//

import Foundation

class DomainNotificationService<Event> {
    private let notificationCenter = NotificationCenter.default
    private let notificationName = Notification.Name(String(describing: Event.self))

    private var keyedListeners: [String: NSObjectProtocol] = [:]
    private let lock = NSLock()

	func publish(_ event: Event) {
		DispatchQueue.main.async {
			self.notificationCenter.post(name: self.notificationName, object: event)
		}
	}

    /// Listen without a key (multiple listeners allowed)
    @discardableResult
    func listen(using block: @escaping (Event) -> Void) -> NSObjectProtocol {
        notificationCenter.addObserver(forName: notificationName, object: nil, queue: .main) { notification in
            if let event = notification.object as? Event {
                block(event)
            }
        }
    }

    /// Listen with a key - only one listener per key is allowed
    func listen(
        key: String,
        using block: @escaping (Event) -> Void
    ) {
        self.lock.lock()
        defer { self.lock.unlock() }

        // If there's already an observer for this key, remove it first
        if let existingObserver = self.keyedListeners[key] {
            notificationCenter.removeObserver(existingObserver)
            self.keyedListeners.removeValue(forKey: key)
        }

        // Add new observer and store it under the key
        let observer = notificationCenter.addObserver(forName: notificationName, object: nil, queue: .main) { notification in
            if let event = notification.object as? Event {
                block(event)
            }
        }
        self.keyedListeners[key] = observer
    }

    func stopListening(key: String) {

        self.lock.lock()
        defer { self.lock.unlock() }

        if let observer = keyedListeners[key] {
            self.notificationCenter.removeObserver(observer)
            self.keyedListeners.removeValue(forKey: key)
        }
    }

    func stopListening(_ observer: NSObjectProtocol) {
        self.notificationCenter.removeObserver(observer)
    }
}
