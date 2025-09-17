//
//  PregnancyTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/31/24.
//

import Foundation

@Observable class PregnancyTask: Sailable {
	var content: Endpoint.GetPregnancyTask.Response
	var numberOfWeeks: String
	private var isFitToTravel: Bool?
	private var isPregnant: Bool?
	private var getStarted: Bool
	private var showReview = false
	var task: SailTask { .pregnancy }
    var showErrorMsg: Bool = false

	init(content: Endpoint.GetPregnancyTask.Response) {
		self.content = content
		self.showReview = content.pregnancyDetails?.isPregnant != nil
		self.isPregnant = content.pregnancyDetails?.isPregnant
		self.getStarted = false
		
		if let numberOfWeeks = content.pregnancyDetails?.noOfWeeks {
			self.numberOfWeeks = String(numberOfWeeks)
		} else {
			self.numberOfWeeks = ""
		}
	}
	
	func reload(_ sailor: Endpoint.SailorAuthentication) async throws {
		
	}
	
    func update(pregnant: Bool, fitToTravel: Bool?, dontKnowFlag: Bool? = false) {
		isPregnant = pregnant
		isFitToTravel = fitToTravel
        content.pregnancyDetails = .init(isPregnant: pregnant, noOfWeeks: Int(numberOfWeeks), dontKnowFlag: dontKnowFlag)
	}
	
	func startInterview() {
		getStarted = true
		numberOfWeeks = ""
	}
	
	func startOver() {
		isPregnant = nil
		getStarted = false
		showReview = false
	}
	
	func back() {
		switch self.step {
		case .fitToTravel, .notFitToTravel:
			startOver()
			
		case .unconfirmed:
			content.pregnancyDetails?.dontKnowFlag = nil
			
		case .numberOfWeeks:
			getStarted = false
			
		default:
			break
		}
	}
	
	var navigationMode: NavigationMode {
		switch self.step {
		case .fitToTravel, .notFitToTravel, .numberOfWeeks, .unconfirmed:
			.back
		default:
			.dismiss
		}
	}
	
	var step: Step {
		if showReview, let page = content.reviewPage {
			return .review(page)
		}
		
		if isPregnant == true {
			if let isFitToTravel {
				return isFitToTravel ? .fitToTravel : .notFitToTravel
			}
			
			if content.pregnancyDetails?.dontKnowFlag == true {
				return .unconfirmed
			}
		}
		
		if isPregnant == false {
			return .fitToTravel
		}
		
		if getStarted {
			return .numberOfWeeks
		}
		
		return .start
	}
}

extension PregnancyTask {
	enum Step {
		case start
		case numberOfWeeks
		case fitToTravel
		case notFitToTravel
		case unconfirmed
		case review(Endpoint.GetPregnancyTask.Response.ReviewPage)
	}
	
	enum AnswerMode {
		case yes(Int)
		case no
		case dontKnow
	}
}

extension Endpoint.SailorAuthentication {
	func save(pregnant: PregnancyTask.AnswerMode) async throws -> Bool? {
		switch pregnant {
		case .yes(let weeks):
			let _ = try await fetch(Endpoint.UpdatePregnancyTask(pregnant: true, weeks: weeks, reservation: reservation))
			return try await fetch(Endpoint.ValidatePregnancyTask(numberOfWeeks: weeks, reservation: reservation)).isFitToTravel
			
		case .no:
			let _ = try await fetch(Endpoint.UpdatePregnancyTask(pregnant: false, reservation: reservation))
			return nil
			
		case .dontKnow:
			let _ = try await fetch(Endpoint.UpdatePregnancyTask(pregnant: true, reservation: reservation))
			return nil
		}
	}
}

extension PregnancyTask {
    var isNOWeeksEmpty: Bool {
        numberOfWeeks.isEmptyOrWhitespace
    }

    var validationErrorMsg: String? {
        isNOWeeksEmpty && showErrorMsg ? "Enter how many weeks pregnant you are" : nil
    }
}
