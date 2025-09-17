//
//  WebSocketUseCase.swift
//  Virgin Voyages
//
//  Created by Pajtim on 12.5.25.
//

import Foundation

protocol WebSocketUseCaseProtocol {
    var eventStream: AsyncStream<WebSocketEventsResponse> { get }
    func execute() async
    func stop()
}

final class WebSocketUseCase: WebSocketUseCaseProtocol {
    private let repository: WebSocketRepositoryProtocol

    var eventStream: AsyncStream<WebSocketEventsResponse> {
        repository.eventStream
    }

    init(repository: WebSocketRepositoryProtocol = WebSocketRepository()) {
        self.repository = repository
    }

    func execute() async {
        await repository.startListening()
    }

    func stop() {
        repository.stopListening()
    }
}
