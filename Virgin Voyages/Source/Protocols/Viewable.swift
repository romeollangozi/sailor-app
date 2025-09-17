//
//  Fetchable.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 3/29/24.
//

import Foundation
import AVKit

protocol Viewable {
	// The type of data to return for Screen View
	associatedtype Content: Any
	
	// Screen View uses this to see if we need to refresh the data when the view appears
	var requiresRefresh: Bool { get }
	var showsTitle: Bool { get }
	
	// Fetches data from the server
	func fetch(authentication: Endpoint.SailorAuthentication) async throws -> Content
	
	// Loads cached data from a saved file
	func load(authentication: Endpoint.SailorAuthentication) throws -> Content?
}

extension Viewable {
	@discardableResult func preload(authentication: Endpoint.SailorAuthentication) async -> Content? {
		if let content = try? load(authentication: authentication) {
			return content
		}
		
		return try? await fetch(authentication: authentication)
	}
}

// MARK: Housekeeping

struct SecurityPhotoTaskViewer: Viewable {
	typealias Content = (Endpoint.GetSecurityPhotoTask.Response, [Endpoint.GetLookupData.Response.LookupData.RejectionReason])
	var requiresRefresh = true
	var showsTitle = false

	func fetch(authentication: Endpoint.SailorAuthentication) async throws -> Content {
		let task = try await authentication.fetch(Endpoint.GetSecurityPhotoTask(reservation: authentication.reservation))
		let rejections = try await authentication.fetch(Endpoint.GetLookupData()).referenceData.rejectionReasons
		return (task, rejections)
	}
	
	func load(authentication: Endpoint.SailorAuthentication) throws -> Content? {
		guard let task = try authentication.load(Endpoint.GetSecurityPhotoTask(reservation: authentication.reservation)) else { return nil }
		guard let rejections = try authentication.load(Endpoint.GetLookupData()) else { return nil }
		return (task, rejections.referenceData.rejectionReasons)
	}
}

struct AddCreditCardViewer: Viewable {
	typealias Content = URL
	var showsTitle = false
	var requiresRefresh = false

	func fetch(authentication: Endpoint.SailorAuthentication) async throws -> Content {
		try await authentication.fetchPaymentUrl()
	}
	
	func load(authentication: Endpoint.SailorAuthentication) throws -> Content? {
		nil
	}
}

// MARK: Voyage Contract

struct VoyageContractTaskViewer: Viewable {
	typealias Content = Endpoint.GetVoyageContractTask.Response
	var requiresRefresh = true
	var showsTitle = false
	var sailor: Sailor?

	func fetch(authentication: Endpoint.SailorAuthentication) async throws -> Content {
		try await authentication.fetch(Endpoint.GetVoyageContractTask(reservation: authentication.reservation))
	}
	
	func load(authentication: Endpoint.SailorAuthentication) throws -> Content? {
		try authentication.load(Endpoint.GetVoyageContractTask(reservation: authentication.reservation))
	}
}

// MARK: Pregnancy

struct PregnancyTaskViewer: Viewable {
	typealias Content = Endpoint.GetPregnancyTask.Response
	var requiresRefresh = true
	var showsTitle = false
	var sailor: Sailor?

	func fetch(authentication: Endpoint.SailorAuthentication) async throws -> Content {
		try await authentication.fetch(Endpoint.GetPregnancyTask(reservation: authentication.reservation))
	}
	
	func load(authentication: Endpoint.SailorAuthentication) throws -> Content? {
		try authentication.load(Endpoint.GetPregnancyTask(reservation: authentication.reservation))
	}
}

// MARK: Emergency Contact

struct EmergencyContactTaskViewer: Viewable {
	typealias Content = (Endpoint.GetEmergencyContactTask.Response, [Endpoint.GetLookupData.Response.LookupData.Relation], [Endpoint.GetLookupData.Response.LookupData.Country])
	var requiresRefresh = true
	var showsTitle = false
	var sailor: Sailor?

	func fetch(authentication: Endpoint.SailorAuthentication) async throws -> Content {
		let response = try await authentication.fetch(Endpoint.GetEmergencyContactTask(reservation: authentication.reservation))
		let lookup = try await authentication.fetch(Endpoint.GetLookupData())
		return (response, lookup.referenceData.relations, lookup.referenceData.countries)
	}
	
	func load(authentication: Endpoint.SailorAuthentication) throws -> Content? {
		guard let response = try authentication.load(Endpoint.GetEmergencyContactTask(reservation: authentication.reservation)) else { return nil }
		guard let lookup = try authentication.load(Endpoint.GetLookupData()) else { return nil }
		return (response, lookup.referenceData.relations, lookup.referenceData.countries)
	}
}

struct HealthCheckViewer: Viewable {
	typealias Content = Endpoint.GetHealthCheck.Response
	var requiresRefresh = true
	var showsTitle = false
	var sailor: Sailor?
	
	func fetch(authentication: Endpoint.SailorAuthentication) async throws -> Content {
		try await authentication.fetch(Endpoint.GetHealthCheck(reservation: authentication.reservation))
	}
	
	func load(authentication: Endpoint.SailorAuthentication) throws -> Content? {
		try authentication.load(Endpoint.GetHealthCheck(reservation: authentication.reservation))
	}
}

struct TravelAssistViewer: Viewable {
	typealias Content = Endpoint.GetTravelPartyAssist.Response
	var requiresRefresh = true
	var showsTitle = false
	
	func fetch(authentication: Endpoint.SailorAuthentication) async throws -> Content {
		try await authentication.fetch(Endpoint.GetTravelPartyAssist(reservation: authentication.reservation))
	}
	
	func load(authentication: Endpoint.SailorAuthentication) throws -> Content? {
		try authentication.load(Endpoint.GetTravelPartyAssist(reservation: authentication.reservation))
	}
}
