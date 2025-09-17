//
//  LineUpScreenViewModelTests.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 21.8.25.
//

import XCTest
@testable import Virgin_Voyages

final class LineUpScreenViewModelTests: XCTestCase {
    
    func testFirstUpcomingEventIndex_returnsFirstIndexWithUpcomingItem() {
        let today = Calendar.current.startOfDay(for: Date())
        
        let events = [
            hour(sequence: 0, time: "09:00", date: today, statuses: [.passed, .passed]),
            hour(sequence: 1, time: "10:00", date: today, statuses: [.closed]),
            hour(sequence: 2, time: "11:00", date: today, statuses: [.available, .passed]),
        ]
        
        let viewModel = LineUpScreenViewModel()
        viewModel.lineUp = LineUp(events: events, mustSeeEvents: [], leadTime: nil)
        viewModel.selectedDate = today
        
        XCTAssertEqual(viewModel.firstUpcomingEventIndex, 2)
    }
    
    func testFirstUpcomingEventIndex_whenAllClosedOrPassed_returnsZero() {
        let today = Calendar.current.startOfDay(for: Date())
        
        let events = [
            hour(sequence: 0, time: "09:00", date: today, statuses: [.passed]),
            hour(sequence: 1, time: "10:00", date: today, statuses: [.closed, .closed]),
        ]
        
        var viewModel = LineUpScreenViewModel()
        viewModel.lineUp = LineUp(events: events, mustSeeEvents: [], leadTime: nil)
        viewModel.selectedDate = today
        
        XCTAssertEqual(viewModel.firstUpcomingEventIndex, 0)
    }
    
    func testFirstUpcomingEventIndex_filtersBySelectedDate_returnIndexForThatDay() {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        
        let events = [
            hour(sequence: 0, time: "09:00", date: today, statuses: [.passed]),
            hour(sequence: 1, time: "10:00", date: today, statuses: [.available]),
            hour(sequence: 2, time: "11:00", date: tomorrow, statuses: [.available])
        ]
        
        var viewModel = LineUpScreenViewModel()
        viewModel.lineUp = LineUp(events: events, mustSeeEvents: [], leadTime: nil)
        viewModel.selectedDate = today
        
        XCTAssertEqual(viewModel.firstUpcomingEventIndex, 1)
    }
}

private func event(status: SlotStatus, startDate: Date) -> LineUpEvents.EventItem {
    LineUpEvents.EventItem(
        eventID: "616856c570fae55c2756c869",
        categoryCode: "ENT",
        name: "The Charmer's Lounge",
        imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:54d66526-e3b5-4adb-bf6f-271178c541c9/IMG-ENT-The-Charmers-Lounge-1200x800.jpg",
        location: "The Dock House, Deck 7",
        timePeriod: "1-1:30pm",
        type: .bookable,
        bookingType: .multiDayMultiInstance,
        introduction: "Optical illusion or just good old-fashioned magic show will be sure to keep you spellbound by The Charmer.",
        longDescription: "The Charmer is not only our lady ship's resident magician, but also the consummate host. You may be charmed by impromptu illusions, or perhaps it’s The Charmer’s mystifying personality that draws you to the show.",
        price: 0,
        priceFormatted: nil,
        currencyCode: "USD",
        needToKnows: [
            "This event is on a first-come, first-served basis.",
            "We will be using a virtual queue to manage the entrance."
        ],
        editorialBlocks: [],
        isBooked: false,
        bookedText: "",
        isPreVoyageBookingStopped: false,
        isBookingEnabled: true,
        bookButtonText: "Add to agenda",
        selectedSlot: Slot(
            id: "6775114c260a140dc4e34d50",
            startDateTime: startDate,
            endDateTime: Date(),
            status: status,
            isBooked: false,
            inventoryCount: 10
        ),
        appointments: nil,
        inventoryState: .nonInventoried,
        slots: []
    )
}

private func hour(sequence: Int, time: String, date: Date, statuses: [SlotStatus]) -> LineUpEvents {
    LineUpEvents(
        sequence: sequence,
        time: time,
        items: statuses.map { event(status: $0, startDate: date) },
        date: date
    )
}

