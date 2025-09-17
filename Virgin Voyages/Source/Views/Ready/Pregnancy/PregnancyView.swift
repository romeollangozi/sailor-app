//
//  PregnancyView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/20/24.
//

import SwiftUI

struct PregnancyView: View {
	@State var sailTask: ReadyToSail.Task
	@State private var content: PregnancyTaskViewer.Content?
	
	var body: some View {
		ScreenView(name: sailTask.title, viewModel: PregnancyTaskViewer(), content: $content) { pregnancy in
			PregnancyScreen(pregnancy: .init(content: pregnancy))
		}
	}
}
