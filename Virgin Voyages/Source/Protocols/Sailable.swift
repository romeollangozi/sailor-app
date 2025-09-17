//
//  Sailable.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/15/24.
//

import SwiftUI
import VVUIKit

protocol Sailable {
	var navigationMode: NavigationMode { get }
	var task: SailTask { get }
	func startInterview()
	func startOver()
	func back()
	func reload(_ sailor: Endpoint.SailorAuthentication) async throws
}

extension Sailable {
	var backgroundColor: Color {
		Color(hex: task.backgroundColorCode)
	}
}

enum NavigationMode {
	case dismiss
	case back
	case both
}

struct SailableToolbarModifier: ViewModifier {
	@Environment(\.dismiss) var dismiss
	var task: Sailable
	
	func body(content: Content) -> some View {
		content.toolbar {
			ToolbarItem(placement: .principal) {
				Text("")
			}
			
			switch task.navigationMode {
			case .dismiss:
				ToolbarItem(placement: .topBarTrailing) {
					SailableCloseButton() {
						dismiss()
					}
				}
			case .back:
				ToolbarItem(placement: .topBarLeading) {
					SailableBackButton() {
						task.back()
					}
				}
				
			case .both:
				ToolbarItem(placement: .topBarTrailing) {
					SailableCloseButton() {
						dismiss()
					}
				}
				
				ToolbarItem(placement: .topBarLeading) {
					SailableBackButton() {
						task.back()
					}
				}
			}
		}
	}
}

struct SailableStepModifier: ViewModifier {
	@Environment(\.contentSpacing) var spacing
	func body(content: Content) -> some View {
		content
			.fontStyle(.body)
			.frame(maxWidth: .infinity)
			.padding(spacing * 2)
	}
}

extension View {
	func sailableStepStyle() -> some View {
		self.modifier(SailableStepModifier())
	}
}

extension View {
	func sailableToolbar(task: Sailable) -> some View {
		self.modifier(SailableToolbarModifier(task: task))
	}
}
