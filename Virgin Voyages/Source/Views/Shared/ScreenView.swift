//
//  FetchableView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 3/29/24.
//

import SwiftUI
import Combine

struct ScreenView<Model: Viewable, Label: View>: View {
	var model: AuthenticationService = AuthenticationService.shared
	@State private var fetchTask = ScreenTask()
	@State private var refreshTask = ScreenTask()

	var name: String
	var viewModel: Model
	var savedContent: Model.Content?
	@Binding var content: Model.Content?
	@ViewBuilder var label: (Model.Content) -> Label
	
	var body: some View {
		ZStack {
			if let displayContent = content ?? savedContent {
				label(displayContent)
					.task {
						if fetchTask.status != .fetching {
							fetchSilent()
						}
					}
			} else if fetchTask.status == .failed {
				NoDataView(title: name, action: fetchContent)
			} else {
				ProgressView("Loading \(name)...")
					.fontStyle(.headline)
					.padding()
					.task {
						fetchContent()
					}
			}
		}
		.alert(isPresented: $fetchTask.showError, error: fetchTask.error) {}
		.animation(.easeInOut, value: fetchTask.status)
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			if viewModel.showsTitle {
				ToolbarItem(placement: .principal) {
					Text(name)
						.fontStyle(.headline)
				}
			}
		}
	}

	private func fetchSilent() {
		if !viewModel.requiresRefresh {
			return
		}
		
		Task {
			try await refreshTask.run {
				content = try await model.currentSailor().fetch(viewModel)
			}
		}
	}
	
	private func fetchContent() {
		guard let sailor = try? model.currentSailor() else {
			return
		}
		
		Task {
			try await fetchTask.run {
				content = try await sailor.fetch(viewModel)
			}
		}
	}
}
