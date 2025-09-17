//
//  ClaimBookingLandingView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/4/24.
//

import SwiftUI
import VVUIKit

protocol ClaimBookingLandingViewModelProtocol {
	var sailorFullName: String? { get }
	var sailorPhotoURL: URL? { get }

    func tappedBookVoyage()
	func tappedLogout()
    func claimABookingTapped()
}

extension ClaimBookingLandingView {
    static func create(backButtonAction: VoidCallback? = nil) -> ClaimBookingLandingView {
        let viewModel = ClaimBookingLandingViewModel()
        return ClaimBookingLandingView(viewModel: viewModel)
    }
}

struct ClaimBookingLandingView: View {
    
    private var backButtonAction: VoidCallback? = nil
    @State private var viewModel: ClaimBookingLandingViewModelProtocol
    
    init(backButtonAction: VoidCallback? = nil, viewModel: ClaimBookingLandingViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
        self.backButtonAction = backButtonAction
    }
    
    var body: some View {
        VStack(spacing: Spacing.space0) {
			VStack(alignment: .leading, spacing: Spacing.space24) {
				HStack(spacing: Spacing.space0) {
					Spacer()
					Button {
						viewModel.tappedLogout()
					} label: {
						Text("Logout")
							.fontStyle(.smallButton)
							.foregroundColor(.darkGray)
					}
					.padding(.trailing, Spacing.space10)
					if let sailorPhotoURL = viewModel.sailorPhotoURL {
                        AuthURLImageView(imageUrl: sailorPhotoURL.absoluteString, size: Sizes.defaultSize64, clipShape: .circle, defaultImage: "ProfilePlaceholder")
					} else {
						CircularImageView(image: .profilePlaceholder, size: Spacing.space64)
					}
				}
				.padding(.top, Spacing.space22)
                HStack(spacing: Spacing.space0) {
					if let sailorFullName = viewModel.sailorFullName {
						Text(sailorFullName)
							.fontStyle(.largeTitle)
					}
                    Spacer()
                }
                Text("There’s nothing sadder than a sailor without a ship. Let’s get your voyage sorted so you can start planning…")
                    .fontStyle(.largeTagline)
                    .foregroundColor(Color(hex: "#686D72"))
            }
            .padding(.horizontal, 22.0)
            Spacer()
            DoubleDivider()
            VStack(spacing: Spacing.space16) {
                Button("Claim a booking") {
                    viewModel.claimABookingTapped()
                }
                .buttonStyle(PrimaryButtonStyle())
                Button("Book a voyage") {
                    viewModel.tappedBookVoyage()
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(EdgeInsets(top: Spacing.space32,
                                leading: Spacing.space24,
                                bottom: Spacing.space32,
                                trailing: Spacing.space24))
        }
    }
}
