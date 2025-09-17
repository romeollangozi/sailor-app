//
//  DocumentReviewScreen.swift
//  Virgin Voyages
//
//  Created by Pajtim on 13.3.25.
//

import SwiftUI
import VVUIKit

protocol DocumentReviewViewModelProtocol {
    func navigateBack()
    func onClose()
    var screenState: ScreenState { get set }
    var myDocuments: MyDocuments { get }
    func onAppear()
    func navigateToDetails(from document: MyDocuments.Document)
    func navigateToPostVoyagePlanes()
}

struct DocumentReviewScreen: View {
    @State var viewModel: DocumentReviewViewModelProtocol
    @State var showSettingsAlert: Bool = false

    init(viewModel: DocumentReviewViewModelProtocol = DocumentReviewViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            ScrollView {
                toolbar

                VStack(alignment: .leading, spacing: Spacing.space16) {
                    Text("Travel Documents")
                        .font(.vvHeading1Bold)

                    Spacer()

                    VStack(alignment: .leading, spacing: Spacing.space24) {
                        ForEach(viewModel.myDocuments.documents, id: \.id) { document in
                            VStack(alignment: .leading) {
                                Text(document.name)
                                    .font(.vvHeading3Bold)

                                VStack(alignment: .trailing, spacing: Spacing.space16) {
                                    if document.moderationErrors.isEmpty {
                                        placeholderView(document: document)
                                    } else {
                                        rejectionView(message: nil)
                                    }
                                    Button {
                                        viewModel.navigateToDetails(from: document)
                                    } label: {
                                        Label("Edit", systemImage: "pencil.circle")
                                    }

                                }
                                .frame(maxWidth: .infinity, minHeight: 214)
                            }
                        }
                    }

                    if viewModel.myDocuments.hasPostVoyagePlans {
                        Button {
                            viewModel.navigateToPostVoyagePlanes()
                        } label: {
                            postVoyageSection
                        }
                    }

                    Divider()

                    informationSection

                    Button("Ok, got it") {
                        viewModel.onClose()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(.horizontal, Paddings.defaultVerticalPadding24)
                .padding(.bottom, Paddings.defaultVerticalPadding24)
            }
            .scrollIndicators(.hidden)

        } onRefresh: {

        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.onAppear()
        }
    }

    var toolbar: some View {
        HStack(alignment: .top) {
            Spacer()
            ZStack {
                Image(.toolbarSemaphore)
                    .resizable()
                    .frame(width: 144, height: 144)
                HStack {
                    Spacer()
                    ClosableButton(action: {
                        viewModel.onClose()
                    })
                    .padding(.horizontal, Spacing.space24)
                }
            }
            .frame(width: 144, height: 144, alignment: .trailing)
        }
    }

    private func placeholderView(document: MyDocuments.Document) -> some View {
        VStack(spacing: Spacing.space24) {
            Image(.checkmarkCircle)
            Text("You have uploaded your \(document.name)")
                .font(.vvSmallMedium)
                .foregroundStyle(Color.darkGray)
        }
        .frame(maxWidth: .infinity, minHeight: 214)
        .background(Color.init(hex: "#00ff38").opacity(0.1))
        .cornerRadius(8)
    }

    private var postVoyageSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Post voyage plans")
                    .font(.vvBody)
                Text("Details of your post voyage plans")
                    .font(.vvSmall)
                    .foregroundColor(Color.slateGray)
            }
            .tint(.primary)

            Spacer()
            Image(systemName: "arrow.right")
        }
    }

    private var informationSection: some View {
        VStack {
            Text("Important!")
                .font(.vvSmallBold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.slateGray)
            Text("Please remember to bring your documentation with you on the voyage")
                .font(.vvSmall)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.slateGray)
        }
        .padding(.vertical)
    }
}

extension DocumentReviewScreen {
    func rejectionView(message: String?) -> some View {
        VStack(alignment: .center, spacing: 24) {
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .frame(width: 64, height: 64, alignment: .center)
                .foregroundStyle(.white, .orange)

            Text(message ?? "There is an error with the document you uploaded. Tap to see details.")
                .multilineTextAlignment(.center)
                .fontStyle(.subheadline)
                .foregroundStyle(Color.orange)
        }
        .padding(34)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white, .orange)
        .background(Color.black.opacity(0.7))
        .cornerRadius(8)
    }
}


#Preview {
    DocumentReviewScreen()
}
