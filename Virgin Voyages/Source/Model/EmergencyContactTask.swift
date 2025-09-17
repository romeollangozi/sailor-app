//
//  EmergencyContactTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/31/24.
//

import Foundation

extension String {
	var maybeNil: String? {
		self == "" ? nil : self
	}
}

@Observable class EmergencyContactTask: Sailable {
	var content: Endpoint.GetEmergencyContactTask.Response
	let relations: [Endpoint.GetLookupData.Response.LookupData.Relation]
	let countries: [Endpoint.GetLookupData.Response.LookupData.Country]
	
	var name: String
	var relationship: String
	var countryCode: String
	var phoneNumber: String
	var showRelationshipSheet = false
	var task: SailTask { .emergencyContact }
	
	var navigationMode: NavigationMode {
		let step = self.step
		return step == .name || step == .done ? .dismiss : .back
	}

    var relationshipName: String {
        return relations.first { $0.code == relationship }?.name ?? ""
    }

	init(content: Endpoint.GetEmergencyContactTask.Response, relations: [Endpoint.GetLookupData.Response.LookupData.Relation], countries: [Endpoint.GetLookupData.Response.LookupData.Country]) {
		self.content = content
		self.relations = relations
		self.countries = countries
		
		name = content.emergencyContactDetails?.name ?? ""
		phoneNumber = content.emergencyContactDetails?.phoneNumber ?? ""
		relationship = content.emergencyContactDetails?.relationship ?? ""
        guard let dialingCountryCode = content.emergencyContactDetails?.dialingCountryCode else {
            countryCode = ""
            return
        }
        countryCode = "+\(dialingCountryCode)"
	}
	
	func discardChanges() {
		name = ""
		relationship = ""
		countryCode = ""
		phoneNumber = ""
		content.emergencyContactDetails = nil
	}
	
	func saveIsEnabled() -> Bool {
		name != content.emergencyContactDetails?.name || phoneNumber != content.emergencyContactDetails?.phoneNumber || relationship != content.emergencyContactDetails?.relationship || countryCode != content.emergencyContactDetails?.dialingCountryCode
	}
	
	func reload(_ sailor: Endpoint.SailorAuthentication) async throws {
		
	}
	
	func startInterview() {
		
	}
	
	func startOver() {
		
	}
	
	func save() {
		content.emergencyContactDetails = .init(name: name.maybeNil, relationship: relationship.maybeNil, dialingCountryCode: countryCode.maybeNil, phoneNumber: phoneNumber.maybeNil)
	}
	
	func back() {
		switch step {
		case .relation:
			content.emergencyContactDetails?.name = nil
			
		case .phone:
			content.emergencyContactDetails?.relationship = nil
			
		case .done:
			content.emergencyContactDetails?.phoneNumber = nil
			
		default:
			break
		}
	}
	
	var step: Step {
		if content.emergencyContactDetails?.name == nil {
			return .name
		}
		
		if content.emergencyContactDetails?.relationship == nil {
			return .relation
		}
		
		if content.emergencyContactDetails?.phoneNumber == nil || content.emergencyContactDetails?.dialingCountryCode == nil {
			return .phone
		}
		
		return .done
	}
}

extension EmergencyContactTask {
	enum Step {
		case name
		case relation
		case phone
		case done
	}
}

extension Endpoint.SailorAuthentication {
	@discardableResult func save(emergencyContact: EmergencyContactTask) async throws -> Endpoint.GetReadyToSail.UpdateTask {
		let name = emergencyContact.name
		let relationship = emergencyContact.relationship
		var dialingCountryCode = emergencyContact.countryCode.replacingOccurrences(of: "+", with: "")
		var phoneNumber = emergencyContact.phoneNumber
		
		// Both have to be set
		if dialingCountryCode == "" || phoneNumber == "" {
			dialingCountryCode = ""
			phoneNumber = ""
		}
		
		let contact = Endpoint.UpdateEmergencyContactTask.Request.EmergencyContactDetails(name: name, relationship: relationship, dialingCountryCode: dialingCountryCode, phoneNumber: phoneNumber)
		return try await fetch(Endpoint.UpdateEmergencyContactTask(emergencyContact: contact, reservation: reservation))
	}
	
	@discardableResult func delete(emergencyContact: EmergencyContactTask) async throws -> Endpoint.GetReadyToSail.UpdateTask {
		let contact = Endpoint.UpdateEmergencyContactTask.Request.EmergencyContactDetails(name: "", relationship: "", dialingCountryCode: "", phoneNumber: "")
		return try await fetch(Endpoint.UpdateEmergencyContactTask(emergencyContact: contact, reservation: reservation))
	}
}
