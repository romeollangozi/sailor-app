//
//  ReadyView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/17/23.
//

import SwiftUI
import VVUIKit

struct ReadyView: View {
	var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
	@Environment(\.dismiss) var dismiss
	var sailor: Sailor?
    @State var dashboardTask: TaskDetail?
    
    private let getHomeRTSDetailsUseCase: GetHomeRTSDetailsUseCaseProtocol = GetHomeRTSDetailsUseCase()

	@State private var selectedTask: SailTask?
	@State private var showRTS = false
	@State private var content: Model.Content?
    @State private var isComplete = false
    var rtsCompletionVideoPlayer: LoopingVideoPlayer {
        let url = Bundle.main.url(forResource: "RTSCompletion", withExtension: "mp4")!
        return LoopingVideoPlayer(asset: .init(url: url))
    }

	var body: some View {
		ScreenView(name: sailor?.displayName ?? dashboardTask?.title ?? "Ready to Sail", viewModel: Model(sailor: sailor), content: $content) { sail in
			ZStack {
				if !showRTS && sail.isComplete {
                    ReadyCompletionScreen(showRTS: $showRTS, videoPlayer: rtsCompletionVideoPlayer)
				} else {
                    ReadyScreen(sail: sail, pagedTask: sail.nextTask, selectedTask: $selectedTask, isComplete: $isComplete)
				}
			}
            .onChange(of: isComplete) {
                showRTS = !isComplete
				content = try? authenticationService.currentSailor().load(Model(sailor: sailor))
            }
			.animation(.easeIn, value: sail.isComplete)
		}
		.task {
            authenticationService.setAssistingSailor(sailor: sailor)
		}
		.animation(.easeIn, value: showRTS)
        .onAppear {
            if dashboardTask == nil {
                Task {
                    let result = try await self.getHomeRTSDetailsUseCase.execute()
                    self.dashboardTask = result
                }
            }
        }
	}
	
	struct Model: Viewable {
		typealias Content = ReadyToSail
		var requiresRefresh = true
		var showsTitle = false
		var sailor: Sailor?
		
		func fetch(authentication: Endpoint.SailorAuthentication) async throws -> Content {
			try await authentication.fetch(content(authentication.reservation))
		}
		
		func load(authentication: Endpoint.SailorAuthentication) throws -> Content? {
			try authentication.load(content(authentication.reservation))
		}
		
		private func content(_ reservation: VoyageReservation) -> Endpoint.GetReadyToSail {
			Endpoint.GetReadyToSail(reservation: reservation)
		}
	}
}
