//
//  HomeHeaderView.swift
//  Virgin Voyages
//
//  Created by TX on 12.3.25.
//

import SwiftUI
import VVUIKit


protocol HomeHeaderLabelsProtocol {
    var shipTimeTooltipHeader: String { get }
    var shipTimeTooltipDescription: String { get }
}

protocol HomeHeaderViewModelProtocol {
    var header: HomeHeader { get }
    var sailingMode: SailingMode { get }
    var shouldShowTextContentInHeader: Bool { get }
    var shouldShowShipInfo: Bool { get }
    var shouldShowGangwayInShipInfo: Bool { get }
    var shouldShowGangwayOpenInShipInfo: Bool { get }
    var shouldShowGangwayCloseInShipInfo: Bool { get }
    var shouldShowSingleActionButton: Bool { get }
    var shouldShowActionButtons: Bool { get }
    var shouldShowMessengerButtonInHeader: Bool { get }
    var shouldShowFooterText: Bool { get }
    var shipTime: String { get set }
    var gangwayOpeningTime: String { get }
    var gangwayClosingTime: String { get }
    var shouldShowShipTimeTooltip: Bool { get set }

    
    func calculateShipTime()
    func didTapMessengerButton()
    func didTapBookingRefButton()
    func didTapCabinNumberButton()
    func didTapItineraryButton()
    func didTapShipTimeTooltip()
    func shipTimeTooltipCloseButtonTapped()
    
    var labels: HomeHeaderLabelsProtocol { get }
}

struct HomeHeaderView: View {
    @State private var viewModel: HomeHeaderViewModelProtocol
    @State private var topSafeAreaSize: CGFloat = 0.0
    @State private var tootlipSheetHeight: CGFloat = 0.0

    var enlargeViewBy: CGFloat
    var contentOpacity: CGFloat
    
    init(viewModel: HomeHeaderViewModelProtocol,
         enlargeViewBy: CGFloat,
         contentOpacity: CGFloat) {
        
        _viewModel = .init(wrappedValue: viewModel)
        self.enlargeViewBy = enlargeViewBy
        self.contentOpacity = contentOpacity
    }
    
    var body: some View {
        VStack(spacing: .zero) {
        
            VStack(spacing: .zero) {
                headerContent
                
                voyageDetails
                
                if viewModel.shouldShowShipInfo {
                    shipInfo
                }
                
                if viewModel.shouldShowSingleActionButton {
                    singleActionButton
                }
                
                if viewModel.shouldShowActionButtons {
                    actionButtons
                }
                
                if viewModel.shouldShowFooterText {
                    footerText
                }
            }
            .opacity(contentOpacity)
        }
        .sheet(isPresented: $viewModel.shouldShowShipTimeTooltip, content: {
            shipTooltip
                .onGeometryChange(for: CGSize.self) { proxy in
                    proxy.size
                } action: { size in
                    self.tootlipSheetHeight = size.height
                }
                .presentationDetents([.height(tootlipSheetHeight)])

        })
        .onAppear {
            viewModel.calculateShipTime()
        }
        .padding(Paddings.defaultVerticalPadding16)
        .background(safeAreaInsetView)
        .background(headerBackground)
        .frame(maxWidth: .infinity)
    }
    
    private var headerContent: some View {
        HStack {
            if viewModel.shouldShowTextContentInHeader {
                VStack(alignment: .leading) {
                    Text(viewModel.header.topBarTitle)
                        .font(.vvBodyMedium)
                        .foregroundColor(.white)
                    
                    Text(viewModel.header.topBarSubtitle)
                        .font(.vvBodyMedium)
                        .foregroundColor(.white)
                }
            }
            Spacer()
            if viewModel.shouldShowMessengerButtonInHeader {
                MessengerButtonView(buttonAction: viewModel.didTapMessengerButton)
            }
        }
        .padding(.top, topSafeAreaSize)
    }
    
    private var voyageDetails: some View {
        VStack(spacing: Paddings.padding12) {
            Text(viewModel.header.headerTitle)
                .font(.vvBodyMedium)
                .foregroundColor(.white)
            
            Text(viewModel.header.headerSubtitle.uppercased())
                .font(.vvVoyagesLargeMedium)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, Paddings.defaultVerticalPadding48)
    }
    
    private var shipInfo: some View {
        VStack(spacing: 4) {
            HStack(alignment: .center, spacing: 8) {
                Text("Shiptime ")
                    .font(.vvBody)
                    .foregroundColor(.white) +
                Text(viewModel.shipTime)
                    .font(.vvBodyBold)
                    .foregroundColor(.white)
                
                Button(action: {
                    viewModel.didTapShipTimeTooltip()
                }) {
                    Image(systemName: "info.circle.fill")
                        .resizable()
                        .frame(width: 13, height: 13)
                        .foregroundColor(.white)
                }
            }
            // These labels will be temporarily commented out and removed from the UI, as the backend work is not yet ready and will take some time to complete
//            if viewModel.shouldShowGangwayInShipInfo {
//                HStack {
//                    if viewModel.shouldShowGangwayOpenInShipInfo {
//                        Text("Gangway open ")
//                            .font(.vvSmall)
//                            .foregroundColor(.white) +
//                        Text(viewModel.gangwayOpeningTime)
//                            .font(.vvSmallBold)
//                            .foregroundColor(.white)
//                    }
//                    if viewModel.shouldShowGangwayCloseInShipInfo {
//                        Text("•  Gangway close ")
//                            .font(.vvSmall)
//                            .foregroundColor(.white) +
//                        Text(viewModel.gangwayClosingTime)
//                            .font(.vvSmallBold)
//                            .foregroundColor(.white)
//                    }
//                }
//            }
        }
        .padding(.vertical, Paddings.defaultVerticalPadding16)
    }
    
    private func actionButton(title: String, boldText: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.vvSmallBold)
                if let boldText = boldText {
                    Text(boldText)
                        .font(.vvSmall)
                }
            }
            .foregroundColor(.white)
            .padding(Paddings.defaultPadding8)
            .padding(.horizontal, Paddings.defaultVerticalPadding16)
            .background(Color.black.opacity(0.7))
            .clipShape(Capsule())
        }
    }
    
    private var singleActionButton: some View {
        actionButton(title: "Your cabin", boldText: viewModel.header.cabinNumber, action: viewModel.didTapCabinNumberButton)
            .padding(.bottom, Paddings.defaultVerticalPadding48)
    }

    private var actionButtons: some View {
        HStack(spacing: Paddings.defaultVerticalPadding16) {
            actionButton(title: "Booking ref", boldText: viewModel.header.reservationNumber, action: viewModel.didTapBookingRefButton)
            actionButton(title: "View itinerary", action: viewModel.didTapItineraryButton)
        }
        .padding(.vertical, Paddings.defaultVerticalPadding48)
    }
    
    private var footerText: some View {
        VStack {
            Text("’Til we sail again… Bon Voyage")
                .font(.vvBody)
        }
        .foregroundColor(.white)
        .padding(.top, Paddings.defaultVerticalPadding16)
        .padding(.bottom, Paddings.defaultVerticalPadding48)
    }
    
    private var headerBackground: some View {
        AuthURLImageView(imageUrl: viewModel.header.backgroundImageUrl)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(gradientOverlay)
            .ignoresSafeArea(edges: .top)
    }
    
    private var gradientOverlay: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 30/255, green: 41/255, blue: 64/255, opacity: 0.30), 
                    Color(red: 30/255, green: 41/255, blue: 64/255, opacity: 0.00), 
                    Color(red: 30/255, green: 41/255, blue: 64/255, opacity: 0.60)  
                ]),
                startPoint: .top,
                endPoint: .bottom
            )

            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.30),
                    Color.black.opacity(0.40)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    private var safeAreaInsetView: some View {
        Color.clear
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 0)
                    .onAppear {
                        DispatchQueue.main.async {
                            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = scene.windows.first {
                                topSafeAreaSize = window.safeAreaInsets.top
                            }
                        }
                    }
            }
    }
        
    private var shipTooltip: some View {
        VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding24) {
            XClosableButton {
                viewModel.shipTimeTooltipCloseButtonTapped()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

            Text(viewModel.labels.shipTimeTooltipHeader)
                .font(.vvHeading2Medium)

            Text(viewModel.labels.shipTimeTooltipDescription)
            .font(.vvBody)
            .foregroundColor(.vvGray)
        }
        .padding(Paddings.defaultVerticalPadding24)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    VStack {
        let previewViewModel = HomeHeaderViewModel(header: .sample(), sailingMode: .preCruise)
        HomeHeaderView(viewModel: previewViewModel, enlargeViewBy: 0.0, contentOpacity: 1.0)
        Spacer()
    }
}
