//
//  WarningPassportExpireScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 17.6.25.
//

import SwiftUI
import VVUIKit

protocol WarningPassportExpireScreenViewModelProtocol {
    var screenState: ScreenState { get set }
    func navigateBack()
    func onAppear()
    var title: String { get }
    var htmlDescription: String { get }
}

struct WarningPassportExpireScreen: View {
    @State var viewModel: WarningPassportExpireScreenViewModelProtocol
    let didTapImGoodToTravel: VoidCallback
    init(document: TravelDocumentDetails, didTapImGoodToTravel: @escaping VoidCallback) {
        self.didTapImGoodToTravel = didTapImGoodToTravel
        _viewModel = State(wrappedValue: WarningPassportExpireViewModel(document: document))
    }
    
    var body: some View {
        VStack {
            toolbar
                .padding(.horizontal, Spacing.space24)
            VStack(alignment: .leading, spacing: Spacing.space40) {
                Text(viewModel.title)
                    .font(.vvHeading1Bold)
                    .padding(.top, Spacing.space16)
                HTMLText(htmlString: viewModel.htmlDescription, fontType: .light, fontSize: .size18, color: .darkGray)
            }
            .padding(Spacing.space24)
                Spacer()
                Button("I’m good to travel") {
                    self.didTapImGoodToTravel()
                }
                .buttonStyle(SecondaryButtonStyle())
                .padding(.horizontal, Spacing.space24)

                Button("Cancel") {
                    viewModel.navigateBack()
                }
                .buttonStyle(TertiaryButtonStyle())
                .padding(.horizontal, Spacing.space24)

        }
    }

    var toolbar: some View {
        HStack(alignment: .top, spacing: Spacing.space24) {
            BackButton({
                viewModel.navigateBack()
            })
            .opacity(0.8)
            Spacer()
        }
    }
}

struct WarningPassportExpireScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WarningPassportExpireScreen(document: TravelDocumentDetails.sample(), didTapImGoodToTravel: {})
        }
    }
}
