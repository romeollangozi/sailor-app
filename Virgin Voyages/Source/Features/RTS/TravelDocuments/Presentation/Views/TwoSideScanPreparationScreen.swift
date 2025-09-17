//
//  TwoSideScanPreparationScreen.swift
//  Virgin Voyages
//
//  Created by Pajtim on 10.3.25.
//

import SwiftUI
import VVUIKit

protocol TwoSideScanPreparationViewModelProtocol {
    var screenState: ScreenState { get set }
    var document: TravelDocuments.Document { get }
    var shouldShowPhotoPicker: Bool { get set}
    var selectedImageData: Data? { get set }
    func onScanProceed()
    func navigateBack()
    func onClose()
    func onUploadDocumentFromMedia()
    func uploadPhoto(imageData: Data)
    func onAppear()
    func onRefresh()
}

struct TwoSideScanPreparationScreen: View {
    @State var viewModel: TwoSideScanPreparationViewModelProtocol

    init(document: TravelDocuments.Document, firstDocumentPhotoId: String = "") {
        viewModel = TwoSideScanPreparationViewModel(document: document, documentPhotoId: firstDocumentPhotoId)
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            VStack {
                toolbar
                    .padding(.horizontal, Spacing.space24)
                VStack(spacing: Spacing.space24) {
                    Text("\(viewModel.document.name) scan")
                        .font(.vvHeading1Bold)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, Spacing.space16)
                    Text("Side 1: Scanned")
                        .font(.vvHeading5Bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.darkGray)
                    Text("Please scan the back of your \(viewModel.document.name)")
                        .font(.vvHeading5Light)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    Image("Semaphore")
                        .padding(.bottom, Spacing.space64)
                    Button("Take photo") {
                        viewModel.onScanProceed()
                    }
                    .primaryButtonStyle()
                    Button("Upload from Photos") {
                        viewModel.onUploadDocumentFromMedia()
                    }
                    .buttonStyle(TertiaryButtonStyle())
                }
                    .padding(.horizontal, Spacing.space24)
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

struct TwoSideScanPreparationScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TwoSideScanPreparationScreen(
                document: TravelDocuments.sample().documentStages.last!.documents.first!
            )
        }
    }
}
