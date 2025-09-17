//
//  VoyageContractTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/10/24.
//

import Foundation

@Observable class VoyageContractTask: Sailable {
	var content: Endpoint.GetVoyageContractTask.Response
	var dependents: [Dependent]
	var alreadySignedDependents: [Dependent]
	private(set) var signDate: Date?
	private(set) var step: Step
	var task: SailTask { .voyageContract }

	init(content: Endpoint.GetVoyageContractTask.Response) {
		self.content = content
		self.step = .start
		
		dependents = content.contractDetails.otherGuestList.filter {
			!$0.isAlreadySigned
		}.map {
			.init(id: $0.reservationGuestId, name: $0.name, imageUrl: URL(string: $0.imageURL), selected: false)
		}
		
		alreadySignedDependents = content.contractDetails.otherGuestList.filter {
			$0.isAlreadySigned
		}.map {
			.init(id: $0.reservationGuestId, name: $0.name, imageUrl: URL(string: $0.imageURL), selected: true)
		}
		
		if let date = content.contractDetails.contractSignedDate?.iso8601 {
			signDate = date
			step = .review
		}
	}
	
	var numberOfDependents: Int {
		dependents.count + alreadySignedDependents.count
	}
	
	var string: AttributedString {
		content.contractContent.blocks.first?.body.markdown ?? ""
	}
	
	func reload(_ sailor: Endpoint.SailorAuthentication) async throws {
		
	}
	
	func sign(_ state: Bool) {
		if state {
			signDate = .now
			step = .review
		} else {
			step = .sign
		}
	}
	
	var navigationMode: NavigationMode {
        if self.step == .sign {
            return .back
		}
        return .dismiss
	}
	
	func startInterview() {
		step = .sign
	}
	
	func startOver() {
		step = .start
	}
	
	func back() {
		if step == .sign {
			step = .start
		}
	}
}

extension VoyageContractTask {
	enum Step {
		case start
		case sign
		case review
	}
	
	@Observable class Dependent: Identifiable {
		var id: String
		var name: String
		var imageUrl: URL?
		var selected: Bool
		
		init(id: String, name: String, imageUrl: URL?, selected: Bool) {
			self.id = id
			self.name = name
			self.imageUrl = imageUrl
			self.selected = selected
		}
	}
}

extension Endpoint.SailorAuthentication {
	@discardableResult func sign(voyageContract: VoyageContractTask, signed: Bool) async throws -> Endpoint.GetReadyToSail.UpdateTask {
		let guests: [String] = voyageContract.dependents.compactMap {
			$0.selected ? $0.id : nil
		}
		
		return try await fetch(Endpoint.UpdateVoyageContractTask(sign: signed, contractId: voyageContract.content.contractId, contractVersion: voyageContract.content.version, signForGuests: guests, reservation: reservation))
	}

    func downloadContract(voyageContract: VoyageContractTask) async throws -> Data {
        let contract = try await fetchData(Endpoint.DonwloadContractRequest(contractId: voyageContract.content.contractId, reservationGuestId: reservation.reservationGuestId, version: voyageContract.content.version))
        return contract
    }
}
