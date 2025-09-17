//
//  ConfirmOrReplaceDocumentScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 1.4.25.
//

import SwiftUI
import VVUIKit

protocol ConfirmOrReplaceDocumentScreenViewModelProtocol {
    var screenState: ScreenState { get set }
    var documentName: String { get }
    func onUseExistingDocument()
    func onReplaceDocument()
    func onCancel()
}

struct ConfirmOrReplaceDocumentScreen: View {
    @State var viewModel: ConfirmOrReplaceDocumentScreenViewModelProtocol

    init(document: TravelDocuments.Document, landing: TravelDocuments) {
        let viewModel = ConfirmOrReplaceDocumentViewModel(document: document, landing: landing)
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            ConfirmationPopupAlert(
                title: "One minute, sailor",
                message: "It looks like you already have a \(viewModel.documentName) on file.",
                confirmButtonText: "Use document on file",
                confirmButtonStyle: .primary,
                cancelButtonText: "Use another document",
                isLoading: .constant(false), // TODO: implement loading state in viewModel.onUseExistingDocument
                onConfirm: {
                    viewModel.onUseExistingDocument()
                },
                onCancel: {
                    viewModel.onReplaceDocument()
                }
            )
        } onRefresh: {
            
        }
    }
}

struct ConfirmOrReplaceDocumentScreen_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmOrReplaceDocumentScreen(document: TravelDocuments.Document.empty(), landing: TravelDocuments.sample())
    }
}
