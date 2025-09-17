//
//  HomePlannerOnboardView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 23.3.25.
//

import SwiftUI
import VVUIKit

struct HomePlannerOnboardView: View {
    @State private var viewModel: HomePlannerOnboardViewModelProtocol
    
    init(viewModel: HomePlannerOnboardViewModelProtocol = HomePlannerOnboardViewModel()) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            VStack(alignment: .leading, spacing: Spacing.space12) {
                header()
                
                VStack(alignment: .leading, spacing: .zero) {
                    nextEatery()
                    
                    nextActivity()
                    
                    upcomingEvents()
                    
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 1)
                        .shadow(color: Color.black.opacity(0.07), radius: 48, x: 0, y: 8)
                )
                .padding(.horizontal, Spacing.space16)
                
                Spacer()
            }
        } onRefresh: {}
        .onAppear() {
            viewModel.onAppear()
        }
        .background(Color.white)
    }
    
    private func header() -> some View {
        HStack {
            Text("Your Day")
                .font(.vvHeading4Bold)
            Spacer()
            Button(action: {
                viewModel.didTapMyAgenda()
            }) {
                HStack(spacing: .zero) {
                    Text("View your Agenda")
                        .font(.vvBodyMedium)
                        .foregroundColor(Color.darkGrayText)
                    Image("ChevronRight")
                }
            }
        }
        .background(Color.white)
        .padding(Spacing.space16)
    }
    
    private func nextEatery() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space12) {
            Text("Today")
                .font(.vvHeading1Bold)
            if !viewModel.homePlanner.nextEatery.name.isEmpty {
                Button(action: {
                    viewModel.didTapEatery()
                }) {
                    PlannerCardView(
                        icon: "CheckCircleBlue",
                        text: "Dinner booked at ",
                        highlightedText: viewModel.homePlanner.nextEatery.name + " at " + viewModel.homePlanner.nextEatery.time
                    )
                }
            }
        }
        .padding(Spacing.space16)
    }
    
    private func nextActivity() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space12) {
            Text("My next activity")
                .font(.vvBodyBold)
                .foregroundColor(.blackText)
            if !viewModel.homePlanner.nextActivity.appointmentId.isEmpty {
                Button(action: {
                    viewModel.didTapAppointment(appointment: viewModel.homePlanner.nextActivity)
                }) {
					EventCard(name: viewModel.homePlanner.nextActivity.title,
							  timePeriod: viewModel.homePlanner.nextActivity.time,
							  location: viewModel.homePlanner.nextActivity.location,
							  isBookable: true,
							  isBooked: true,
                              isNonInventoried: viewModel.isNonInventoried,
							  imageUrl: viewModel.homePlanner.nextActivity.imageUrl)
                    .frame(maxHeight: Spacing.space128)
                }
            } else {
                PlannerPlaceholderView(image: "ConfirmationNumber", title: "You have no bookings today")
            }
        }
        .padding(Spacing.space16)
        .background(Color.white)
        .overlay(
            Rectangle()
                .stroke(Color(red: 16/255, green: 16/255, blue: 16/255, opacity: 0.1), lineWidth: 1)
                .frame(maxWidth: .infinity, alignment: .bottom)
                .foregroundColor(.white)
        )
        
    }
    
    private func upcomingEvents() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space16) {
            Text("What’s next on today’s lineup")
                .font(.vvBodyBold)
                .foregroundColor(Color.blackText)
            
            if !viewModel.homePlanner.upcomingEntertainments.isEmpty {
                HStack(spacing: Spacing.space12) {
                    let upcomingEntertainments = viewModel.getVisibleUpcomingEntertainments()
                    DottedLineView(height: CGFloat(upcomingEntertainments.count * 55))
                        .padding(.top, Spacing.space24)
                    
                    VStack(spacing: 10) {
                        ForEach(upcomingEntertainments, id: \.uuid) { entertainment in
                            EntertainmentView(
                                title: entertainment.title,
                                timePeriod: entertainment.timePeriod,
                                location: entertainment.location
                            )
                        }
                    }
                    .padding(.vertical, Spacing.space16)
                }
            } else {
                PlannerPlaceholderView(image: "", title: "That's it for today - get your beauty sleep")
            }
            
            Button(action: {
                viewModel.didTapLineUpEvent()
            }) {
                HStack(spacing: .zero) {
                    Text("View the Event Line-up")
                        .font(.vvBodyMedium)
                        .foregroundColor(Color.darkGrayText)
                    Image("ChevronRight")
                }
                .padding(.leading, Spacing.space8)
                .padding(.vertical, Spacing.space16)
            }
        }
        .padding(.top, Spacing.space24)
        .padding(.horizontal, Spacing.space16)
        .padding(.bottom, Spacing.space16)
    }
}

#Preview {
    let viewModel = HomePlannerOnboardViewModel(homePlanner: HomePlannerSection.sample())
    HomePlannerOnboardView(viewModel: viewModel)
}
