//
//  WarningMultiEntryVisaScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 19.3.25.
//

import SwiftUI
import VVUIKit

protocol WarningMultiEntryVisaScreenViewModelProtocol {
    var screenState: ScreenState { get set }
    func onDelete()
    func navigateBack()
    func onAppear()
}

struct WarningMultiEntryVisaScreen: View {
    @State var viewModel: WarningMultiEntryVisaScreenViewModelProtocol

    init(document: TravelDocumentDetails) {
        viewModel = WarningMultiEntryVisaViewModel(document: document)
        self.viewModel = viewModel
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            toolbar
                .padding(.horizontal, Spacing.space24)
            VStack(alignment: .leading, spacing: Spacing.space24) {
                Text("Multi-Entry Visa Required")
                    .font(.vvHeading1Bold)
                    .padding(.top, Spacing.space16)
                Text("It looks like the visa you have submitted is NOT a multi-entry visa.")
                    .font(.vvHeading5Light)
                    .multilineTextAlignment(.leading)
                Text("For your itinerary and citizenship we require a multi-entry visa. Please either correct your visa type or upload the correct visa. ")
                    .font(.vvHeading5Light)
                    .multilineTextAlignment(.leading)
            }
            .padding(Spacing.space24)
                Spacer()
                Button("Delete visa and re-upload") {
                    viewModel.onDelete()
                }
                .buttonStyle(SecondaryButtonStyle())
                .padding(.horizontal, Spacing.space24)

                Button("View visa details") {
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

struct WarningMultiEntryVisaScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WarningMultiEntryVisaScreen(document: TravelDocumentDetails.sample())
        }
    }
}
