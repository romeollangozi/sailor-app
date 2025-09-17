//
//  LineUpScreen.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 13.1.25.
//

import SwiftUI
import VVUIKit

protocol LineUpScreenViewModelProtocol {
    var screenState: ScreenState { get set }
	var lineUp: LineUp { get }
    var selectedDate: Date { get set }
	var itineraryDays: [ItineraryDay] { get }
    var isLoadingData: Bool { get }
    var openingTitle: String { get }
    var scrollToTime: String? { get set }
    var firstUpcomingEventIndex: Int { get }
    
    func onFirstAppear()
    func onReAppear()
    func onRefresh()
    func goToNextDate()
    func isNextDateAvailable() -> Bool
    func addToPlanner()
}

struct LineUpScreen: View {
    @State var viewModel: LineUpScreenViewModelProtocol
    @State private var showEventEditView = false
    @State private var showPinnedHeader = true
    @State private var showBackButton = true
    @State private var previousScrollOffset: CGFloat = 0
	private let onBackClick: VoidCallback
    private let onViewEventDetailsClick: (LineUpEvents.EventItem) -> Void

    init(
		viewModel: LineUpScreenViewModelProtocol = LineUpScreenViewModel(),
		onViewEventDetailsClick: @escaping (LineUpEvents.EventItem) -> Void,
		onBackClick: @escaping VoidCallback) {
        _viewModel = State(wrappedValue: viewModel)
        self.onViewEventDetailsClick = onViewEventDetailsClick
        self.onBackClick = onBackClick
    }

    var body: some View {
        ZStack {
            Color.softGray
                .ignoresSafeArea()

			if let leadTime = viewModel.lineUp.leadTime {
                VStack {
					openingTimeView(leadTime: leadTime)
                        .navigationBarBackButtonHidden(true)
                }.onAppear {
					viewModel.onReAppear()
                }
            } else {
                ScrollViewReader { proxy in
                    VStack(alignment: .center, spacing: Spacing.space16) {
                        DefaultScreenView(state: $viewModel.screenState) {
                            ScrollView {
                                VStack(spacing: .zero) {
                                    
                                    GeometryReader { geo in
                                        Color.clear.frame(height: 1).id("top")
                                            .preference(
                                                key: SectionHeaderOffsetKey.self,
                                                value: ["topOffset": geo.frame(in: .named("scroll")).minY]
                                            )
                                    }
                                    Spacer().frame(height: Paddings.defaultVerticalPadding24)
                                    
                                    LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                                        Section(header: header()) {
                                            if !viewModel.lineUp.events.isEmpty {
                                                events()
                                                VVUIKit.DoubleDivider()
                                            }
                                            footer()
                                        }
                                        .background(Color.white)
                                    }
                                }
                            }
                            .ignoresSafeArea(edges: .top)
                            .coordinateSpace(name: "scroll")
                            .padding(.top, Paddings.defaultVerticalPadding16)
                            .onPreferenceChange(SectionHeaderOffsetKey.self) { offsets in
                                handleScrollOffsets(offsets)
                            }
                        } onRefresh: {
                            viewModel.onRefresh()
                        }
                        .disabled(viewModel.isLoadingData)
                    }
                    .onAppear(onFirstAppear: {
                        viewModel.onFirstAppear()
                    }, onReAppear: {
                        viewModel.onReAppear()
                    })
                    .navigationTitle("")
                    .navigationBarBackButtonHidden(true)
                    .onChange(of: viewModel.scrollToTime) { oldValue, newValue in
                        guard let newValue = newValue else { return }
                        let value = (viewModel.firstUpcomingEventIndex == 0) ? "top" : newValue
        
                        withAnimation {
                            proxy.scrollTo(value, anchor: .center)
                        }
                        viewModel.scrollToTime = nil
                    }
                    .overlay(alignment: .topLeading) {
                        if showBackButton {
                            BackButton(onBackClick)
                                .padding(.leading, Paddings.defaultVerticalPadding24)
                                .padding(.top, Paddings.defaultPadding8)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .top).combined(with: .opacity),
                                    removal: .move(edge: .top).combined(with: .opacity)
                                ))
                        }
                    }
                }
            }
            //FloatingBottomCornerButton(icon: "plus", action: {  viewModel.addToPlanner()})
        }
    }
    
    private func toolbar() -> some View {
        HStack(spacing: 16){
            BackButton(onBackClick)
                .padding(.leading, Spacing.space32)
                .opacity(0.8)
            Spacer()
        }
    }
    
	private func openingTimeView(leadTime: LeadTime) -> some View {
        ZStack(alignment: .top){
            let titleText = leadTime.isCountdownStarted ? viewModel.openingTitle : leadTime.title
            let action = leadTime.isCountdownStarted ? nil : {
                showEventEditView = !leadTime.isCountdownStarted
            }
            OpeningTimeView(
                imageURL: leadTime.imageUrl,
                title: titleText ,
                subtitle: leadTime.description,
                buttonTitle: "Add to my calendar",
                buttonAction: action
            )
            .sheet(isPresented: $showEventEditView) {
                let start = leadTime.date
                let end = leadTime.date
                EventCalendarEditView(
                    title: "Virgin Voyages - Line up booking opens",
                    startDate: start,
                    endDate: end
                )
            }
            toolbar()
                .padding(Spacing.space16)
        }
    }

    private func header() -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            if showBackButton && !showPinnedHeader {
                Spacer().frame(height: Paddings.defaultVerticalPadding24)
            }
            if !viewModel.itineraryDays.isEmpty {
                VStack(alignment: .center, spacing: Spacing.space24) {
                    DateSelector(selected: $viewModel.selectedDate, options: viewModel.itineraryDays.getDates(), isPastDateDisabled: false)
                    
                    if showPinnedHeader {
                        VStack (spacing: Spacing.space4) {
                            Text(viewModel.selectedDate.toDayMonthDayNumber())
                                .font(.vvHeading3Bold)
                                .foregroundColor(Color.blackText)
                            
                            if let portName = viewModel.itineraryDays.findItinerary(for: viewModel.selectedDate)?.portName, !portName.isEmpty {
                                Text("Port Day: \(portName)")
                                    .font(.vvBody)
                                    .foregroundColor(Color.slateGray)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, Paddings.defaultVerticalPadding24)
        .background(
            ZStack(alignment: .bottom) {
                GeometryReader { geo in
                    Color.softGray
                        .preference(
                            key: SectionHeaderOffsetKey.self,
                            value: ["headerOffset": geo.frame(in: .named("scroll")).minY]
                        )
                }
                Rectangle()
                    .fill(Color.black.opacity(0.05))
                    .frame(height: 2)
                    .blur(radius: 1.5)
                    .offset(y: 1.5)
                    .opacity(showPinnedHeader ? 0 : 1)
            }
        )
    }

    private func events() -> some View  {
        VStack(alignment: .leading, spacing: Spacing.space24) {
            EventsByHour(lineUpEvents: viewModel.lineUp.filterByDate(viewModel.selectedDate),
                         mustSeeEvents: viewModel.lineUp.filterByDateMustSeeEvents(viewModel.selectedDate),
                         selectedDay: viewModel.selectedDate.dayName,
                         upcomingEventIndex: viewModel.firstUpcomingEventIndex) { event in
					onViewEventDetailsClick(event)
                }
        }
        .padding(Spacing.space16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .id(viewModel.lineUp.events.map(\.uuid).hashValue)
    }

    private func footer() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space16) {
            VStack(alignment: .center, spacing: Spacing.space16) {
                VectorImage(name: "Waves", mode: .fill)
                    .frame(width: 49, height: 45)

                Text("That’s A Wrap!")
                    .font(.vvHeading3Bold)
                    .fontWeight(.bold)
                    .foregroundColor(.blackText)

                Text("Grab 40 winks and get ready to do it all again tomorrow.")
                    .font(.vvHeading5)
                    .foregroundColor(Color.slateGray)

                if viewModel.isNextDateAvailable() {
                    PrimaryCircleButton {
                        viewModel.goToNextDate()
                    }
                }
            }.padding(Spacing.space16)
                .frame(maxWidth: .infinity)
        }
        .background(
             GeometryReader { geo in
                 Color.clear.preference(
                     key: SectionHeaderOffsetKey.self,
                     value: ["bottomOffset": geo.frame(in: .named("scroll")).minY]
                 )
             }
         )
    }
    
    private func handleScrollOffsets(_ offsets: [String: CGFloat]) {
        if let headerOffset = offsets["headerOffset"] {
            let shouldShowHeader = headerOffset > 8
            if shouldShowHeader != showPinnedHeader {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showPinnedHeader = shouldShowHeader
                    showBackButton = shouldShowHeader
                }
            }
        }

        if let bottomOffset = offsets["bottomOffset"], bottomOffset < 500 {
            return
        }

        if let topOffset = offsets["topOffset"] {
            let scrollChange = topOffset - previousScrollOffset
            let scrollThreshold: CGFloat = 30

            guard abs(scrollChange) > scrollThreshold else { return }

            let shouldShowBackButton = scrollChange > 0
            if shouldShowBackButton != showBackButton && topOffset < -60 {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showBackButton = shouldShowBackButton
                }
            }
            previousScrollOffset = topOffset
        }
    }
}

private struct EventsByHour: View {
    let lineUpEvents: [LineUpEvents]
    let mustSeeEvents: LineUpEvents?
    let selectedDay: String
    let upcomingEventIndex: Int
    let onEventClick: (LineUpEvents.EventItem) -> Void

    init(lineUpEvents: [LineUpEvents], mustSeeEvents: LineUpEvents? = nil, selectedDay: String, upcomingEventIndex: Int, onEventClick: @escaping (LineUpEvents.EventItem) -> Void) {
        self.lineUpEvents = lineUpEvents
        self.mustSeeEvents = mustSeeEvents
        self.selectedDay = selectedDay
        self.upcomingEventIndex = upcomingEventIndex
        self.onEventClick = onEventClick
    }

    var body: some View {
        ForEach(Array(lineUpEvents.enumerated()), id: \.element.uuid) { index, event in
            VStack {
                if index == upcomingEventIndex, let events = mustSeeEvents {
                    mustSeeEventCardView(event: events)
                }
                eventsView(event: event)
            }
        }
    }
    
    private func eventsView(event: LineUpEvents) -> some View {
        ZStack(alignment: .leading) {
            VStack {
                Spacer()
                    .frame(height: Spacing.space10)
                    .id(event.time)
                
                DottedLine()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                    .foregroundColor(Color.mediumGray)
                    .frame(width: 1)
                    .frame(maxHeight: .infinity)
            }
            .padding(.leading, Spacing.space20)
            
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: Spacing.space12) {
                    Circle()
                        .fill(Color.mediumGray)
                        .frame(width: Spacing.space10, height: Spacing.space10)
                    VStack(alignment: .leading, spacing: Spacing.space8) {
                        Text(event.time)
                            .font(.vvHeading5)
                            .foregroundColor(Color.vvBlack)
                    }
                }
                .padding(.leading, Spacing.space16)
                
                VStack(spacing: Spacing.space16) {
                    ForEach(event.items, id: \.id) { item in
                        eventCardView(item: item)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
	private func eventCardView(item: LineUpEvents.EventItem) -> some View {
		Button(action: {
			if item.type == .bookable {
				onEventClick(item)
			}
		}) {
			EventCard(name: item.name,
					  timePeriod: item.timePeriod,
					  location: item.location,
					  isBookable: item.type == .bookable,
					  isBooked: item.isBooked,
					  isDisabled: item.selectedSlot?.status != .available,
					  isNonInventoried: item.inventoryState == .nonInventoried,
					  slotStatusText: item.selectedSlotStatusText,
					  imageUrl: item.imageUrl,
					  price: item.priceFormatted)
		}
	}
    
    private func mustSeeEventCardView(event: LineUpEvents) -> some View {
            LineUpExpandableRow(selectedDay: selectedDay, event: event) {
                VStack(spacing: .zero) {
                    ForEach(event.items, id: \.id) { item in
                        MustSeeEventsCard(title: item.name,
                                          subtitle: item.location,
                                          location: item.timePeriod,
                                          imageUrl: item.imageUrl,
                                          onTap: { onEventClick(item) }
                        )
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom, Paddings.defaultPadding8)
        }
}

struct LineUpScreen_Previews: PreviewProvider {
    struct MockLineUpScreenViewModel: LineUpScreenViewModelProtocol {
     
		var lineUp: LineUp = LineUp.empty()

		var itineraryDays: [ItineraryDay] = ItineraryDay.samples()

		func onFirstAppear() {}
		
		func onReAppear() {}
		
        var scrollToTime: String? = "12pm"
        var openingTitle = ""
        
        var screenState: ScreenState = .content
        var selectedDate: Date = Date()
        var isLoadingData: Bool = false
        var firstUpcomingEventIndex: Int = 0

        func onAppear() { }
        func onRefresh() {}
        func onDateChanged() {}
        func goToNextDate() {}
        func isNextDateAvailable() -> Bool {
            return false
        }
        func addToPlanner(){}
    }

    static var previews: some View {
        LineUpScreen(
			viewModel: MockLineUpScreenViewModel(itineraryDays: ItineraryDay.samples()),
			onViewEventDetailsClick: { _ in },
			onBackClick: {}
		)
    }
}
