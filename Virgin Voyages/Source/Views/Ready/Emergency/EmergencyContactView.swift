//
//  EmergencyContactView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/21/24.
//

import SwiftUI

struct EmergencyContactView: View {
	@State private var content: EmergencyContactTaskViewer.Content?
	@State var sailTask: ReadyToSail.Task
	
	var body: some View {
		ScreenView(name: sailTask.title, viewModel: EmergencyContactTaskViewer(), content: $content) { emergency, relations, countries in
			EmergencyContactScreen(contact: .init(content: emergency, relations: relations, countries: countries))
		}
	}
}
