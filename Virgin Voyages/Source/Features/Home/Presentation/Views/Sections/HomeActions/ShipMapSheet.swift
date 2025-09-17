//
//  ShipMapSheet.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 19.5.25.
//

import SwiftUI
import VVUIKit


protocol ShipMapViewModelProtocol {
    var screenState: ScreenState { get set }
    var deckPlanUrl: String { get }
    func onAppear()
}

struct ShipMapSheet: View {
    @State private var viewModel: ShipMapViewModelProtocol
    
    init(viewModel: ShipMapViewModelProtocol = ShipMapViewModel()) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
			WebViewerWithShareFromURL(url: URL(string: viewModel.deckPlanUrl))
        }onRefresh: {
            viewModel.onAppear()
        }
        .onAppear{
            viewModel.onAppear()
        }
        
    }
}

#Preview {
    let viewModel = ShipMapViewModel()
    ShipMapSheet(viewModel: viewModel)
}
