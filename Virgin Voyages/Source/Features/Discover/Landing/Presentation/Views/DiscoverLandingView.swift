//
//  DiscoverLandingView.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 10.1.25.
//
import SwiftUI
import VVUIKit

protocol DiscoverLandingViewModelProtocol {
	var screenState: ScreenState {get set}
	
	var shipSpacesCard: DiscoverCardViewModel? { get }
	var eventLineUpCard: DiscoverCardViewModel? { get }
	var shoreThingsCard: DiscoverCardViewModel? { get }
	var addOnsCard: DiscoverCardViewModel? { get }
	
	func onFirstAppear()
	func onReAppear()
	func onRefresh()
}

struct DiscoverLandingView: View {
    
    @State var viewModel: DiscoverLandingViewModelProtocol
    let navigateTo: ((DiscoverNavigationRoute) -> Void)?
    
    init(viewModel: DiscoverLandingViewModelProtocol = DiscoverLandingViewModel(),
         navigateTo: ((DiscoverNavigationRoute) -> Void)? = nil) {
        _viewModel = State(wrappedValue: viewModel)
        self.navigateTo = navigateTo
    }
    
    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            
            VVUIKit.ContentView(backgroundColor: .white,
                                scrollIndicator: .hidden) {
                
                VStack(spacing: Spacing.space10) {
                    
                    if let shipSpacesCard = viewModel.shipSpacesCard {
                        Button {
                            navigateTo?(.shipSpacesView)
                        } label: {
                            DiscoverRow(title: shipSpacesCard.title,
                                        imageUrl: shipSpacesCard.imageURL,
                                        imageName: shipSpacesCard.imageName)
                        }
                        .frame(height: UIScreen.main.bounds.height * ScreenHeight.oneThirdOfScreenWithTabBar)
                    }
                    
                    if let eventLineUpCard = viewModel.eventLineUpCard {
                        Button {
                            navigateTo?(.eventLandingView)
                        } label: {
                            DiscoverRow(title: eventLineUpCard.title,
                                        imageUrl: eventLineUpCard.imageURL,
                                        imageName: eventLineUpCard.imageName)
                        }
                        .frame(height: UIScreen.main.bounds.height * ScreenHeight.oneThirdOfScreenWithTabBar)
                    }
                    
                    HStack(spacing: Spacing.space10) {
                        if let shoreThingsCard = viewModel.shoreThingsCard {
                            Button(action: {
                                navigateTo?(.shoreThings)
                            }, label: {
                                DiscoverRow(title: shoreThingsCard.title,
                                            imageUrl: shoreThingsCard.imageURL,
                                            imageName: shoreThingsCard.imageName)
                            })
                        }
                        
                        if let addOnsSpaceCard = viewModel.addOnsCard {
                            Button(action: {
                                navigateTo?(.addOnList())
                            }, label: {
                                DiscoverRow(title: addOnsSpaceCard.title,
                                            imageUrl: addOnsSpaceCard.imageURL,
                                            imageName: addOnsSpaceCard.imageName)
                            })
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height * ScreenHeight.oneThirdOfScreenWithTabBar)
                }
                .padding(Spacing.space10)
            }
        } onRefresh: {
            viewModel.onRefresh()
        }.onAppear(onFirstAppear: {
            viewModel.onFirstAppear()
        }, onReAppear: {
            viewModel.onReAppear()
        })
    }
}

#Preview("Discover Landing View") {
	DiscoverLandingView(viewModel: DiscoverLandingPreviewViewModel())
}

final class DiscoverLandingPreviewViewModel: DiscoverLandingViewModelProtocol {
	var screenState: ScreenState = .content
	
	var shipSpacesCard: DiscoverCardViewModel? {
		DiscoverCardViewModel(
			title: "Ship Spaces",
			imageURL: URL(string: "https://cert.gcpshore.virginvoyages.com/dam/jcr:423cd613-8de2-4a23-b0fc-c6f31ba0c980/IMG-discover-ship-1200-1920.jpg")
		)
	}
	
	var eventLineUpCard: DiscoverCardViewModel? {
		DiscoverCardViewModel(
			title: "Event Lineup",
			imageURL: URL(string: "https://cert.gcpshore.virginvoyages.com/dam/jcr:5d8a267c-22e7-499c-8c2f-ad136243b87f/IMG-discover-disco-ball-800x1280.jpg")
		)
	}
	
	var shoreThingsCard: DiscoverCardViewModel? {
		DiscoverCardViewModel(
			title: "Shore Things",
			imageURL: URL(string: "https://cert.gcpshore.virginvoyages.com/dam/jcr:32c5ca08-1349-4bc9-b996-83ab38c0c569/IMG-discover-ports-1200-1920.jpg")
		)
	}
	
	var addOnsCard: DiscoverCardViewModel? {
		DiscoverCardViewModel(
			title: "Add-Ons",
			imageURL: URL(string: "https://cert.gcpshore.virginvoyages.com/dam/jcr:af3f25ad-97a3-4cc1-b3a9-4e40133e6c3e/IMG-discover-disco-ball-800x1280.jpg")
		)
	}
	
	func onFirstAppear() {
		
	}
	
	func onReAppear() {
		
	}
	
	func onRefresh() {
		
	}
}
