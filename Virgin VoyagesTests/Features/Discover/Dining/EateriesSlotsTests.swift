//
//  EateriesSlotsTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 20.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class EateriesSlotsTests: XCTestCase {
	
}

// MARK: - testOnlyThoseWithTimeslotsAvailable
extension EateriesSlotsTests {
	func testOnlyThoseWithTimeslotsAvailableWhenNoRestaurantsHaveSlotsShouldReturnEmpty() {
		let eateriesSlots = EateriesSlots(restaurants: [
			EateriesSlots.Restaurant.sample().copy(slots: []),
			   EateriesSlots.Restaurant.sample().copy(slots: [])
		   ])

		let result = eateriesSlots.onlyThoseWithTimeslotsAvailable()

		XCTAssertTrue(result.restaurants.isEmpty)
	}

	func testOnlyThoseWithTimeslotsAvailableWhenSomeRestaurantsHaveSlotsShouldReturnFilteredRestaurants() {
		let restaurantWithSlots = EateriesSlots.Restaurant.sample().copy(slots: [Slot.sample()])
		let restaurantWithoutSlots = EateriesSlots.Restaurant.sample().copy(slots: [])
		let eateriesSlots = EateriesSlots(restaurants: [restaurantWithSlots, restaurantWithoutSlots])

		let result = eateriesSlots.onlyThoseWithTimeslotsAvailable()

		XCTAssertEqual(result.restaurants.count, 1)
		XCTAssertEqual(result.restaurants.first?.name, restaurantWithSlots.name)
	}
}

// MARK: - testFind
extension EateriesSlotsTests {
	func testFindWhenRestaurantExistsShouldReturnRestaurant() {
		let targetRestaurant = EateriesSlots.Restaurant.sample().copy(
			externalId: "targetExternalId",
			venueId: "targetVenueId"
		)
		let eateriesSlots = EateriesSlots(restaurants: [
			EateriesSlots.Restaurant.sample(),
			   targetRestaurant
		   ])

		let result = eateriesSlots.find(byExternalId: "targetExternalId", byVenueId: "targetVenueId")

		XCTAssertNotNil(result)
		XCTAssertEqual(result?.externalId, "targetExternalId")
		XCTAssertEqual(result?.venueId, "targetVenueId")
	}

	func testFindWhenRestaurantDoesNotExistShouldReturnNil() {
		let eateriesSlots = EateriesSlots(restaurants: [
			EateriesSlots.Restaurant.sample().copy(
				   externalId: "someExternalId",
				   venueId: "someVenueId"
			   )
		   ])

		let result = eateriesSlots.find(byExternalId: "nonExistentExternalId", byVenueId: "nonExistentVenueId")

		XCTAssertNil(result)
	}
}
