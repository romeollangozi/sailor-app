//
//  EateriesOpeningTimesScreen.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 3.12.24.
//

import SwiftUI
import VVUIKit

protocol EateriesOpeningTimesScreenViewModelProtocol {
	var screenState: ScreenState {get set}
	var itineraryDates: [Date] {get}
	var selectedDate: Date { get set }
	
	var eateriesOpeningTimes: EateriesOpeningTimesModel {get}
	
	func onAppear()
	func onRefresh()
	func onDateChanged()
}

struct EateriesOpeningTimesScreen: View {
	@State var viewModel: EateriesOpeningTimesScreenViewModelProtocol
	let filter: EateriesSlotsInputModel
	let onDetailsClick: ((String, String, Bool, EateriesSlotsInputModel) -> Void)?
	let onBackClick: VoidCallback?
	
	@State private var headerHeight: CGFloat = 0
	@State private var scrollOffset: CGFloat = 0

	init(viewModel: EateriesOpeningTimesScreenViewModelProtocol = EateriesOpeningTimesScreenViewModel(),
		 filter: EateriesSlotsInputModel,
		 onDetailsClick: ((String, String, Bool, EateriesSlotsInputModel) -> Void)? = nil,
		 onBackClick: VoidCallback? = nil) {
		_viewModel = State(wrappedValue: viewModel)
		self.onDetailsClick = onDetailsClick
		self.onBackClick = onBackClick
		self.filter = filter
	}

	var body: some View {
		ZStack(alignment: .top) {
            VStack (spacing: .zero) {
                Spacer().frame(height: headerHeight)
                ScrollView {
                    VStack {
                        ForEach(viewModel.eateriesOpeningTimes.venues, id: \.id) { x in
                            VStack(alignment: .leading) {
                                openingTimesSection(for: x)
                            }
                        }
                        
                    }
                    .background(TrackScrollOffset(yOffset: $scrollOffset))
                    .padding(.horizontal, Spacing.space16)
                    .padding(.bottom, Spacing.space16)
                }
                .coordinateSpace(name: "scroll")
            }
            
			header()
		}
		.navigationTitle("")
		.navigationBarBackButtonHidden(true)
		.onAppear {
			viewModel.onAppear()
		}
	}

	private func header() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space16) {
			BackButton(onBackClick ?? {})
				.padding(.horizontal, Spacing.space16)

			VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding32) {
				Text("Opening times at a glance")
					.font(.vvHeading2Bold)
					.textCase(.uppercase)

				DateSelector(selected: $viewModel.selectedDate, options: viewModel.itineraryDates)
					.onChange(of: viewModel.selectedDate) {
						viewModel.onDateChanged()
					}
			}
			.padding(Spacing.space16)
		}
		.background(GeometryReader { geometry in
			Color.clear
				.onAppear {
					headerHeight = geometry.size.height
				}
				
		})
		.background(Color.white.shadow(color: Color.black.opacity(scrollOffset < 20 ? 0.0 : 0.1), radius: 3, x: 0, y: 7))
		.zIndex(1)
		
	}

	private func openingTimesSection(for venue: EateriesOpeningTimesModel.Venue) -> some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading) {
				Text(venue.name)
					.font(.vvHeading4Bold)
					.textCase(.uppercase)

				Rectangle()
					.frame(height: 3)
			}

			Grid(verticalSpacing: Spacing.space16) {
				ForEach(venue.restaurants, id: \.id) { xx in
					HStack {
						Button(action: {
							onDetailsClick?(xx.slug, xx.venueId, xx.isBookable, filter)
						}) {
							Text(xx.name)
								.multilineTextAlignment(.leading)
								.font(.vvBody)
								.foregroundStyle(Color.black)
								.underline()
						}
						
						Spacer()
						
						Text(xx.operationalHours)
							.font(.vvBody)
							.foregroundStyle(Color.black)
                            .multilineTextAlignment(.trailing)
					}
				}
			}
		}
		.padding(.vertical, Spacing.space16)
	}
}


struct EateriesOpeningTimesScreen_Previews: PreviewProvider {
	struct MockPreviewViewModel: EateriesOpeningTimesScreenViewModelProtocol {
		var screenState: ScreenState
		var itineraryDates: [Date]
		var selectedDate: Date
		var eateriesOpeningTimes: EateriesOpeningTimesModel
		
		init() {
			screenState = .content
			itineraryDates = DateGenerator.generateDates(from: Date(), totalDays: 5)
			selectedDate = itineraryDates[0]
			eateriesOpeningTimes = EateriesOpeningTimesModel.sample
		}
		
		func onAppear() {
			
		}
		
		func onRefresh() {
			
		}
		
		func onDateChanged() {
			
		}
	}
	
	static var previews: some View {
		EateriesOpeningTimesScreen(viewModel: MockPreviewViewModel(), filter: EateriesSlotsInputModel.sample)
	}
}
