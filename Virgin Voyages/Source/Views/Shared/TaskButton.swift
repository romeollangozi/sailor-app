//
//  TaskButton.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/16/23.
//

import SwiftUI

struct TaskButtonLabel: View {
	var title: String?
	var systemImage: String?
	var progressTint: Color?
	var underline: Bool?
	@Bindable var task: ScreenTask
	
	private var loading: Bool {
		task.status == .fetching
	}
	
	var body: some View {
		ZStack {
			if let progressText = task.text {
				ProgressView(progressText)
					.opacity(loading ? 1 : 0)
					.tint(loading ? progressTint : nil)
			} else {
				ProgressView()
					.opacity(loading ? 1 : 0)
					.tint(loading ? progressTint : nil)
			}
			
			if let title, let systemImage {
				Label(title, systemImage: systemImage)
					.opacity(loading ? 0 : 1)
			} else if let systemImage {
				Image(systemName: systemImage)
					.imageScale(.large)
					.opacity(loading ? 0 : 1)
			} else if let title {
				Text(title)
					.underline(underline == true)
					.opacity(loading ? 0 : 1)
			}
		}
	}
}

struct TaskButton: View {
	var title: String?
	var systemImage: String?
	var progressTint: Color?
	var underline: Bool?
	@Bindable var task: ScreenTask
	var action: () async throws -> Void
		
	private var loading: Bool {
		task.status == .fetching
	}
	
	var body: some View {
		Button {
			Task {
				try await task.run {
					try await action()
				}
			}
		} label: {
			TaskButtonLabel(title: title, systemImage: systemImage, progressTint: progressTint, underline: underline, task: task)
		}
		.disabled(loading)
		.alert(isPresented: $task.showError, error: task.error) {}
	}
}

#Preview {
	@Previewable @State var task = ScreenTask()
	task.status = .fetching
	return TaskButton(title: "Book", systemImage: "checkmark", progressTint: .white, task: task) {
		
	}
	.buttonStyle(BorderedProminentButtonStyle())
	.padding()
	.background(.black)
}
