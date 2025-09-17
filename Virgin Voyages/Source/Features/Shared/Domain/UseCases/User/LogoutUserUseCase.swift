//
//  LogoutUserUseCase.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 31.10.24.
//

import Foundation


protocol LogoutUserUseCaseProtocol {
    func execute() async
}

class LogoutUserUseCase: LogoutUserUseCaseProtocol {
    private let authenticationEventNotificationService: AuthenticationEventNotificationService
	private let authenticationService: AuthenticationServiceProtocol
    private let chatPollingService: ChatPollingServiceProtocol
	private var unregisterPushNotificationDeviceTokenUseCase: UnregisterPushNotificationDeviceTokenUseCaseProtocol
	private let cacheService: NetworkCacheStoreProtocol
    private let webSocketUseCase: WebSocketUseCaseProtocol
    private var broadcastService: BroadcastServiceProtocol
    
    init(
        authenticationEventNotificationService: AuthenticationEventNotificationService = .shared,
		authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared,
		chatPollingService: ChatPollingServiceProtocol = ChatPollingService.shared,
		unregisterPushNotificationDeviceTokenUseCase: UnregisterPushNotificationDeviceTokenUseCaseProtocol = UnregisterPushNotificationDeviceTokenUseCase(),
		cacheService: NetworkCacheStoreProtocol = PersistedNetworkCacheStore.shared,
        webSocketUseCase: WebSocketUseCaseProtocol = WebSocketUseCase(),
        broadcastService: BroadcastServiceProtocol = BroadcastService.shared
	) {
        self.authenticationEventNotificationService = authenticationEventNotificationService
		self.authenticationService = authenticationService
        self.chatPollingService = chatPollingService
		self.unregisterPushNotificationDeviceTokenUseCase = unregisterPushNotificationDeviceTokenUseCase
		self.cacheService = cacheService
        self.webSocketUseCase = webSocketUseCase
        self.broadcastService = broadcastService 
    }

    func execute() async {
		guard authenticationService.isLoggedIn() else {
            // Publish event
            self.authenticationEventNotificationService.publish(.userDidLogOut)
			return
		}

		let _ = await self.unregisterPushNotificationDeviceTokenUseCase.execute()
		self.chatPollingService.stopPolling()
		self.cacheService.removeAllData()
        self.broadcastService.stopBroadcasting()
        
        // TODO: need to manage the start and stop listening on user signin and signout
        // self.webSocketUseCase.stop()

		await authenticationService.signOut()
        // Publish event
        self.authenticationEventNotificationService.publish(.userDidLogOut)
    }
}
