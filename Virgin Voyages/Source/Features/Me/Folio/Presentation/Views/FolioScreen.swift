//
//  FolioView.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 14.5.25.
//

import SwiftUI
import VVUIKit

import Foundation

protocol FolioScreenViewModelProtocol: AnyObject {
    var screenState: ScreenState { get set }
    var folio: Folio { get }

    func onAppear()
    func onRefresh()
}

struct FolioScreen: View {
    @State var viewModel: FolioScreenViewModelProtocol
    private let onBackClick: VoidCallback?

    init(viewModel: FolioScreenViewModelProtocol = FolioScreenViewModel(), onBackClick: VoidCallback? = nil) {
        _viewModel = State(wrappedValue: viewModel)
        self.onBackClick = onBackClick
    }

    var body: some View {
		DefaultScreenView(state: $viewModel.screenState,
						  toolBarOptions: .init(onBackTapped: {onBackClick?()}, backButtonPaddingTop: Spacing.space48)) {
            VStack{
                if let preCruise = viewModel.folio.preCruise {
                    FolioPreCruiseView(preCruise: preCruise)
                } else if let dependentSailor = viewModel.folio.shipboard?.dependent {
                    FolioLandingView(viewModel: FolioLandingViewModel(dependentSailor: dependentSailor))
                } else if let shipboard = viewModel.folio.shipboard {
                    FolioShipboardView(viewModel: FolioShipboardViewModel(shipboard: shipboard))
                }
            }
            .padding(.top, Spacing.space8)
        } onRefresh: {
			viewModel.onRefresh()
        }
        .onAppear {
			viewModel.onAppear()
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

#Preview("Folio Precuise") {
	ScrollView {
		FolioScreen(viewModel: FolioScreenPreviewViewModel(folio: .sampleWithPrecruise()))
    }
}

final class FolioScreenPreviewViewModel: FolioScreenViewModelProtocol {
	var screenState: ScreenState = .content
	
	var folio: Folio
    var folioResources: FolioResources
	
	init(folio: Folio, folioResources: FolioResources = .sample()) {
		self.folio = folio
        self.folioResources = folioResources
	}
	
	func onAppear() {
		
	}
	
	func onRefresh() {
		
	}
}

