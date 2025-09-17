//
//  CitizenshipCheckScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 18.2.25.
//

import SwiftUI
import VVUIKit

protocol CitizenshipCheckScreenViewModelProtocol {
    var screenState: ScreenState { get set }
    var travelDocuments: TravelDocuments { get }
    func onProceed()
    func onClose()
    func onAppear() async
    func onRefresh() async
}

struct CitizenshipCheckScreen: View {
    @State var viewModel: CitizenshipCheckScreenViewModelProtocol

    init(
        viewModel: CitizenshipCheckScreenViewModelProtocol = CitizenshipCheckViewModel()
    ) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            VStack {
                toolbar
                    .padding(.horizontal, Spacing.space24)
                VStack(spacing: Spacing.space24) {
                    Text(viewModel.travelDocuments.title)
                        .font(.vvHeading1Bold)
                        .padding(.top, Spacing.space16)
                    Text(viewModel.travelDocuments.description)
                        .font(.vvHeading5Light)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Image("Semaphore")
                        .padding(.bottom, Spacing.space64)
                    Button(viewModel.travelDocuments.actionText) {
                        viewModel.onProceed()
                    }
                    .primaryButtonStyle()
                }
                .padding(Spacing.space24)
            }
            .background(Color.softYellow)
        }onRefresh: {
            Task {
                await viewModel.onRefresh()
            }
        }
        .onAppear {
            Task {
                await viewModel.onAppear()
            }
        }
    }

    var toolbar: some View {
        HStack(alignment: .top, spacing: Spacing.space24) {
            Spacer()
            ClosableButton(action: {
                viewModel.onClose()
            })
        }
    }
}

struct TravelDocumentsCitizenshipCheckScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CitizenshipCheckScreen(
                viewModel: MockTravelDocumentsViewModel()
            )
        }
    }
}

private class MockTravelDocumentsViewModel: CitizenshipCheckScreenViewModelProtocol {
    var screenState: ScreenState = .content
    var travelDocuments: TravelDocuments = TravelDocuments.sample()
    func onProceed() {}
    func onClose() {}
    func onAppear() async { }
    func onRefresh() async { }
}
