//
//  DiningViewV2.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 23.11.24.
//

import SwiftUI
import VVUIKit

protocol EateriesListScreenViewModelProtocol {
	var screenState: ScreenState {get set}
	var showSlotBookSheet: Bool {get set}
	var showFilterSheet: Bool {get set}
	var showEditSlotBookSheet: Bool {get set}
	var filter: EateriesSlotsInputModel {get set}
    var showSoldOutSheet: Bool { get set }

	var eateriesList: EateriesList {get}
	var isEateriesSlotsLoading: Bool {get}
	var newBookingViewModel: EaterySlotBookViewModel? {get}
	var editBookingViewModel: EditBookingSheetViewModel? {get}
	var eateriesWithSlots: EateriesSlots {get}
	var availableSailors: [SailorModel] {get}
	var showPreviewMyAgendaSheet: Bool {get set}
	var itineraryDates: [ItineraryDay] {get}
	var showAddTocalendarSheet: Bool {get set}
	var portNameOrSeaDayText: String? { get }
	var errorOnLoadingSlots: Bool { get }
    var infoDrawerModel: InfoDrawerModel { get }

	func onFirstAppear()
	func onReAppear()
	func onRefresh()
	func onDateChanged()
	func onFilterChanged(date: Date, mealPeriod: MealPeriod, selectedSailors: [SailorModel])
	func onSlotClick(eatery: EateriesSlots.Restaurant, slot: Slot)
	func onBookCompleted()
	func onFilterButtonClick()
	func onEditEateryWithSlotsButtonClick(eatery: EateriesSlots.Restaurant)
	func onEditBookingCompleted()
	func onChangePartySize()
	func onPreviewMyAgendaClick()
	func onPreviewMyAgendaSheetDismiss()
	func onAddToCalendarClick()
	func onEditBookingSheetDismiss()
	func onBookingCanceled()
	func onNewBookingSheetDismiss()
    func onReadMoreClick(eatery: EateriesSlots.Restaurant)
    func onReadMoreDismiss()
}

struct EateriesListScreen: View {
    @State var viewModel: EateriesListScreenViewModelProtocol
    @State private var selectedEatery: EateriesList.Eatery?
    @State private var showPinnedBookablesHeader = true
    @State private var showPinnedWalkInEateriesHeader = false
    let onDetailsClick: ((String, EateriesSlotsInputModel) -> Void)?
    let onBackClick: VoidCallback?
    let onViewAllOpeningTimesClick: ((EateriesSlotsInputModel) -> Void)?

    init(viewModel: EateriesListScreenViewModelProtocol = EateriesListScreenViewModel(),
         onDetailsClick: ((String, EateriesSlotsInputModel) -> Void)? = nil,
         onBackClick: VoidCallback? = nil,
         onViewAllOpeningTimesClick: ((EateriesSlotsInputModel) -> Void)? = nil) {

        _viewModel = State(wrappedValue: viewModel)

        self.onDetailsClick = onDetailsClick
        self.onBackClick = onBackClick
        self.onViewAllOpeningTimesClick = onViewAllOpeningTimesClick
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
                ScrollView {
                    VStack(spacing: 0) {
                        HStack(alignment: .top) {
                            BackButton(onBackClick ?? {})
                                .opacity(0.8)
                            Spacer()
                        }
                        .padding(.leading, Paddings.defaultVerticalPadding24)

                        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                            bookables()
                            walkInEateries()
                        }
                    }
                }
                .ignoresSafeArea(edges: .top)
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(SectionHeaderOffsetKey.self) { offsets in
                    if let bookablesY = offsets["bookables"] {
                        let shouldShow = bookablesY > 10
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showPinnedBookablesHeader = shouldShow
                        }
                    }

                    if let walkinsY = offsets["walkins"] {
                        let shouldShow = walkinsY < 10
                          withAnimation(.easeInOut(duration: 0.2)) {
                              showPinnedWalkInEateriesHeader = shouldShow
                          }
                      }
            }
            .sheet(isPresented: $viewModel.showSlotBookSheet) {
                if let newBookingViewModel = viewModel.newBookingViewModel {
                    EaterySlotBookSheet(viewModel: newBookingViewModel,
                                        onBooked: {
                        viewModel.onBookCompleted()
                    }, onCancelClick: {
                        viewModel.onNewBookingSheetDismiss()
                    }, onChangePartySizeClick: {
                        viewModel.onChangePartySize()
                    })
                }
            }.sheet(isPresented: $viewModel.showFilterSheet) {
                EateriesFilterSheet(filter: viewModel.filter,
                                    availableSailors: viewModel.availableSailors,
                                    availableDates:viewModel.itineraryDates.getDates(),
                                    infoDrawerModel: InfoDrawerModel(title: viewModel.eateriesList.resources.partySizeInfoDrawerHeading, description: viewModel.eateriesList.resources.partySizeInfoDrawerBody, buttonTitle: viewModel.eateriesList.resources.gotItCta),
                                    onSearch: {
                    (date, mealPeriod, selectedSailors) in
                    viewModel.onFilterChanged(date: date, mealPeriod: mealPeriod, selectedSailors: selectedSailors)
                })
            }
            .sheet(isPresented: $viewModel.showEditSlotBookSheet) {
                if viewModel.eateriesList.preVoyageBookingStoppedInfo != nil {
                    PreVoyageEditingModal {
                        viewModel.onEditBookingSheetDismiss()
                    }
                } else if let editBookingViewModel = viewModel.editBookingViewModel {
                    EditEateryBookingSheet(viewModel: editBookingViewModel,
                                           onBooked: {
                        viewModel.onEditBookingCompleted()
                    },
                                           onDismiss: {
                        viewModel.onEditBookingSheetDismiss()
                    },
                                           onCanceled: {
                        viewModel.onBookingCanceled()
                    })
                }
            }.sheet(isPresented: $viewModel.showPreviewMyAgendaSheet) {
                PreviewMyAgendaSheet(date: viewModel.filter.searchSlotDate, onDismiss: {
                    viewModel.onPreviewMyAgendaSheetDismiss()
                })
            }
            .sheet(isPresented: $viewModel.showAddTocalendarSheet) {
                if let leadTime = viewModel.eateriesList.leadTime {
                    EventCalendarEditView(title: "Virgin Voyages - Restaurant booking opens", startDate: leadTime.date, endDate: leadTime.date)
                }
            }
            .sheet(isPresented: $viewModel.showSoldOutSheet) {
                InfoDrawerView(
                    title: viewModel.infoDrawerModel.title,
                    description: viewModel.infoDrawerModel.description,
                    buttonTitle: viewModel.infoDrawerModel.buttonTitle) {
                    viewModel.onReadMoreDismiss()
                }
                .presentationDetents([.height(450)])
            }
        } onRefresh: {
            viewModel.onRefresh()
        }
        .onAppear(onFirstAppear: {
            viewModel.onFirstAppear()
        }, onReAppear: {
            viewModel.onReAppear()
        })
        .padding(.top, Paddings.defaultVerticalPadding16)
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
    }
    
    private func bookables() -> some View {
        Section(header: bookablesHeaderView()
        ) {
            VStack(spacing: Paddings.defaultVerticalPadding16) {
                ForEach(viewModel.eateriesList.bookable, id: \.id) { bookable in
                    Card(
                        title: bookable.name,
                        imageUrl: bookable.squareThumbnailUrl,
                        subheading: bookable.subHeading,
                        onTap: {
                            onDetailsClick?(bookable.slug, viewModel.filter)
                        },
                        footer: {
                            eateryWithSlots(externalId: bookable.externalId, venueId: bookable.venueId)
                        }
                    )
                }
            }
            .padding(.horizontal, Paddings.defaultVerticalPadding24)
            .padding(.vertical, Paddings.defaultVerticalPadding16)
        }
    }
    
    private func bookablesHeaderView() -> some View {
        VStack(spacing: Paddings.defaultVerticalPadding24) {
            VStack(spacing: Paddings.defaultPadding8) {
                Text("Restaurants")
                    .font(.vvHeading2Bold)
                    .foregroundColor(Color.charcoalBlack)
                    .multilineTextAlignment(.center)
                
                if showPinnedBookablesHeader {
                    Text("Booking advised")
                        .fontStyle(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)

            if let leadTime = viewModel.eateriesList.leadTime {
                EateryLeadTimeView(title: leadTime.title,
                                   subtitle: leadTime.subtitle,
                                   description: leadTime.description,
                                   date: leadTime.date) {
                    viewModel.onAddToCalendarClick()
                }
                .padding(.horizontal, Spacing.space24)
            } else if let preVoyageBookingStoppedInfo = viewModel.eateriesList.preVoyageBookingStoppedInfo {
                EateryBookingStoppedView(title: preVoyageBookingStoppedInfo.title, description: preVoyageBookingStoppedInfo.description)
                    .padding(.horizontal, Spacing.space24)
            } else {
                slotFilter()
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, Paddings.defaultVerticalPadding16)
        .background(
             GeometryReader { geo in
                 Color.white.preference(
                     key: SectionHeaderOffsetKey.self,
                     value: ["bookables": geo.frame(in: .named("scroll")).minY]
                 )
             }
         )
    }

    private func slotFilter() -> some View {
        VStack(alignment: .center, spacing: Paddings.defaultVerticalPadding24) {
            if showPinnedBookablesHeader {
                Button {
                    viewModel.onFilterButtonClick()
                } label: {
                    HStack {
                        Text(viewModel.filter.mealPeriod.rawValue.capitalizedFirstLetter())
                        Image(systemName: "person")
                        Text("\(viewModel.filter.guests.count)")
                    }
                    .contentStyle()
                }
                .fontStyle(.button)
                .buttonStyle(BorderedProminentButtonStyle())
                .clipShape(Capsule())
            }

            VStack {
                DateSelector(selected: $viewModel.filter.searchSlotDate, options: viewModel.itineraryDates.getDates())
                    .onChange(of: viewModel.filter.searchSlotDate) {
                        viewModel.onDateChanged()
                    }
            }.padding(.horizontal, Paddings.defaultVerticalPadding16)

            VStack(spacing: 10) {
                if let portNameOrSeaDayText = viewModel.portNameOrSeaDayText {
                    Text(portNameOrSeaDayText)
                        .fontStyle(.body)
                        .foregroundStyle(.secondary)
                }

                Button {
                    viewModel.onPreviewMyAgendaClick()
                } label: {
                    Text("Preview My Agenda")
                        .font(.vvBody)
                        .foregroundColor(Color.darkGray)
                        .underline()
                }
            }
        }
    }

    private func eateryWithSlots(externalId: String, venueId: String) -> some View {
        if viewModel.eateriesList.isPreVoyageBookingStopped {
            AnyView(
                HStack(alignment:.top) {
                    Text("Booking closed")
                        .font(.vvSmall)
                        .foregroundColor(Color.slateGray)

                    Spacer()
                }.padding(Spacing.space16)
            )
        } else if viewModel.errorOnLoadingSlots {
            AnyView(
                EaterySlotsErrorView()
            )
        } else if let eatery = viewModel.eateriesWithSlots.find(byExternalId: externalId, byVenueId: venueId) {
            AnyView (
                EaterySlotsView(eatery: eatery,
                                isLoading: viewModel.isEateriesSlotsLoading,
                                slotsPadding : Spacing.space16,
                                readMoreText: viewModel.eateriesList.resources.soldOutReadMore,
                                onSlotClick: { viewModel.onSlotClick(eatery:$0, slot: $1) },
                                onEditClick: { viewModel.onEditEateryWithSlotsButtonClick(eatery: $0)},
                                onReadMoreClick: {viewModel.onReadMoreClick(eatery: $0) }
                               )
            )
        } else  {
            AnyView(
                EmptyView()
            )
        }
    }
    
    private func walkInEateries() -> some View {
        Section(header: walkInEateriesHeader()
        ) {
            VStack(spacing: Paddings.defaultVerticalPadding16) {
                ForEach(viewModel.eateriesList.walkIns, id: \.id) { eatery in
                    Card(
                        title: eatery.name,
                        imageUrl: eatery.squareThumbnailUrl,
                        subheading: eatery.subHeading,
                        onTap: {
                            onDetailsClick?(eatery.slug, viewModel.filter)
                        }
                    )
                }
            }
            .padding(.horizontal, Paddings.defaultVerticalPadding24)
            .padding(.vertical, Paddings.defaultVerticalPadding16)
        }
    }

    private func walkInEateriesHeader() -> some View {
        VStack(spacing: Paddings.defaultVerticalPadding24) {
            VStack(spacing: Paddings.defaultPadding8) {
                Text("Walk-in Eateries")
                    .fontStyle(.largeTitle)
                    .multilineTextAlignment(.center)

                if !showPinnedWalkInEateriesHeader {
                    Text("No bookings required - open all times of the day… and night!")
                        .fontStyle(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }

            Button(action: {
                onViewAllOpeningTimesClick?(viewModel.filter)
            }) {
                Text("View all Opening Times")
                    .padding(Paddings.defaultPadding8)
            }
            .buttonStyle(BorderedProminentButtonStyle())
            .clipShape(Capsule())
            .tint(Color("Ink Highlight"))
            .fontStyle(.smallButton)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, Paddings.defaultVerticalPadding24)
        .padding(.vertical, Paddings.defaultVerticalPadding32)
        .background(
              GeometryReader { geo in
                  Color.white.preference(
                      key: SectionHeaderOffsetKey.self,
                      value: ["walkins": geo.frame(in: .named("scroll")).minY]
                  )
              }
          )
    }
}

struct SectionHeaderOffsetKey: PreferenceKey {
    static var defaultValue: [String: CGFloat] = [:]
    static func reduce(value: inout [String: CGFloat], nextValue: () -> [String: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

#Preview("Eateries List Screen") {
	EateriesListScreen(viewModel: EateriesListScreenPreviewViewModel())
}

#Preview("Eateries List Screen with lead time") {
	EateriesListScreen(viewModel: EateriesListScreenPreviewViewModel(eateriesList: .sampleWithLeadTime(),
																	 eateriesWithSlots: .empty()))
}

#Preview("Eateries List Screen with Pre voyage booking stopped") {
	EateriesListScreen(viewModel: EateriesListScreenPreviewViewModel(eateriesList: .sampleWithPreVoyageBookingStoppedInfo(),
																	 eateriesWithSlots: .empty()))
}

struct EateriesListScreenPreviewViewModel: EateriesListScreenViewModelProtocol {
	var screenState: ScreenState = .content
	var showSlotBookSheet: Bool = false
	var showFilterSheet: Bool = false
	var showEditSlotBookSheet: Bool = false
	var showPreviewMyAgendaSheet: Bool = false
	var itineraryDates: [ItineraryDay] = []
	
	var filter: EateriesSlotsInputModel = EateriesSlotsInputModel.sample
	var eateriesList: EateriesList
	
	var isEateriesSlotsLoading: Bool = false
	var eateriesWithSlots: EateriesSlots
	var availableSailors: [SailorModel] = []
	var showAddTocalendarSheet: Bool = false
	
	var newBookingViewModel: EaterySlotBookViewModel? = nil
	var editBookingViewModel: EditBookingSheetViewModel? = nil
	var errorOnLoadingSlots: Bool = false
    var showSoldOutSheet: Bool = false
    var infoDrawerModel: InfoDrawerModel = .empty()

	var portNameOrSeaDayText: String? {
		guard let itinerary = itineraryDates.findItinerary(for: filter.searchSlotDate) else {
			return nil
		}
		return itinerary.isSeaDay ? "Sea day" : itinerary.portName
	}
	
	init(eateriesList: EateriesList = EateriesList.sample(),
		 eateriesWithSlots: EateriesSlots = EateriesSlots.sample()) {
		self.eateriesList = eateriesList
		self.eateriesWithSlots = eateriesWithSlots
		self.itineraryDates = ItineraryDay.samples()
	}
	
	func onFirstAppear() {
		
	}
	
	func onReAppear() {
		
	}
	
	func onRefresh() {
		
	}
	
	func onDateChanged() {
		
	}
	
	func onFilterChanged(date: Date, mealPeriod: MealPeriod, selectedSailors: [SailorModel]) {
		
	}
	
	func onBookCompleted() {
		
	}
	
	func onFilterButtonClick() {
		
	}
	
	func onEditBookingCompleted() {
		
	}
	
	func onNewSailorAdded() {
		
	}
	
	func onChangePartySize() {
		
	}
	
	func onPreviewMyAgendaClick() {
		
	}
	
	func onPreviewMyAgendaSheetDismiss() {
		
	}
	
	func onAddToCalendarClick() {
		
	}
	
	func onEditBookingSheetDismiss() {
	
	}
	
	func onBookingCanceled() {
	
	}
	
	func onNewBookingSheetDismiss() {
		
	}
	
	func onSlotClick(eatery: EateriesSlots.Restaurant, slot: Slot) {
		
	}
	
	func onEditEateryWithSlotsButtonClick(eatery: EateriesSlots.Restaurant) {
		
	}

    func onReadMoreClick(eatery: EateriesSlots.Restaurant) {}

    func onReadMoreDismiss() {}
}
