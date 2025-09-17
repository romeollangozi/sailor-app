//
//  SecurityPhotoScreen.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/5/24.
//

import SwiftUI

struct SecurityPhotoScreen: View {
	@State var securityPhoto: SecurityPhotoTask
	var background: URL?
	
    var body: some View {
		ZStack {
			switch securityPhoto.step {
			case .processing:
				ProgressBarView(text: securityPhoto.cameraTask.text, value: securityPhoto.cameraTask.progress)
				
			case .rewiew(let url):
				SecurityPhotoReviewStep(securityPhoto: securityPhoto, photo: Photo(url: url))
				
			case .upload:
				SecurityPhotoUploadStep(securityPhoto: securityPhoto)
					.background(url: background)
			}
		}
		.sailableToolbar(task: securityPhoto)
		.animation(.easeInOut, value: securityPhoto.cameraTask.status)
		.alert(isPresented: $securityPhoto.cameraTask.showError, error: securityPhoto.cameraTask.error) {}
		.disabled(securityPhoto.cameraTask.status == .fetching)
		.interactiveDismissDisabled(securityPhoto.cameraTask.status == .fetching)
    }
}
