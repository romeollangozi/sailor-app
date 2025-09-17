//
//  DeleteDocumentScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 21.3.25.
//

import SwiftUI
import VVUIKit

protocol DeleteDocumentScreenViewModelProtocol {
    var screenState: ScreenState { get set }
    var documentName: String { get }
    func onConfirmDelete()
    func onCancel()
}

struct DeleteDocumentScreen: View {
    @State var viewModel: DeleteDocumentScreenViewModelProtocol

    init(document: TravelDocumentDetails, isTypeVisa: Bool) {
        let viewModel = DeleteDocumentViewModel(document: document, isTypeVisa: isTypeVisa)
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            ConfirmationPopupAlert(
                title: "Delete \(viewModel.documentName)",
                message: "Are you sure? You will need a valid \(viewModel.documentName) to voyage with us. After deleting you will have the opportunity to add a new one.",
                confirmButtonText: "Yes, delete \(viewModel.documentName)",
                cancelButtonText: "Cancel",
                isLoading: .constant(false), // TODO: implement loading state in viewModel.onUseExistingDocument
                onConfirm: {
                    viewModel.onConfirmDelete()
                },
                onCancel: {
                    viewModel.onCancel()
                }
            )
        }onRefresh: {
            
        }
    }
}

struct DeleteDocumentScreen_Previews: PreviewProvider {
    static var previews: some View {
        DeleteDocumentScreen(document: TravelDocumentDetails.sample(), isTypeVisa: false)
    }
}
