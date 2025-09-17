//
//  ReadyScreen.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/17/23.
//

import SwiftUI
import VVUIKit

struct ReadyScreen: View {
	@State var infoSheetViewModel: InfoSheetViewModel
	var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
	@Environment(\.dismiss) private var dismiss
    @State var sail: ReadyToSail
	@State var pagedTask: SailTask?
	@Binding var selectedTask: SailTask?
    @Binding var isComplete: Bool
    var checkInStatusEventNotificationService: CheckInStatusEventNotificationService = .shared

	init(sail: ReadyToSail,
		 pagedTask: SailTask? = nil,
		 selectedTask: Binding<SailTask?>,
		 isComplete: Binding<Bool>,
		 infoSheetViewModel: InfoSheetViewModel = InfoSheetViewModel.shared
	) {
			self._sail = State(initialValue: sail)
			self._selectedTask = selectedTask
			self._isComplete = isComplete
			self._infoSheetViewModel = State(initialValue: infoSheetViewModel)
			self._pagedTask = State(initialValue: pagedTask)
		}

	var body: some View {
		VStack {
            ZStack {
                if let displayName = try? authenticationService.currentSailor().reservation.assistingSailor?.displayName {
                    Text(displayName)
                        .fontStyle(.button)
                        .foregroundStyle(.white)
                }

                HStack {
                    Spacer()
                    SailableCloseButton {
                        dismiss()
                    }
                }
            }
            .padding(.top)
            .padding(.horizontal, Paddings.defaultHorizontalPadding)

            ReadyPageControl(sail: sail, pagedTask: $pagedTask)
            ReadyTaskPicker(sail: sail, pagedTask: $pagedTask, selectedTask: $selectedTask)
		}
        .onChange(of: sail.isComplete) { _, completed in
            if completed {
                isComplete = true
            }
        }
        .onChange(of: sail.tasksCompletionPercentage) { oldValue, newValue in
            guard let task = pagedTask else { return }
            let oldPercent = oldValue.percent(for: task)
            let newPercent = newValue.percent(for: task)

            if oldPercent != newPercent {
                self.checkInStatusEventNotificationService.publish(.checkInHasChanged)
            }
        }
		.blur(radius: infoSheetViewModel.showInfoSheet ? 8.0 : 0)
		.animation(.easeInOut, value: infoSheetViewModel.showInfoSheet)
        .sheet(isPresented: $infoSheetViewModel.showInfoSheet) {
            InfoDrawerView(
                title: sail.landingIntroStart.answerModal.title,
                description: sail.landingIntroStart.answerModal.description) {
                    infoSheetViewModel.showInfoSheet = false
                }
                .presentationDetents([.fraction(0.33)])
        }
        .fullScreenCover(item: $selectedTask, onDismiss: {
            Task {
                let rts = try await authenticationService.currentSailor().fetch(ReadyView.Model())
                self.sail = rts
            }
        }, content: { task in
            NavigationStack {
                ZStack {
                    switch task {
                    case .securityPhoto:
                        SecurityPhotoView(sailTask: sail.task(task))

                    case .travelDocuments:
                        TravelDocumentsLandingView(onDismiss:{
                                selectedTask = nil
                            })
                    case .paymentMethod:
                        let sailTask = sail.task(task)
                        let imageURL = URL(string: sailTask.imageURL)
                        let backgroundColorCode = sailTask.backgroundColorCode
                        let backgroundColor = Color.init(hex: backgroundColorCode)
                        if let authentication = try? authenticationService.currentSailor() {
                            PaymentMethodScreen(viewModel: PaymentMethodScreenViewModel(imageURL: imageURL,
                                                                                        backgroundColor: backgroundColor,
                                                                                        repository: PaymentMethodRepository(authentication: authentication),
                                                                                        completionPercentage: sail.taskPercentCompletion(task)))
                        }

                    case .pregnancy:
                        PregnancyView(sailTask: sail.task(task))

                    case .voyageContract:
                        VoyageContractView(sailTask: sail.task(task))

                    case .emergencyContact:
                        EmergencyContactView(sailTask: sail.task(task))

                    case .stepAboard:
                        EmbarkationView(sailTask: sail.task(task), completionPercentage: sail.taskPercentCompletion(task))

                    case .welcome:
                        EmptyView()
                    }
                }
            }
        })
		.background {
			if let pagedTask {
				Rectangle()
					.foregroundStyle(Color(hex: sail.task(pagedTask).backgroundColorCode))
					.edgesIgnoringSafeArea(.all)
			}
			
			LinearGradient(colors: [.black.opacity(0.6), .black], startPoint: .top, endPoint: .bottom)
				.edgesIgnoringSafeArea(.all)
		}
        .onAppear {
            if let cabinMateSailor = try? authenticationService.currentSailor().reservation.assistingSailor {
                RtsCurrentSailorService.shared.setSailor(sailor: RtsCurrentSailor(reservationGuestId: cabinMateSailor.id))
            } else {
                if let primarySailor = try? authenticationService.currentSailor().reservation.primarySailor {
                    RtsCurrentSailorService.shared.setSailor(sailor: RtsCurrentSailor(reservationGuestId: primarySailor.id))
                }
            }
        }
	}
}
