//
//  ReadyToSail.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/23/24.
//

import SwiftUI

typealias ReadyToSail = Endpoint.GetReadyToSail.Response

extension ReadyToSail.TaskCompletionPercentage {
    func percent(for task: SailTask) -> Double {
        switch task {
        case .voyageContract: return voyageContract
        case .securityPhoto: return security
        case .paymentMethod: return paymentMethod
        case .emergencyContact: return emergencyContact
        case .pregnancy: return pregnancy
        case .stepAboard: return embarkationSlotSelection
        case .travelDocuments: return travelDocuments
        case .welcome: return 100.0
        }
    }
}

extension ReadyToSail {
	func task(_ task: SailTask) -> ReadyToSail.Task {
		switch task {
		case .voyageContract: voyageContract
		case .securityPhoto: security
		case .paymentMethod: paymentMethod
		case .emergencyContact: emergencyContact
		case .pregnancy: pregnancy
		case .stepAboard: embarkationSlotSelection
		case .travelDocuments: travelDocuments
		case .welcome: .init(title: "Welcome", caption: "Welcome", detailsURL: "", imageURL: "", backgroundColorCode: "#551179")
		}
	}
	
	func taskPercentCompletion(_ task: SailTask) -> Double {
		let percent = switch task {
		case .voyageContract: tasksCompletionPercentage.voyageContract
		case .securityPhoto: tasksCompletionPercentage.security
		case .paymentMethod: tasksCompletionPercentage.paymentMethod
		case .emergencyContact: tasksCompletionPercentage.emergencyContact
		case .pregnancy: tasksCompletionPercentage.pregnancy
		case .stepAboard: tasksCompletionPercentage.embarkationSlotSelection
		case .travelDocuments: tasksCompletionPercentage.travelDocuments
		case .welcome: 100.0
		}
		
		return percent / 100.0
	}
	
	func indexOf(task: SailTask) -> Int {
		tasks.firstIndex { $0 == task } ?? 0
	}
	
	var isComplete: Bool {
		tasks.allSatisfy { task in
			taskPercentCompletion(task) == 1.00
		}
	}

    var isFirstLaunch: Bool {
        tasks
            .filter { $0 != .welcome }
            .allSatisfy { taskPercentCompletion($0) == 0.00 }
    }

	var nextTask: SailTask? {
        if isFirstLaunch {
            return .welcome
        }
		let task = tasks.first {
			taskPercentCompletion($0) != 1.00
		}
		
		guard let task else {
			return tasks.first
		}
		
		return task
	}

	var tasks: [SailTask] {
		var array: [SailTask] = [.welcome]
		for name in tasksOrder {
			let task = SailTask.allCases.first {
				$0.id == name
			}
			
			if let task {
				array += [task]
			}

		}

		return array
	}
}

extension ReadyToSail.Task: Identifiable {
	var id: String {
		title
	}
	
	var pageImageName: String {
		caption.lowercased() == "start" ? "circle" : "checkmark.circle.fill"
	}

    func isRejected(documentType: String) -> Bool {
        switch documentRejectionReasons {
        case .stringArray(let reasons):
            return reasons.contains(documentType)
        case .structuredArray(let reasons):
            return reasons.contains { $0.documentTypeCode == documentType }
        case .none:
            return false
        }
    }

    func rejectedReasonIds(documentType: String? = nil) -> [String] {
        switch documentRejectionReasons {
        case .stringArray(let reasons):
            return reasons
            
        case .structuredArray(let reasons):
            return reasons
                .filter { $0.documentTypeCode == documentType }
                .compactMap { $0.rejectionReasonId }
        case .none:
            return []
        }
    }
}
