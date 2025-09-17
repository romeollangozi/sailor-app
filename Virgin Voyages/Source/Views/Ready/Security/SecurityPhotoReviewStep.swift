//
//  SecurityPhotoReviewStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/3/24.
//

import SwiftUI

struct SecurityPhotoReviewStep: View {
	var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
	@Environment(\.dismiss) var dismiss
	@Bindable var securityPhoto: SecurityPhotoTask
	var photo: Photo
	@State private var photoImage: Photo.Share?
	
    var body: some View {
		VStack(spacing: 10) {
			Spacer()
			
			VStack(spacing: 20) {
				AuthenticatedProgressImage(url: photo.url, contentMode: .fill)
					.containerRelativeFrame(widthPercentage: 0.75, heightPercentage: 0.5)

                if let rtsTask = securityPhoto.rtsTask, !rtsTask.rejectedReasonIds().isEmpty {
                    Spacer()
                    let reasonsText = securityPhoto.rejectedReasonsText(from: rtsTask.rejectedReasonIds())
                    RejectionReasonView(title: rtsTask.reasonRejectionText ?? "Reason for rejection", reasons: reasonsText)
                } else {
                    HStack(spacing: 10) {
                        Text(securityPhoto.content.photoCapturedPage.title)
                            .fontStyle(.title)

                        TaskButton(systemImage: "trash", task: securityPhoto.cameraTask) {
                            try await authenticationService.currentSailor().delete(securityPhoto: photo)
                            securityPhoto.discardChanges()
                        }
                    }
                }
			}
			
			Spacer()
			
			ImageCaptureView(task: securityPhoto.cameraTask) { data in
				securityPhoto.cameraTask.progress = 0
				securityPhoto.cameraTask.text = "Verifying"
				try await authenticationService.currentSailor().validate(securityPhoto: data, rejectionReasons: securityPhoto.rejectionReasons)
				securityPhoto.cameraTask.progress = 0.5
				securityPhoto.cameraTask.text = "Uploading"
                do {
                    securityPhoto.url = try await authenticationService.currentSailor().upload(securityPhoto: data)
                    self.dismiss()
                }
			} label: {
				Text("Retake Photo")
            } overlay: {
                CameraSelfieOverlayView()
            }
			.buttonStyle(TertiaryButtonStyle())
		}
		.sailableStepStyle()
		.sheet(item: $photoImage) { share in
			PhotoActivityView(share: share)
		}
    }
}
