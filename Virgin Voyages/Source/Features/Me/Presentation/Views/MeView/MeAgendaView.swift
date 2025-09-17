//
//  MeAgendaView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 7.3.25.
//

import SwiftUI
import VVUIKit


@MainActor
struct MeAgendaView: View  {
    @State private var viewModel: MeViewModelProtocol
    private let onAppointmentClick: (MyVoyageAgenda.Appointment) -> Void
    private let onLineUpClick: () -> Void

    init(
        viewModel: MeViewModelProtocol,
        onAppointmentClick: @escaping (MyVoyageAgenda.Appointment) -> Void,
        onLineUpClick: @escaping () -> Void
    ) {
        _viewModel = State(wrappedValue: viewModel)
        self.onAppointmentClick = onAppointmentClick
        self.onLineUpClick = onLineUpClick
    }

    var body: some View {

        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                if viewModel.myAppointmentsForDay.isEmpty {
                    MeEmptyStateView(
                        imageUrl: viewModel.myVoyageAgenda.emptyStatePictogramUrl,
                        message: viewModel.myVoyageAgenda.emptyStateText,
                        buttonTitle: viewModel.myVoyageHeader.buttonLineUpTitle,
                        showButton: viewModel.myVoyageHeader.isLineUpOpened,
                        action: onLineUpClick
                    )
                } else {
                    VStack(spacing: Spacing.space16) {
                        Text(viewModel.myVoyageAgenda.title)
                            .font(.vvBody)
                            .foregroundColor(.slateGray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.space16)
                            .padding(.top, Spacing.space32)
                            .padding(.bottom, Spacing.space16)

                        ForEach(viewModel.myAppointmentsForDay, id: \.uuid) { appointment in
                            EventCard(
                                name: appointment.name,
                                timePeriod: appointment.timePeriod,
                                location: appointment.location,
                                isBookable: true,
                                isBooked: true,
                                isNonInventoried: appointment.inventoryState == .nonInventoried,
                                imageUrl: appointment.imageUrl
                            )
                            .id(appointment.date) // used for scrollTo(Date)
                            .frame(maxHeight: Spacing.space128)
                            .onTapGesture { onAppointmentClick(appointment) }
                        }
                    }
                }
            }
            // Smooth-scroll to a specific time when requested
            .onChange(of: viewModel.scrollToTime) { _, newValue in
                if let time = newValue {
                    withAnimation {
                        proxy.scrollTo(time, anchor: .top)
                    }
                    viewModel.scrollToTime = nil
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Spacing.space16)
        .background(Color.softGray)
    }
}

#Preview {
    MeAgendaView(viewModel: MeViewModel(), onAppointmentClick: { _ in }, onLineUpClick: {})
}
