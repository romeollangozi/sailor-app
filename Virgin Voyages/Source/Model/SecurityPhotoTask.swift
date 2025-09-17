//
//  SecurityPhoto.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/21/24.
//

import SwiftUI
import UIKit

@Observable class SecurityPhotoTask: Sailable {
	var content: Endpoint.GetSecurityPhotoTask.Response
	var rejectionReasons: [Endpoint.GetLookupData.Response.LookupData.RejectionReason]
	var task: SailTask { .securityPhoto }
	var url: URL?
	var cameraTask = ScreenTask()
    var rtsTask: ReadyToSail.Task?

    init(content: Endpoint.GetSecurityPhotoTask.Response, rejectionReasons: [Endpoint.GetLookupData.Response.LookupData.RejectionReason], rtsTask: ReadyToSail.Task? = nil) {
		self.content = content
		self.rejectionReasons = rejectionReasons
		self.url = URL(string: content.securityPhotoURL)
        self.rtsTask = rtsTask
	}
	
	func startInterview() {
		
	}
	
	func startOver() {
		
	}
	
	func back() {
		
	}
	
	func reload(_ sailor: Endpoint.SailorAuthentication) async throws {
		
	}
	
	func discardChanges() {
		url = nil
	}
	
	var navigationMode: NavigationMode {
		.dismiss
	}
	
	var step: Step {
		if cameraTask.status == .fetching {
			return .processing
		} else if let url {
			return .rewiew(url)
		} else {
			return .upload
		}
	}

}

extension SecurityPhotoTask {
	enum Step {
		case processing
		case upload
		case rewiew(URL)
	}
}

extension SecurityPhotoTask {
    func rejectedReasonsText(from ids: [String]) -> [String] {
        return rejectionReasons
            .filter { ids.contains($0.rejectionReasonId) }
            .map { $0.name }
    }
}

extension Endpoint.SailorAuthentication {
	func upload(securityPhoto: Data) async throws -> URL {
		let url = try await upload(image: securityPhoto)
		let _ = try await fetch(Endpoint.UpdateSecurityPhotoTask(uploadPhoto: Photo(url: url), reservation: reservation))
		return url
	}
	
	@discardableResult func delete(securityPhoto: Photo) async throws -> Endpoint.GetReadyToSail.UpdateTask {
		try await fetch(Endpoint.UpdateSecurityPhotoTask(deletePhoto: securityPhoto, reservation: reservation))
	}
	
	@discardableResult func validate(securityPhoto: Data, rejectionReasons: [Endpoint.GetLookupData.Response.LookupData.RejectionReason]) async throws -> Endpoint.ValidateSecurityPhoto.Response {
		let validateData = securityPhoto.resize(targetSize: CGSize(width: 200, height: 200), compressionQuality: 0.5)
		let response = try await fetch(Endpoint.ValidateSecurityPhoto(data: validateData))

		if !response.isValidPhoto {
			if let reason = response.rejectionReasonIds.first {
				let rejection = rejectionReasons.first {
					$0.rejectionReasonId == reason
				}
				
				if let rejection {
					throw Endpoint.Error(rejection.name)
				}
			}
			
			throw Endpoint.Error("Failed to upload photo")
		}
		
		return response
	}
}
