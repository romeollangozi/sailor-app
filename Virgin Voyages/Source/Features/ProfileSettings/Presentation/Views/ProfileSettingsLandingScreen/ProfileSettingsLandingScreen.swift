//
//  ProfileSettingsLandingScreen.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 29.10.24.
//

import SwiftUI
import VVUIKit

struct ProfileSettingsLandingScreen: View {
    
    @State private var viewModel: ProfileSettingsLandingScreenViewModel

    // Legacy model
	var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
    
    init(viewModel: ProfileSettingsLandingScreenViewModel = ProfileSettingsLandingScreenViewModel()) {
        _viewModel = State(wrappedValue:viewModel)
    }
    
    var body: some View {
		ZStack {
			if viewModel.screenState == .loading {
				// Loading
				ProgressView()
					.font(.footnote)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.background(Color.clear)
			} else {
				// Content
				ScrollView {
					VStack(spacing: Paddings.defaultVerticalPadding48) {

						// Header text with profile picture
						ProfileSettingsHeaderView(content: viewModel.landingScreenModel.content) {
						}

						// Menu items
						let profileSettingsMenuListViewModel = ProfileSettingsMenuListViewModel(menuItems: viewModel.landingScreenModel.menuItems)
						ProfileSettingsMenuListView(viewModel: profileSettingsMenuListViewModel)

						VStack(spacing: Spacing.space0) {
							logoutButton
							
							deleteAccounttButton
						}
					}
					.padding(.horizontal, Paddings.defaultHorizontalPadding)
				}
			}
		}
		.scrollIndicators(.hidden)
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: VVBackButton())
		.task {
			await viewModel.refresh()
		}

    }
    
    private var logoutButton: some View {
        Button("Logout") {
            viewModel.showLogOutConfirmation()
        }
        .buttonStyle(SecondaryButtonStyle())
        .alert("Confirm Please", isPresented: $viewModel.shouldShowLogoutConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Log out", role: .destructive) {
				viewModel.logout()
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
    }
	
	private var deleteAccounttButton: some View {
		Button("Delete Account") {
			viewModel.onDeleteAcconutTap()
		}
        .buttonStyle(TertiaryButtonStyle())
		.padding(.bottom, Paddings.defaultVerticalPadding24)
	}
}

#Preview {
    NavigationStack {
        let mockRepository = MockPreviewProfileSettingsRepository()
        ProfileSettingsLandingScreen(viewModel: ProfileSettingsLandingScreenViewModel(getProfileSettingsLandingScreenUseCase: GetProfileSettingsLandingScreenUseCase(profileSettingsRepository: mockRepository)))
    }
}

