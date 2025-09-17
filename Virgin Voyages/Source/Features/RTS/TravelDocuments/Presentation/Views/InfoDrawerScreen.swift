//
//  InfoDrawerScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 11.7.25.
//

import SwiftUI
import VVUIKit

protocol InfoDrawerScreenViewModelProtocol {
    var screenState: ScreenState { get set }
    var title: String { get }
    var description: String { get }
    var buttonTitle: String { get }
    func onOpenURL()
}

struct InfoDrawerScreen: View {
    @State var viewModel: InfoDrawerScreenViewModelProtocol
    @Environment(\.dismiss) private var dismiss
    
    init(travelDocuments: TravelDocuments, document: TravelDocuments.Document? = nil) {
        let viewModel = InfoDrawerViewModel(travelDocuments: travelDocuments, document: document)
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState, toolBarOptions: ToolBarOption(
            onCloseTapped: { dismiss() }
        )){
            VStack(alignment: .leading, spacing: Spacing.space24) {
               
                Text(viewModel.title)
                    .font(.vvHeading3Bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, -Spacing.space48)

                Text(viewModel.description)
                    .font(.vvSmall)
                    .foregroundStyle(.vvDarkGray)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, Spacing.space24)

                Button(viewModel.buttonTitle) {
                    viewModel.onOpenURL()
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding()
        } onRefresh: { }
        .presentationDetents([.height(450)])
    }
}

struct InfoDrawerScreen_Previews: PreviewProvider {
    static var previews: some View {
        InfoDrawerScreen(travelDocuments: TravelDocuments.sample())
    }
}
