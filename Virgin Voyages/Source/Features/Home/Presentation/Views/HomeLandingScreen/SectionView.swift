//
//  SectionView.swift
//  Virgin Voyages
//
//  Created by TX on 13.3.25.
//

import SwiftUI

struct SectionView: View {

    let section: HomeSection
    let viewModel: HomeLandingScreenViewModelProtocol

    init(viewModel: HomeLandingScreenViewModelProtocol, sectionContainer: HomeSectionContainer) {
        self.section = sectionContainer.homeSection
        self.viewModel = viewModel
    }

    var body: some View {

        VStack(spacing: 16) {
            switch section {
			case _ as HomeCheckInSection:
                HomeCheckInView(viewModel: viewModel.reloadableViewModels.homeCheckInViewModel)
            case let musterDrill as HomeMusterDrillSection:
                HomeMusterDrillView(viewModel: HomeMusterDrillViewModel(musterDrillSection: musterDrill))
            case _ as HomeNotificationsSection:
                HomeNotificationView(viewModel: viewModel.reloadableViewModels.homeNotificationsViewModel)
            case _ as HomePlannerSection:
                HomePlannerOnboardView(viewModel: viewModel.reloadableViewModels.homePlannerOnboardViewModel)
            case let actions as HomeActionsSection:
                HomeActionsView(viewModel: HomeActionsViewModel(homeActions: actions))
            case let merchandise as HomeMerchandise:
                HomeMerchandiseView(viewModel: HomeMerchandiseViewModel(homeMerchandise: merchandise))
            case _ as VoyageActivitiesSection:
                PlanAndBookSectionView(viewModel: viewModel.reloadableViewModels.voyageActivitiesViewModel)
            case let homePlanner as HomePlannerPreviewSection:
                HomePlannerView(viewModel: HomePlannerViewModel(homePlanner: homePlanner))
            case let addOnsPromo as HomeAddOnsPromoSection:
                HomeAddOnsPromoView(viewModel: HomeAddOnsPromoViewModel(homeAddOnsPromo: addOnsPromo))
            case let myNextVoyageSection as MyNextVoyageSection:
                MyNextVirginVoyageView(viewModel: MyNextVirginVoyageViewModel(myNextVoyageSection: myNextVoyageSection, sailingMode: viewModel.sailingMode))
            case _ as HomeSwitchVoyageSection:
                HomeSwitchVoyageView(viewModel: HomeSwitchVoyageViewModel(sailingMode: viewModel.sailingMode))
            case let footer as HomeFooterSection:
                HomeFooterView(homeFooter: footer)
            case _ as HomeHeader:
                EmptyView().frame(height: 0.0)
            default:
				EmptyView().frame(height: 0.0)
            }
        }
    }
}

#Preview {
    SectionView(
        viewModel: HomeLandingScreenPreviewViewModel(),
        sectionContainer: HomeSectionContainer(EmptySection(id: "123", title: "This is a home section"))
    )
}
