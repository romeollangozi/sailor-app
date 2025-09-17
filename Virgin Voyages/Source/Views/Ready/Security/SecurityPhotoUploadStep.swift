//
//  SecurityPhotoUploadStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/23/24.
//

import SwiftUI
import PhotosUI

struct SecurityPhotoUploadStep: View {
	var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
	@Bindable var securityPhoto: SecurityPhotoTask
    @Environment(\.dismiss) var dismiss

    var body: some View {
		VStack {
			VStack(alignment: .center, spacing: 20) {
				Text(securityPhoto.content.cameraButtonPage.title)
					.fontStyle(.largeTitle)
				Text(securityPhoto.content.cameraButtonPage.description)
					.fontStyle(.body)
					.multilineTextAlignment(.center)
			}
			.opacity(0.6)
			
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
				Text("Take photo")
            } overlay: {
                CameraSelfieOverlayView()
            }
			.buttonStyle(PrimaryButtonStyle())
		}
		.sailableStepStyle()
    }
}
