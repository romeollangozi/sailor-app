//
//  DocumentDeclarationPreparationScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 20.2.25.
//

import SwiftUI
import VVUIKit

protocol DocumentDeclarationPreparationScreenViewModelProtocol {
    var screenState: ScreenState { get set }
    var document: TravelDocuments.Document { get }
    var landing: TravelDocuments { get }
    func onProceed()
    func navigateBack()
    func onClose()
    func onAppear()
    func onRefresh()
}

struct DocumentDeclarationPreparationScreen: View {
    @State var viewModel: DocumentDeclarationPreparationScreenViewModelProtocol
    @State private var isShowingInfoDrawer = false

    init(
        document: TravelDocuments.Document,
        landing: TravelDocuments
    ) {
        viewModel = DocumentDeclarationPreparationViewModel(document: document, landing: landing)
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            VStack {
                toolbar
                    .padding(.horizontal, Spacing.space24)
                VStack(spacing: Spacing.space24) {
                    Text(viewModel.document.name)
                        .font(.vvHeading1Bold)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, Spacing.space16)
                    Text("Please confirm if you are planning on travelling under an \(viewModel.document.name)")
                        .font(.vvHeading5Light)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    Button("I still need to apply for an \(viewModel.document.name)") {
                        isShowingInfoDrawer = true
                    }
                    .sheet(isPresented: $isShowingInfoDrawer) {
                        InfoDrawerScreen(travelDocuments: viewModel.landing, document: viewModel.document)
                                .presentationDetents([.height(460)])
                        }
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .buttonStyle(TertiaryButtonStyle())
                    Spacer()
                    Image("Semaphore")
                        .padding(.bottom, Spacing.space64)
                    Button("Yes, I confirm") {
                        viewModel.onProceed()
                    }
                    .primaryButtonStyle()
                }
                .padding(Spacing.space24)
            }
            .background(Color.softYellow)
        } onRefresh: {
            viewModel.onRefresh()
        }
        .onAppear {
            viewModel.onAppear()
        }
    }

    var toolbar: some View {
        HStack(alignment: .top, spacing: Spacing.space24) {
            BackButton({
                viewModel.navigateBack()
            })
            .opacity(0.8)
            Spacer()
            ClosableButton(action: {
                viewModel.onClose()
            })
        }
    }
}

struct DocumentDeclarationScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DocumentDeclarationPreparationScreen(
                document: TravelDocuments.sample().documentStages.last!.documents.first!, landing: TravelDocuments.sample()
            )
        }
    }
}
