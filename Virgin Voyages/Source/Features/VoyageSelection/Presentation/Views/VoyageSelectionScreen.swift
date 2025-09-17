//
//  VoyageSelectionScreen.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 2.6.25.
//

import SwiftUI
import VVUIKit

protocol VoyageSelectionScreenViewModelProtocol {
    var screenState: ScreenState { get set }
    var voyageReservations: VoyageReservations { get set }
    var archivedVoyageReservations: [VoyageReservations.GuestBooking] { get }
   
    func onAppear()
    func didTapLogout()
    func didTapClamABooking()
    func didTapAnotherVoyage()
    func didTapScheduleVoyage()
    func reloadReservation(reservationNumber: String)
    func isActiveReservation(voyage: VoyageReservations.GuestBooking) -> Bool
}

struct VoyageSelectionScreen: View {
    
    @State private var viewModel: VoyageSelectionScreenViewModelProtocol
    private let onBackClick: VoidCallback?
    
    // MARK: - Init
    init(
        viewModel: VoyageSelectionScreenViewModelProtocol,
        onBackClick: @escaping VoidCallback
    ) {
        _viewModel = State(wrappedValue: viewModel)
        self.onBackClick = onBackClick
    }
    
    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            VStack(spacing: .zero) {
                toolbar()
                ScrollView {
                    headerView()
                    voyageCardsView()
                    //This will be temporarily disabled until the backend provides data for this view
                    //MyNextVoyageView(voyageReservations: viewModel.voyageReservations, action: {
                    //    viewModel.didTapScheduleVoyage()
                    //})
                    if !viewModel.archivedVoyageReservations.isEmpty {
                        sectionDivider()
                        archivedVoyageCardsView()
                    }
                    sectionDivider()
                    bottomButtonsView()
                }
            }
        } onRefresh: {}
        .onAppear() { viewModel.onAppear()}
    }
    
    private func toolbar() -> some View {
        HStack(alignment: .top) {
            BackButton({onBackClick?()})
                .padding(.leading, Spacing.space24)
                .padding(.top, Spacing.space32)
                .opacity(0.8)

            Spacer()
            
            logoutView()
        }
    }
    
    private func logoutView() -> some View {
        HStack(spacing: .zero) {
                Button {
                    viewModel.didTapLogout()
                } label: {
                    Text("Log out")
                        .fontStyle(.smallButton)
                        .foregroundColor(.darkGray)
                }
                .padding(.trailing, Spacing.space10)
                if let sailorPhotoURL = URL(string: viewModel.voyageReservations.profilePhotoURL) {
                    AuthURLImageView(imageUrl: sailorPhotoURL.absoluteString, size: Sizes.defaultSize64, clipShape: .circle, defaultImage: "ProfilePlaceholder")
                } else {
                    CircularImageView(image: .profilePlaceholder, size: Sizes.defaultSize64)
                }
            }
            .padding(.top, Paddings.defaultVerticalPadding32)
            .padding(.trailing, Paddings.defaultVerticalPadding32)
        }
    
    private func headerView() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space8) {
            Text(viewModel.voyageReservations.pageDetails.title)
                .font(.vvHeading1Bold)
                .foregroundColor(Color.blackText)
            Text(viewModel.voyageReservations.pageDetails.description)
                .font(.vvHeading5)
                .foregroundColor(Color.slateGray)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, Paddings.defaultVerticalPadding24)
        .padding(.top, Paddings.defaultVerticalPadding32)
        .padding(.bottom, Paddings.defaultVerticalPadding16)
    }
    
    private func voyageImageView(voyage: VoyageReservations.GuestBooking) -> some View {
        let isActiveReservation = viewModel.isActiveReservation(voyage: voyage)
        return ZStack {
            Circle()
                .stroke(isActiveReservation ? Color.lightGreen : Color.iconGray, lineWidth: 4)
                .frame(width: Sizes.preVoyageEditingStopped, height: Sizes.preVoyageEditingStopped)

            AuthURLImageView(imageUrl: voyage.imageUrl, size: Sizes.preVoyageEditingStopped - Spacing.space8, clipShape: .circle, defaultImage: "ProfilePlaceholder")

            if isActiveReservation {
                Image("Success")
                    .frame(width: Sizes.defaultSize40, height: Sizes.defaultSize40)
                    .background(Circle().fill(Color.lightGreen))
                    .offset(x: Sizes.preVoyageEditingStopped / 2 - Spacing.space32, y: -Sizes.preVoyageEditingStopped / 2 + Spacing.space32)
            }
        }
    }
    
    private func voyageCardsView() -> some View {
        ForEach(viewModel.voyageReservations.sortedBookings(), id: \.reservationId) { voyage in
            VStack(spacing: .zero) {
                Button {
                    viewModel.reloadReservation(reservationNumber: voyage.reservationNumber)
                } label: {
                    MultiTicketLabel(spacing: Paddings.defaultHorizontalPadding, backgroundColor: Color.borderGray) {
                        voyageImageView(voyage: voyage)
                            .padding(Spacing.space40)
                    } label: {
                        VStack(alignment: .leading, spacing: Spacing.space8) {
                            Text(voyage.voyageName)
                                .font(.vvHeading4Medium)
                                .foregroundColor(Color.blackText)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text((voyage.portNames.compactMap { $0 }).joined(separator: " • "))
                                .font(.vvSmallMedium)
                                .foregroundColor(Color.vvRed)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(Paddings.defaultVerticalPadding24)
                    } footer: {
                        HStack {
                            Text(voyage.shipName.uppercased())
                                .font(.vvSmallMedium)
                                .foregroundColor(Color.slateGray)
                                .kerning(1.4)
                            
                            Spacer()
                            
                            Text(voyage.voyageDate.uppercased())
                                .font(.vvSmallMedium)
                                .foregroundColor(Color.slateGray)
                                .kerning(1.4)
                        }
                        .padding(.horizontal, Paddings.defaultVerticalPadding24)
                        .padding(.top, Paddings.defaultVerticalPadding16)
                        .padding(.bottom, Paddings.defaultVerticalPadding24)
                    }
                }
            }
            .padding(.horizontal, Paddings.defaultVerticalPadding24)
            .padding(.bottom, Paddings.defaultVerticalPadding16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 1)
            .shadow(color: Color.black.opacity(0.07), radius: 48, x: 0, y: 8)
        }
    }
    
    private func archivedVoyageCardsView() -> some View {
        ForEach(viewModel.archivedVoyageReservations, id: \.reservationId) { voyage in
            VStack(spacing: .zero) {
                MultiTicketLabel(spacing: Paddings.defaultHorizontalPadding, backgroundColor: Color.borderGray) {
                    Text(viewModel.voyageReservations.pageDetails.labels.archived.uppercased())
                        .font(.vvSmallMedium)
                        .foregroundColor(Color.deepIndigo)
                        .kerning(1.4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Paddings.defaultVerticalPadding24)
                        .padding(.top, Paddings.defaultVerticalPadding24)
                        .padding(.bottom, Paddings.defaultVerticalPadding16)
                } label: {
                    VStack(alignment: .leading, spacing: Spacing.space8) {
                        Text(voyage.voyageName)
                            .font(.vvHeading4Medium)
                            .foregroundColor(Color.blackText)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text((voyage.portNames.compactMap { $0 }).joined(separator: " • "))
                            .font(.vvSmallMedium)
                            .foregroundColor(Color.vvRed)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(Paddings.defaultVerticalPadding24)
                } footer: {
                    HStack {
                        Text(voyage.shipName.uppercased())
                            .font(.vvSmallMedium)
                            .foregroundColor(Color.slateGray)
                            .kerning(1.4)
                        
                        Spacer()
                        
                        Text(voyage.voyageDate.uppercased())
                            .font(.vvSmallMedium)
                            .foregroundColor(Color.slateGray)
                            .kerning(1.4)
                    }
                    .padding(.horizontal, Paddings.defaultVerticalPadding24)
                    .padding(.top, Paddings.defaultVerticalPadding16)
                    .padding(.bottom, Paddings.defaultVerticalPadding24)
                }
            }
            .padding(.horizontal, Paddings.defaultVerticalPadding24)
            .padding(.vertical, Paddings.defaultVerticalPadding16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 1)
            .shadow(color: Color.black.opacity(0.07), radius: 48, x: 0, y: 8)
        }
    }
    
    private func sectionDivider() -> some View {
        VStack(spacing: Spacing.space4) {
            Rectangle()
                .fill(Color.lightMist)
                .frame(height: Spacing.space4)

            Rectangle()
                .fill(Color.lightMist)
                .frame(height: Spacing.space4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Paddings.defaultVerticalPadding16)
        .background(Color.white)
    }
    
    private func bottomButtonsView() -> some View {
        VStack(spacing: Paddings.defaultPadding8) {
            VStack(spacing: Paddings.defaultVerticalPadding16) {
                    Button("Claim a booking") {
                        viewModel.didTapClamABooking()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button("Book another voyage") {
                        viewModel.didTapAnotherVoyage()
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                .padding([.horizontal, .bottom], Paddings.defaultVerticalPadding24)
                .padding(.top, Spacing.space8)
            }
        .padding(.bottom, Paddings.defaultVerticalPadding16)
    }
}

struct VoyageSelectionScreenPreviewViewModel: VoyageSelectionScreenViewModelProtocol {
    var screenState: ScreenState = .content
    var voyageReservations: VoyageReservations = .sample()
    var archivedVoyageReservations: [VoyageReservations.GuestBooking] = []
    
    func onAppear() {}
    func didTapLogout() {}
    func didTapClamABooking() {}
    func didTapAnotherVoyage() {}
    func didTapScheduleVoyage() {}
    func reloadReservation(reservationNumber: String) {}
    func isActiveReservation(voyage: VoyageReservations.GuestBooking) -> Bool {
        return false
    }
}

// MARK: - Preview

#Preview {
    VoyageSelectionScreen(viewModel: VoyageSelectionScreenPreviewViewModel(), onBackClick: {})
}
