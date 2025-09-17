//
//  LineUpTests.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 14.8.25.
//

import XCTest
@testable import Virgin_Voyages

final class LineUpTests: XCTestCase {

    func testEmptyLineUp_returnsNoEventsAndNilLeadTime() {
        let empty = LineUp.empty()

        XCTAssertTrue(empty.events.isEmpty)
        XCTAssertTrue(empty.mustSeeEvents.isEmpty)
        XCTAssertNil(empty.leadTime)
    }

    func testFilterByDate_returnsOnlyEventsOnSameDay() {
        let lineUp = LineUp(events: makeSampleEvents(), mustSeeEvents: [], leadTime: nil)
        
        let today = calendar.startOfDay(for: Date())

        let result = lineUp.filterByDate(today)

        XCTAssertEqual(result.map { $0.sequence }, [1, 2])
    }
    
    func testFilterByDate_whenNoEventsOnGivenDay_returnsEmpty() {
        let lineUp = LineUp(events: makeSampleEvents(), mustSeeEvents: [], leadTime: nil)
        
        let nextWeek = calendar.date(byAdding: .day, value: 7, to: calendar.startOfDay(for: Date()))!

        let result = lineUp.filterByDate(nextWeek)

        XCTAssertTrue(result.isEmpty)
    }

    func testFilterByDateMustSeeEvents_returnsOnlyMustSeeEventsMatchingGivenDay() {
        let lineUp = LineUp(events: [], mustSeeEvents: makeSampleEvents(), leadTime: nil)
        
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!

        let result = lineUp.filterByDateMustSeeEvents(tomorrow)

        XCTAssertEqual(result?.sequence, 3)
    }
    
    func testFilterByDateMustSeeEvents_whenNoMustSeeEventsOnGivenDay_returnsNil() {
        let lineUp = LineUp(events: [], mustSeeEvents: makeSampleEvents(), leadTime: nil)
        
        let nextWeek = calendar.date(byAdding: .day, value: 7, to: calendar.startOfDay(for: Date()))!

        let result = lineUp.filterByDateMustSeeEvents(nextWeek)

        XCTAssertNil(result)
    }
}

private let calendar: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    return calendar
}()

private func makeSampleEvents() -> [LineUpEvents] {
    let today = calendar.startOfDay(for: Date())
    let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
    let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!

    return [
        LineUpEvents(sequence: 0, time: "10:00", items: [], date: calendar.date(byAdding: .hour, value: 10, to: yesterday)!),
        LineUpEvents(sequence: 1, time: "14:00", items: [], date: calendar.date(byAdding: .hour, value: 14, to: today)!),
        LineUpEvents(sequence: 2, time: "11:00", items: [], date: calendar.date(byAdding: .hour, value: 11, to: today)!),
        LineUpEvents(sequence: 3, time: "15:00", items: [], date: calendar.date(byAdding: .hour, value: 15, to: tomorrow)!),
        LineUpEvents(sequence: 4, time: "16:00", items: [], date: calendar.date(byAdding: .hour, value: 16, to: tomorrow)!),
    ]
}
