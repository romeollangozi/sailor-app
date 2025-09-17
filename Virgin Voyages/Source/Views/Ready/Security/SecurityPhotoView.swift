//
//  SecurityPhotoView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/23/24.
//

import SwiftUI

struct SecurityPhotoView: View {
	@State var sailTask: ReadyToSail.Task
	@State private var securityPhotoContent: SecurityPhotoTaskViewer.Content?
	
	var body: some View {
		ScreenView(name: sailTask.title, viewModel: SecurityPhotoTaskViewer(), content: $securityPhotoContent) { security, rejectionReasons in
            SecurityPhotoScreen(securityPhoto: .init(content: security, rejectionReasons: rejectionReasons, rtsTask: sailTask), background: URL(string: sailTask.imageURL))
		}
	}
}
