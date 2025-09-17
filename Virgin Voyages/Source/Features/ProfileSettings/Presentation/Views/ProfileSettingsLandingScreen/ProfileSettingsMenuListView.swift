//
//  ProfileSettingsMenuListView.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 29.10.24.
//

import SwiftUI

protocol ProfileSettingsMenuListViewModelProtocol {
	var menuItems: [ProfileSettingsMenuListItemModel] { get }
	
	func onButtonTap(_ item: ProfileSettingsMenuListItemModel)
}

@Observable class ProfileSettingsMenuListViewModel: BaseViewModel, ProfileSettingsMenuListViewModelProtocol {
	let menuItems:[ProfileSettingsMenuListItemModel]

	init(menuItems: [ProfileSettingsMenuListItemModel]) {
		self.menuItems = menuItems
	}
	
	private func navigateToTermsAndConditions() {
		navigationCoordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigateTo(.termsAndConditions)
	}

	private func navigateToSetPinLanding() {
		navigationCoordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigateTo(.setPinLanding)
	}

	private func navigateToSwitchVoyage() {
		navigationCoordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigateTo(.switchVoyage)
	}
	
	func onButtonTap(_ item: ProfileSettingsMenuListItemModel) {
		switch item.id {
		case .setCasinoPin:
			navigateToSetPinLanding()
		case .switchVoyage:
			navigateToSwitchVoyage()
		case .termsAndConditions:
			navigateToTermsAndConditions()
		default:
			return
		}
	}
}

struct ProfileSettingsMenuListView: View {

    @State var viewModel: ProfileSettingsMenuListViewModelProtocol

    init (viewModel: ProfileSettingsMenuListViewModelProtocol) {
		_viewModel = State(wrappedValue: viewModel)
	}

    var body: some View {
        VStack(spacing: Paddings.defaultVerticalPadding) {
			ForEach(viewModel.menuItems, id: \.id) { item in
                Button(action: {
					viewModel.onButtonTap(item)
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: Paddings.cellTitleSubtitlePadding) {
                            Text(item.title)
                                .font(.custom(FontStyle.boldTagline.fontName, size: FontStyle.body.pointSize))
                                .foregroundColor(.titleColor)
                            if !item.description.isEmpty {
                                Text(item.description)
                                    .font(.custom(FontStyle.body.fontName, size: FontStyle.smallBody.pointSize))
                                    .foregroundColor(.vvGray)
                            }
                        }
                        Spacer()
                        Image(systemName: "arrow.right")
                            .foregroundColor(.accentColor)
                            .fontStyle(.lightTitle)
                    }
                    .padding(.vertical, Paddings.defaultVerticalPadding)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
				.disabled(!item.isEnabled)
                Divider()
            }
        }
    }
}

#Preview {
    let previewMenuItems:[ProfileSettingsMenuListItemModel] = [
		.init(id: .personalInformation, title: "Mock 1 Title", description: "Mock 1 Description", isEnabled: false, sequence: 0),
		.init(id: .commsAndMarketing, title: "Mock 2 Title", description: "Mock 2 Description", isEnabled: true, sequence: 1),
		.init(id: .paymentCard, title: "Mock 3 Title", description: "Mock 3 Description", isEnabled: false, sequence: 2),
    ]
	let viewModel = ProfileSettingsMenuListViewModel(menuItems: previewMenuItems)
    ProfileSettingsMenuListView(viewModel: viewModel)
}
