//
//  SailorPickerV2.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 27.11.24.
//

import SwiftUI
import VVUIKit

struct SailorPickerV2: View {
	let options: [SailorModel]
	@Binding var selected: [SailorModel]
	let warnings: [SailorModel]
	let booked: [SailorModel]
	let notAllowed: [SailorModel]
	let showAddNew: Bool
	let showOverlayIcons: Bool
	let isSingleSelection: Bool
	let onAddNew: VoidCallback?
	let onSelected: (([SailorModel]) -> Void)?

	init(sailors: [SailorModel],
		 selected: Binding<[SailorModel]>,
		 warnings: [SailorModel] = [],
		 booked: [SailorModel] = [],
		 notAllowed: [SailorModel] = [],
		 showOverlayIcons: Bool = true,
		 isSingleSelection: Bool = false,
		 onAddNew: (() -> Void)? = nil,
		 onSelected: (([SailorModel]) -> Void)? = nil) {
		self.options = sailors
		_selected = selected
		self.warnings = warnings
		self.notAllowed = notAllowed
		self.showAddNew = onAddNew != nil
		self.onAddNew = onAddNew
		self.showOverlayIcons = showOverlayIcons
		self.booked = booked
		self.onSelected = onSelected
		self.isSingleSelection = isSingleSelection
	}

	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(alignment: .top, spacing: Spacing.space16) {
				ForEach(options, id: \.reservationGuestId) { sailor in
					Button {
						if booked.contains(sailor) { return }
						if notAllowed.contains(sailor) { return }
						if isSailorDisabled(sailor) { return }

						toggleSailorSelection(sailor)
						onSelected?(selected)
					} label: {
						createSailorPickerLabel(sailor)
					}
					.disabled(notAllowed.contains(sailor))
				}

				if showAddNew {
					Button {
						onAddNew?()
					} label: {
						SailorPickerLabelV2(
							title: "Add",
							style: .unselected,
							defaultImage: "Add new",
							showOverlayIcon: false
						)
					}
				}
			}
			.padding(Spacing.space4)
		}
		.onAppear {
			if isSingleSelection, selected.isEmpty, let first = options.first {
				selected = [first]
			}
		}
	}

	private func toggleSailorSelection(_ sailor: SailorModel) {
		if isSingleSelection {
			if selected.first == sailor {
				selected = []
			} else {
				selected = [sailor]
			}
		} else {
			if let index = selected.firstIndex(of: sailor) {
				if selected.count > 1 {
					selected.remove(at: index)
				}
			} else {
				selected.append(sailor)
			}
		}
	}

	private func isSailorDisabled(_ sailor: SailorModel) -> Bool {
		if !isSingleSelection { return false }
		guard let selectedSailor = selected.first else { return false }
		return sailor != selectedSailor
	}

	private func createSailorPickerLabel(_ sailor: SailorModel) -> SailorPickerLabelV2 {
		let isSelected = selected.contains(sailor)
		var style: SailorPickerLabelStyleV2 = .unselected
		var circleColor: Color = .borderGray
		let isDisabled = isSailorDisabled(sailor)
		let isNotAllowed = notAllowed.contains(sailor)

		if warnings.contains(sailor) {
			style = .error
		} else if booked.contains(sailor) {
			style = .booked
			circleColor = Color.borderGray
		} else if isSelected {
			style = .selected
			circleColor = .selectedBlue
		} else if isDisabled || isNotAllowed {
			style = .disabled
			circleColor = .borderGray.opacity(0.3)
		} else {
			style = .unselected
		}

		return SailorPickerLabelV2(title: sailor.name,
									 style: style,
									 circleColor: circleColor,
									 imageUrl: sailor.profileImageUrl,
									 showOverlayIcon: showOverlayIcons)
	}
}


private struct SailorPickerLabelV2: View {
	let title: String
	let imageUrl: String?
	let defaultImage: String
	let circleColor: Color
	let style: SailorPickerLabelStyleV2
	let showOverlayIcon: Bool

	init(title: String,
		 style: SailorPickerLabelStyleV2,
		 circleColor: Color = Color.borderGray,
		 imageUrl: String? = nil,
		 defaultImage: String? = "ProfilePlaceholder",
		 showOverlayIcon: Bool = true) {
		self.title = title
		self.imageUrl = imageUrl
		self.defaultImage = defaultImage ?? "ProfilePlaceholder"
		self.style = style
		self.showOverlayIcon = showOverlayIcon
		self.circleColor = circleColor
	}

	var body: some View {
		VStack {
			ZStack(alignment: .bottomTrailing) {
				AuthURLImageView(imageUrl: imageUrl ?? "", clipShape: .circle, defaultImage: self.defaultImage)
					.frame(width: 56, height: 56)
					.background(Color(uiColor: .systemGray6))
					.clipShape(Circle())
					.overlay {
						Circle()
							.stroke(style: .init(lineWidth: 6))
							.frame(width: 52, height: 52)
							.foregroundStyle(.background)
					}
					.overlay {
						Circle()
							.stroke(style: .init(lineWidth: 2))
							.frame(width: 56, height: 56)
							.foregroundStyle(self.circleColor)
					}
					.opacity(style == .disabled ? 0.4 : 1.0)
					.grayscale(style == .disabled ? 1.0 : 0.0)
				if(showOverlayIcon) {
					switch style {
					case .unselected:
						Image(systemName: "plus.circle.fill")
							.imageScale(.large)
							.foregroundStyle(.white,  Color.borderGray)
					case .selected:
						EmptyView()
					case .error:
						Image(systemName: "exclamationmark.circle.fill")
							.imageScale(.large)
							.foregroundStyle(.white, Color.brightOrange)
					case .booked:
						Image(systemName: "checkmark.circle.fill")
							.imageScale(.large)
							.foregroundStyle(.white, Color.selectedBlue)
					case .disabled:
						EmptyView()
					}
				}
			}
			.allowsHitTesting(false)
			
			Text(title)
				.frame(width: 56)
				.lineLimit(nil)
				.multilineTextAlignment(.center)
				.fixedSize(horizontal: false, vertical: true)
				.fontStyle(.caption)
				.tint(.secondary)
				.opacity(style == .disabled ? 0.6 : 1.0)
		}
	}
}

private enum SailorPickerLabelStyleV2 {
	case unselected
	case selected
	case error
	case booked
	case disabled
}


#Preview("No selection") {
	@Previewable @State var selectedSailors: [SailorModel] = []

	SailorPickerV2(sailors: SailorModel.samples(),
				   selected: $selectedSailors,
				   warnings: [])
}

#Preview("With selection") {
	@Previewable @State var selectedSailors: [SailorModel] = [
		SailorModel.sample().copy(id: "1", reservationGuestId: "1", name: "John"),
	]

	let availableSailors = [
		SailorModel.sample().copy(id: "1", reservationGuestId: "1", name: "John"),
		SailorModel.sample().copy(id: "2", reservationGuestId: "2", name: "Jane"),
		SailorModel.sample().copy(id: "3", reservationGuestId: "3", name: "Doe"),
	]

	SailorPickerV2(sailors: availableSailors,
				   selected: $selectedSailors,
				   warnings: [])
}

#Preview("With warnings") {
	@Previewable @State var selectedSailors: [SailorModel] = []
	let availableSailors = SailorModel.samples()

	SailorPickerV2(sailors: availableSailors,
				   selected: $selectedSailors,
				   warnings: [availableSailors[0]])
}

#Preview("With selection and warning") {
	@Previewable @State var selectedSailors: [SailorModel] = [
		SailorModel.sample().copy(id: "1", reservationGuestId: "1", name: "John"),
	]

	let availableSailors = [
		SailorModel.sample().copy(id: "1", reservationGuestId: "1", name: "John"),
		SailorModel.sample().copy(id: "2", reservationGuestId: "2", name: "Jane"),
		SailorModel.sample().copy(id: "3", reservationGuestId: "3", name: "Doe"),
	]

	SailorPickerV2(sailors: availableSailors,
				   selected: $selectedSailors,
				   warnings: [availableSailors[0]])
}

#Preview("With booked") {
	@Previewable @State var selectedSailors: [SailorModel] = []
	let availableSailors = SailorModel.samples()

	SailorPickerV2(sailors: availableSailors,
				   selected: $selectedSailors,
				   booked: [availableSailors[0]])
}


#Preview("With add new") {
	@Previewable @State var selectedSailors: [SailorModel] = []

	SailorPickerV2(sailors: SailorModel.samples(),
				   selected: $selectedSailors,
				   warnings: [],
				   onAddNew: {})
}

#Preview("Without overlay icons") {
	@Previewable @State var selectedSailors: [SailorModel] = []

	SailorPickerV2(sailors: SailorModel.samples(),
				   selected: $selectedSailors,
				   warnings: [],
				   showOverlayIcons: false,
				   onAddNew: {})
}

#Preview("First sailor deselected") {
	@Previewable @State var selectedSailors: [SailorModel] = []

	let availableSailors = [
		SailorModel.sample().copy(id: "1", reservationGuestId: "1", name: "User"),
		SailorModel.sample().copy(id: "2", reservationGuestId: "2", name: "Jane"),
		SailorModel.sample().copy(id: "3", reservationGuestId: "3", name: "Doe"),
	]

	SailorPickerV2(sailors: availableSailors,
				   selected: $selectedSailors,
				   warnings: [])
}

#Preview("Single selection") {
	@Previewable @State var selectedSailors: [SailorModel] = [SailorModel.sample().copy(id: "2", reservationGuestId: "2", name: "Jane")]

	let availableSailors = [
		SailorModel.sample().copy(id: "1", reservationGuestId: "1", name: "User"),
		SailorModel.sample().copy(id: "2", reservationGuestId: "2", name: "Jane"),
		SailorModel.sample().copy(id: "3", reservationGuestId: "3", name: "Doe"),
	]

	SailorPickerV2(sailors: availableSailors,
				   selected: $selectedSailors,
				   warnings: [],
				   isSingleSelection: true)
}
