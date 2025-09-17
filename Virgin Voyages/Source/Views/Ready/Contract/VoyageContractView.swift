//
//  VoyageContractView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/20/24.
//

import SwiftUI

struct VoyageContractView: View {
	@State private var content: VoyageContractTaskViewer.Content?
	@State var sailTask: ReadyToSail.Task
	@State var screenTask = ScreenTask()
	
    var body: some View {
		ScreenView(name: sailTask.title, viewModel: VoyageContractTaskViewer(), content: $content) { contract in
			VoyageContractScreen(contract: .init(content: contract))
		}
    }
}
