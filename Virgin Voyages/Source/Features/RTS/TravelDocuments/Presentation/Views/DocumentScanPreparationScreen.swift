//
//  DocumentScanPreparationScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 20.2.25.
//

import SwiftUI
import VVUIKit

protocol DocumentScanPreparationScreenViewModelProtocol {
    var screenState: ScreenState { get set }
    var document: TravelDocuments.Document { get }
    var landing: TravelDocuments { get }
    var shouldShowPhotoPicker: Bool { get set}
    var selectedImageData: Data? { get set }
    var documentName: String { get }
    func onScanProceed()
    func onUploadDocumentFromMedia()
    func uploadPhoto(imageData: Data)
    func navigateBack()
    func onClose()
    func onAppear()
    func onRefresh()
}

struct DocumentScanPreparationScreen: View {
    @State var viewModel: DocumentScanPreparationScreenViewModelProtocol
    @State private var isShowingInfoDrawer = false
    
    init(
        document: TravelDocuments.Document,
        landing: TravelDocuments
    ) {
        viewModel = DocumentScanPreparationViewModel(document: document, landing: landing)
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            ZStack {
                toolbar
                    .padding(.horizontal, Spacing.space24)
                VStack(spacing: Spacing.space24) {
                    Text("\(viewModel.documentName) scan")
                        .font(.vvHeading1Bold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, Spacing.space16)
                    Text("We need to take a photo of your \(viewModel.documentName) for immigration.")
                        .font(.vvHeading5Light)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    Button("I don't have a \(viewModel.document.name)") {
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
                    Spacer()
                    Button("Take photo") {
                        viewModel.onScanProceed()
                    }
                    .primaryButtonStyle()
                    Button("Upload from Photos") {
                        viewModel.onUploadDocumentFromMedia()
                    }
                    .buttonStyle(TertiaryButtonStyle())
                }
                .padding(Spacing.space24)
            }
            .background(Color.softYellow)
            .sheet(isPresented: $viewModel.shouldShowPhotoPicker) {
                VVNativePhotoPickerView(imageData: $viewModel.selectedImageData)
            }
            .onChange(of: viewModel.selectedImageData) { oldValue, newValue in
                if let data = newValue {
                    viewModel.uploadPhoto(imageData: data)
                }
            }
        }
        onRefresh: {
            viewModel.onRefresh()
        }
        .onAppear(){
            viewModel.onAppear()
        }
    }

    var toolbar: some View {
        VStack{
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
            Spacer()
        }
    }
}

struct DocumentScanScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DocumentScanPreparationScreen(
                document: TravelDocuments.sample().documentStages.last!.documents.first!, landing: TravelDocuments.sample()
            )
        }
    }
}
