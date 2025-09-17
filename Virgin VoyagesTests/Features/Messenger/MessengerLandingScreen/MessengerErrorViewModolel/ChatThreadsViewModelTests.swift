//
//  ChatThreadsViewModelTests.swift
//  Virgin Voyages
//
//  Created by TX on 21.8.25.
//

import XCTest
@testable import Virgin_Voyages

@MainActor
final class ChatThreadsViewModelTests: XCTestCase {

    // Verifies successful fetch sets chatThreads, clears loading/error, and resets error VM
    func test_fetchChatThreads_success() async {
        let errorVM = MessengerErrorVMMock()
        let useCase = GetChatThreadsUseCaseMock(result: [.sample()])
        let vm = ChatThreadsViewModel(messengerErrorViewModel: errorVM,
                                      getChatThreadsUseCase: useCase)

        vm.isFirstLaunch = true
        vm.fetchChatThreads()

        try? await Task.sleep(nanoseconds: 150_000_000)
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.hasError)
        XCTAssertEqual(vm.chatThreads.count, 1)
        XCTAssertTrue(errorVM.resetCalled)
    }

    // Verifies failure path toggles hasError and clears loading
    func test_fetchChatThreads_failure_setsError() async {
        let errorVM = MessengerErrorVMMock()
        let useCase = GetChatThreadsUseCaseMock(result: nil) // simulate failure
        let vm = ChatThreadsViewModel(messengerErrorViewModel: errorVM,
                                      getChatThreadsUseCase: useCase)

        vm.isFirstLaunch = true
        vm.fetchChatThreads()

        try? await Task.sleep(nanoseconds: 150_000_000)
        XCTAssertTrue(vm.hasError)
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(errorVM.resetCalled)
    }

    // Verifies tryAgainTapped toggles loading, clears error, registers attempt, and triggers fetch
    func test_tryAgainTapped_registersAttemptAndFetches() async {
        let errorVM = MessengerErrorVMMock()
        let useCase = GetChatThreadsUseCaseMock(result: [.sample()])
        let vm = ChatThreadsViewModel(messengerErrorViewModel: errorVM,
                                      getChatThreadsUseCase: useCase)

        vm.hasError = true
        vm.tryAgainTapped()

        XCTAssertTrue(vm.isLoading)
        XCTAssertFalse(vm.hasError)
        XCTAssertEqual(errorVM.registerAttemptCount, 1)

        try? await Task.sleep(nanoseconds: 150_000_000)
        XCTAssertFalse(vm.isLoading)
        XCTAssertEqual(vm.chatThreads.count, 1)
    }


    // Verifies description text uses closed copy when isClosed == true
    func test_descriptionTextForChatThread_closedUsesClosedCopy() {
        
        let vm = ChatThreadsViewModel(messengerErrorViewModel: MessengerErrorVMMock(),
                                      getChatThreadsUseCase: GetChatThreadsUseCaseMock(result: []))

        let closed = ChatThread.sample(isClosed: true)
        XCTAssertEqual(vm.descriptionTextForChatThread(chatThread: closed), "Thread closed")

        let open = ChatThread.sample(isClosed: false, description:"hello")
        XCTAssertEqual(vm.descriptionTextForChatThread(chatThread: open), "hello")
    }

}
