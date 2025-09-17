//
//  PreviewMyAgendaSheetViewModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 3.4.25.
//

import SwiftUI
import VVUIKit

protocol PreviewMyAgendaSheetViewModelProtocol {
	var screenState: ScreenState {get set}
	var myVoyageAgenda: MyVoyageAgenda {get}
	var date: Date {get}
	var portName: String? {get}
    var resources: MyAgendaLocalizationResources { get }

	func onAppear()
	func onRefresh()
}

struct PreviewMyAgendaSheet: View {
	let onDismiss: VoidCallback?
	
	@State var viewModel: PreviewMyAgendaSheetViewModelProtocol
	
	
	init(date:Date, portName: String? = nil, onDismiss: VoidCallback? = nil) {
		self.init(viewModel: PreviewMyAgendaSheetViewModel(date: date), onDismiss: onDismiss)
	}
	
	init(viewModel: PreviewMyAgendaSheetViewModelProtocol, onDismiss: VoidCallback? = nil) {
		_viewModel = State(wrappedValue: viewModel)
		self.onDismiss = onDismiss
	}
	
	var body: some View {
		VVUIKit.ContentView(backgroundColor: .white) {
			DefaultScreenView(state: $viewModel.screenState) {
				VStack(spacing: Spacing.space32) {
					HStack {
						Spacer()
						XClosableButton {
							onDismiss?()
						}
					}
					
					VStack(spacing: Spacing.space8) {
						Text(viewModel.date.toWeekdayDay())
							.font(.vvHeading5Bold)
							.tint(.charcoalBlack)
						
						if let portName = viewModel.portName, !portName.isEmpty {
                            Text(viewModel.resources.portDayLabel)
								.font(.vvBody)
								.foregroundColor(.slateGray)
						}
						
                        Text (viewModel.resources.yourPreviewAgendaText)
							.font(.vvBody)
							.foregroundColor(.slateGray)
					}

                    if viewModel.myVoyageAgenda.appointments.isEmpty {
                        noBookingsPreview()
                    } else {
                        EventCardView()
                    }

				}.padding(Spacing.space16)
			}onRefresh: {
				viewModel.onRefresh()
			}
			.onAppear {
				viewModel.onAppear()
			}
		}
	}

    private func noBookingsPreview() -> some View {
        VStack(spacing: Spacing.space32) {
            Image(.restaurants)
                .resizable()
                .frame(width: Spacing.space64, height: Spacing.space64, alignment: .center)

            Text(viewModel.resources.emptyAgendaMessage)
                .font(.vvBody)
                .foregroundStyle(Color.slateGray)
                .multilineTextAlignment(.center)
        }
        .padding(Spacing.space16)
        .padding(.top, Spacing.space16)
    }

    private func EventCardView() -> some View {
        VStack(spacing: Spacing.space16) {
            ForEach(viewModel.myVoyageAgenda.appointments, id: \.uuid) { appointment in
                EventCard(name: appointment.name,
                          timePeriod: appointment.timePeriod,
                          location: appointment.location,
                          isBookable: true,
                          isBooked: true,
                          isNonInventoried: appointment.inventoryState == .nonInventoried,
                          imageUrl: appointment.imageUrl)
            }
        }
    }
}


#Preview("Eateries Preview My Agenda Sheet") {
	PreviewMyAgendaSheet(viewModel: MockEateriesPreviewMyAgendaSheetViewModel())
}

#Preview("Eateries Preview My Agenda Sheet Where is no bookings per that day") {
    PreviewMyAgendaSheet(viewModel: MockEateriesPreviewMyAgendaSheetViewModel(myVoyageAgenda: .noAppointments()))
}


struct MockEateriesPreviewMyAgendaSheetViewModel : PreviewMyAgendaSheetViewModelProtocol {
	var screenState: ScreenState = .content
	var date: Date
	var myVoyageAgenda: MyVoyageAgenda
	var portName: String?
    var resources: MyAgendaLocalizationResources = .defaultResources()

	init(date: Date = Date(), myVoyageAgenda: MyVoyageAgenda = MyVoyageAgenda.sample(), portName: String? = nil) {
		self.date = date
		self.myVoyageAgenda = myVoyageAgenda
		self.portName = portName
	}
	
	func onAppear() {}
	
	func onRefresh() {}
}
