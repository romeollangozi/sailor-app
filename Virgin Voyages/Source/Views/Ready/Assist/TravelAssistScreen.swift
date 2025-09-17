//
//  TravelAssistScreen.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/24/24.
//

import SwiftUI
import VVUIKit

struct TravelAssistScreen: View {
	var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
    @Environment(\.dismiss) var dismiss
    let appCoordinator: AppCoordinator = .shared

	var assist: Endpoint.GetTravelPartyAssist.Response
    var body: some View {
		ScrollView {
            HStack {
                BackButton({
                    dismiss()
                }, isCircleButton: true)
                .opacity(0.8)
                Spacer()
            }
            .padding(.leading)
            .padding(.top)
            
            VStack(alignment: .leading, spacing: 25) {
                Text(assist.landingPage.header)
                    .fontStyle(.largeTitle)

                Text(assist.landingPage.description)
                    .fontStyle(.body)
                    .foregroundStyle(.white.opacity(0.7))

                if !assist.incompleteTaskSailors.isEmpty {
                    Text(assist.landingPage.inCompleteTaskCaption)
                        .fontStyle(.headline)
                        .textCase(.uppercase)

                    ForEach(assist.incompleteTaskSailors, id: \.reservationGuestId) { sailor in
                        Button {
                            if let reservationId = authenticationService.reservation?.reservationId {
                                let sailor = Sailor(id: sailor.reservationGuestId, userId: "", reservationId: reservationId, reservationNumber: sailor.reservationNumber,  firstName: "", lastName: "", displayName: sailor.name)

                                showRTSView(sailor: sailor)
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(sailor.name)
                                        .fontStyle(.headline)
                                    Text(sailor.outstandingTasksText)
                                        .fontStyle(.body)
                                        .foregroundStyle(.white.opacity(0.7))
                                }
                                .tint(.primary)
                                Spacer()
                                Image(systemName: "arrow.right")
                                    .imageScale(.large)
                            }
                        }
                        Divider()
                            .frame(height: 1)
                            .overlay(Color.vvGray)
                    }
                }

                if !assist.completedTaskSailors.isEmpty {
                    Text(assist.landingPage.completedTaskCaption)
                        .fontStyle(.headline)
                        .textCase(.uppercase)

                    ForEach(assist.completedTaskSailors, id: \.reservationGuestId) { sailor in
                        Button {
                            if let reservationId = authenticationService.reservation?.reservationId {
                                let sailor = Sailor(id: sailor.reservationGuestId, userId: "", reservationId: reservationId, reservationNumber: sailor.reservationNumber,  firstName: "", lastName: "", displayName: sailor.name)

                                showRTSView(sailor: sailor)
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(sailor.name)
                                        .fontStyle(.headline)
                                    Text(sailor.outstandingTasksText)
                                        .fontStyle(.body)
                                        .foregroundStyle(.white.opacity(0.7))
                                }
                                .tint(.primary)
                                Spacer()
                                Image(systemName: "arrow.right")
                                    .imageScale(.large)
                            }
                        }
                        Divider()
                            .frame(height: 1)
                            .overlay(Color.vvGray)
                    }
                }
			}
			.padding()
		}
		.foregroundColor(.white)
		.background {
			Rectangle()
				.foregroundStyle(Color(hex: SailTask.welcome.backgroundColorCode))
				.edgesIgnoringSafeArea(.all)
			
			LinearGradient(colors: [.black.opacity(0.6), .black], startPoint: .top, endPoint: .bottom)
				.edgesIgnoringSafeArea(.all)
		}
    }

    func showRTSView(sailor: Sailor?) {
        appCoordinator.homeTabBarCoordinator.homeDashboardCoordinator.fullScreenRouter = .rts(sailor: sailor, dashboardTask: nil)
    }
}
