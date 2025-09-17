//
//  DocumentTypeSelectionScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 20.2.25.
//

import SwiftUI
import VVUIKit

protocol DocumentTypeSelectionScreenViewModelProtocol {
    var screenState: ScreenState { get set }
    var documentStage: TravelDocuments.DocumentStage { get }
    var travelDocuments: TravelDocuments { get }
    var canNavigateBack: Bool { get set}
    var isShowingMultiCategorySelection: Bool { get set }
    var selectedDocument: TravelDocuments.Document { get set }
    func onDocumentSelect(document: TravelDocuments.Document)
    func onMultiCategoryDocumentSelect(document: TravelDocuments.Document)
    func navigateBack()
    func onAppear()
    func onRefresh()
    func onClose()
}

struct DocumentTypeSelectionScreen: View {
    @State var viewModel: DocumentTypeSelectionScreenViewModelProtocol
    @State private var isShowingInfoDrawer = false
    @State private var selectedMultiCategoryDocument: TravelDocuments.Document? = nil

    init(
        viewModel: DocumentTypeSelectionScreenViewModelProtocol = DocumentTypeSelectionViewModel(), canNavigateBack: Bool = true ) {
        _viewModel = State(wrappedValue: viewModel)
        self.viewModel.canNavigateBack = canNavigateBack
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            VStack(alignment: .leading, spacing: Spacing.space24) {
                toolbar
                    .padding(.horizontal, Spacing.space24)
                VStack(alignment: .leading, spacing: Spacing.space24) {
                    Text(viewModel.documentStage.title)
                        .font(.vvHeading1Bold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(viewModel.documentStage.description)
                        .font(.vvHeading5Light)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Text("Please select the document you wish to travel under")
                        .font(.vvHeading5Medium)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    documentSelectionButtons()
                    Button("I don't have any of these") {
                        isShowingInfoDrawer = true
                    }
                    .sheet(isPresented: $isShowingInfoDrawer) {
                        InfoDrawerScreen(travelDocuments: viewModel.travelDocuments)
                                .presentationDetents([.height(460)])
                        }
                    .buttonStyle(TertiaryButtonStyle())
                }
                .padding(.horizontal, Spacing.space24)
            }
            .background(Color.softYellow)
        }onRefresh: {
            viewModel.onRefresh()
        }
        .onAppear() {
            viewModel.onAppear()
        }
    }

    func documentSelectionButtons() -> some View {
        HFlowStack(alignment: .leading) {
            ForEach(viewModel.documentStage.documents) { document in
                Button(document.name) {
                    viewModel.onDocumentSelect(document: document)
                }
                .buttonStyle(PrimaryCapsuleButtonStyle())
            }
            .sheet(isPresented: $viewModel.isShowingMultiCategorySelection) {
                infoOptionsSheet(document: viewModel.selectedDocument)
                .presentationDetents([.height(460)])
            }
        }
    }
    
    func infoOptionsSheet(document: TravelDocuments.Document = TravelDocuments.Document.empty()) -> some View {
        let options: [InfoOptionsSheet.Option] = (document.categoryDetails?.categories ?? []).map { doc in
            InfoOptionsSheet.Option(name: doc.name) {
                viewModel.onMultiCategoryDocumentSelect(document: doc)
            }
        }
        return InfoOptionsSheet(
                        title: document.categoryDetails?.title ?? "",
                        description: document.categoryDetails?.description ?? "",
                        options: options
                    )
                    .presentationDetents([.height(460)])
    }
    
    var toolbar: some View {
        HStack(alignment: .top, spacing: Spacing.space32) {
            if viewModel.canNavigateBack {
                BackButton({
                    viewModel.navigateBack()
                })
                .opacity(0.8)
            }
            Spacer()
            ClosableButton(action: {
                viewModel.onClose()
            })
        }
    }
}

struct DocumentTypeSelectionScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DocumentTypeSelectionScreen()
        }
    }
}
