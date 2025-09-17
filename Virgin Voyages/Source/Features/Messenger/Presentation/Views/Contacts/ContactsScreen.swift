//
//  ContactsScreen.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 27.10.24.
//

import SwiftUI
import VVUIKit

extension ContactsScreen {
    static func create(back: @escaping (() -> Void)) -> ContactsScreen {
        return ContactsScreen(viewModel: ContactsScreenViewModel(), back: back)
    }
}

struct ContactsScreen: View {
    
    // MARK: - Properties
    @State private var viewModel: ContactsScreenViewModelProtocol
    
    let back: (() -> Void)
    
    // MARK: - Init
    init(viewModel: ContactsScreenViewModelProtocol, back: @escaping (() -> Void)) {
        _viewModel = State(wrappedValue: viewModel)
        self.back = back
    }
   
    var body: some View {
        VirginScreenView(state: $viewModel.screenState) {
            VStack(spacing: Paddings.zero) {
                toolbar()
                    ScrollView(.vertical) {
                        VStack(alignment: .leading) {
                                                        
                            VStack {
                                Text(viewModel.contactsScreenModel.content.contactListText)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, Paddings.defaultVerticalPadding24)
                                    .fontStyle(.largeTitle)

                                CapsuleButton(
                                    title: "Add new sailor mate",
                                    image: Image("Add new"),
                                    accessoryImage: .init(systemName: "plus")) {
                                        viewModel.showAddAFriendSheet()
                                    }
                                
                                CapsuleButton(
                                    title: "View your QR code",
                                    image: Image("QRCodeCircle")) {
                                        viewModel.showMyQRCodeSheet()
                                    }
                            }
                            .padding(.horizontal, Paddings.defaultHorizontalPadding)
                            
                            contactListView()
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
            }
        } loadingView: {
            ProgressView(viewModel.contactsScreenModel.content.loadingText)
                .fontStyle(.headline)
        } errorView: {
            NoDataView {
                viewModel.onAppear()
            }
        }
        .sheet(item: $viewModel.appCoordinator.homeTabBarCoordinator.messengerCoordinator.sheetRouter.currentSheet, onDismiss: {
            viewModel.dismissSheetView()
        }, content: { sheetRoute in
            viewModel.destinationView(for: sheetRoute)
        })
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    // MARK: - View Builders
    private func contactSection(title: String, contactSectionType: ContactSectionType ,mates: [MessengerContactsModel.ContactItemModel], isSailorMate: Bool) -> some View {
        VStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontStyle(.headline)
                .padding(.vertical, Paddings.defaultVerticalPadding16)
            
            if !mates.isEmpty{
                mateView(mates: mates, isSailorMate: isSailorMate)
            } else {
                emptyStateView()
                    .padding(.horizontal, Paddings.defaultHorizontalPadding)
                    .padding(.vertical, Paddings.defaultVerticalPadding48)
            }
        }
    }
    
    private func mateView(mates: [MessengerContactsModel.ContactItemModel], isSailorMate: Bool) -> some View {
        VStack {
            ForEach(mates, id: \.name) { mate in
                VStack {
                    HStack(spacing: Paddings.defaultVerticalPadding) {
                        AuthURLImageView(imageUrl: mate.photoUrl, size: Sizes.defaultSize32, clipShape: .circle, defaultImage: "ProfilePlaceholder")
                        Text(mate.name)
                            .fontStyle(.smallBody)
                        Spacer()
                    }
                    .onTapGesture {
                        viewModel.onClick(sailorMate: mate, isSailorMate: isSailorMate)
                    }
                    Divider()
                }
            }
        }
    }
    
    private func contactListView() -> some View {
        VStack(spacing: Paddings.zero) {
            
            VStack {
                
                if !viewModel.contactsScreenModel.cabinMates.isEmpty {
                    contactSection(
                        title: viewModel.contactsScreenModel.content.cabinmatesText, contactSectionType: .cabinMate,
                        mates: viewModel.contactsScreenModel.cabinMates,
                        isSailorMate: false
                    )
                }
                
                contactSection(
                    title: viewModel.contactsScreenModel.content.sailorMatesText, contactSectionType: .sailior,
                    mates: viewModel.contactsScreenModel.salorMates,
                    isSailorMate: true
                )
                
                if !viewModel.contactsScreenModel.directory.isEmpty {
                    contactSection(
                        title: viewModel.contactsScreenModel.content.directoryText, contactSectionType: .directory,
                        mates: viewModel.contactsScreenModel.directory,
                        isSailorMate: false
                    )
                    .padding(.bottom)
                }
            }
            .padding(.horizontal, Paddings.defaultHorizontalPadding)
            
            Spacer()
        }
    }
    
    private func emptyStateView() -> some View {
        VStack {
            Image("MessengerEmptyState")
                .frame(width: Sizes.defaultSize64, height: Sizes.defaultSize64)
                .padding(.bottom, Paddings.defaultVerticalPadding16)
            Text(viewModel.contactsScreenModel.content.noSailorsText)
                .multilineTextAlignment(.center)
                .fontStyle(.smallBody)
                .foregroundStyle(Color.gray)
                
        }
    }
    
    private func toolbar() -> some View {
        Toolbar(buttonStyle: .backButton) {
            back()
        }
    }
}

enum ContactSectionType {
    case sailior
    case cabinMate
    case directory
}


#Preview {
    ContactsScreen.create(back: {})
}

