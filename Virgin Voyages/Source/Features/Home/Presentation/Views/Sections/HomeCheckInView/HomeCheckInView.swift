//
//  HomeCheckInView.swift
//  Virgin Voyages
//
//  Created by TX on 17.3.25.
//

import SwiftUI
import VVUIKit

protocol HomeCheckInViewModelProtocol {
    var sailingMode: SailingMode { get }
    var section: HomeCheckInSection { get }
    var screenState: ScreenState { get }

    var shouldDisplayLargeCheckinSection: Bool { get }
    var shouldDisplayCTAInLargeCheckinSection: Bool { get }
    var shouldShowErrorIcon: Bool { get }
    
    // Embarkation
    var isStandardSailorType: Bool { get }
    var sailorTypeBackgroundColor: Color { get }
    var isPreCruiseEmbarkationDay: Bool { get }
    func getLocationURL() -> URL?
    func didTapViewBoardingPass()
    func didTapEmbarcationGuide()
    
    // Health Check
    var isHealthCheckAvailable: Bool { get }
    var getHealthCheckIconName: String { get }
    func onHealthCheckTapped()

    // Service Gratuities
    var isServiceGratuitiesAvailable: Bool { get }
    var getServiceGratuitiesImageURL: String { get }
    func onServiceGratuitiesTapped()
    
    func onAppear()
    func reload(sailingMode: SailingMode)
    func travelAssistantButtonTapped()
    func ctaButtonTapped()
}

struct HomeCheckInView: View {
    
    @State var viewModel: HomeCheckInViewModelProtocol
    
    init(viewModel: HomeCheckInViewModelProtocol) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: .zero) {
            if viewModel.screenState == .loading {
                ProgressView()
                    .padding(50)
            } else {
                
                if viewModel.isPreCruiseEmbarkationDay {
                    HomeEmbarkationReceiptView(viewModel: viewModel)
                        .padding([.horizontal], Spacing.space16)
                }

				HomeCheckInContentView(viewModel: viewModel)
					.padding(.horizontal, Spacing.space16)
                
                if let cabinMate = viewModel.section.rts.cabinMate {
                    CabinMatesCheckInView(title: cabinMate.title, subtitle: cabinMate.description, addTopBorder: !viewModel.shouldDisplayLargeCheckinSection) {
                        viewModel.travelAssistantButtonTapped()
                    }
                    .padding(.horizontal, Spacing.space16)
                }
                
                if !viewModel.isPreCruiseEmbarkationDay {
                    HomeEmbarkationView(viewModel: viewModel)
                        .padding([.top, .horizontal], Spacing.space16)
                }
               
                HomeHealthCheckView(viewModel: viewModel)
                    .padding(.top, Spacing.space16)
                    .onTapGesture {
                        viewModel.onHealthCheckTapped()
                    }

                HomeServiceGratuitiesView(viewModel: viewModel)
                    .padding(.vertical, Spacing.space16)
                    .onTapGesture {
                        viewModel.onServiceGratuitiesTapped()
                    }

            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .cornerRadius(Sizes.defaultSize24, corners: viewModel.section.rts.cabinMate != nil ? [.topLeft, .topRight] : .allCorners)
        .background(
            AnyView(
                Color.white.cornerRadius(Sizes.defaultSize24, corners: .allCorners)
            )
        )
        .shadow(
            color: viewModel.shouldDisplayLargeCheckinSection ? Color.clear : Color.black.opacity(0.05),
            radius: viewModel.shouldDisplayLargeCheckinSection ? 0 : 8,
            x: 0,
            y: viewModel.shouldDisplayLargeCheckinSection ? 0 : 4
        )
    }
}


#Preview {
  
    HomeCheckInView(viewModel: HomeCheckInViewModel.mockViewModel())
}
