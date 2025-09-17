//
//  BoardingPassCardView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/3/25.
//

import SwiftUI
import VVUIKit
import PassKit

struct BoardingPassCardView: View {
    
    @Environment(\.openURL) var openURL
    @State private var isLoading = false
    
    let item: SailorBoardingPass.BoardingPassItem
    
    @State private var viewModel: BoardingPassCardViewModelProtocol
    
    init(item: SailorBoardingPass.BoardingPassItem,
         viewModel: BoardingPassCardViewModelProtocol = BoardingPassCardViewModel()) {
        
        self.item = item
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: Spacing.space0, content: {
            
            if viewModel.isStandartSailor(item: item) {
                
                TicketStubSection(position: .top,
                                  backgroundColor: viewModel.getSailorTypeBackgroundColor(item: item),
                                  paddingTop: Spacing.space24,
                                  paddingBottom: Spacing.space16) {
                    
                    voyageInfo(boardingPass: item)
                    
                }
                
                TicketStubTearOffSection(foregroundColor: viewModel.getSailorTypeBackgroundColor(item: item))
                
            } else {
                
                TicketStubSection(position: .top,
                                  backgroundColor: viewModel.getSailorTypeBackgroundColor(item: item)) {
                    
                    
                    receiptHeaderView(boardingPass: item)
                    
                }
                
                TicketStubTearOffSection(foregroundColor: viewModel.getSailorTypeBackgroundColor(item: item))
                
                TicketStubSection(position: .middle,
                                  backgroundColor: viewModel.getSailorTypeBackgroundColor(item: item),
                                  paddingTop: Spacing.space16,
                                  paddingBottom: Spacing.space16) {
                    
                    voyageInfo(boardingPass: item)
                    
                }
                
                TicketStubTearOffSection(foregroundColor: viewModel.getSailorTypeBackgroundColor(item: item))
                
            }
            
            TicketStubSection(position: .middle,
                              backgroundColor: viewModel.getSailorTypeBackgroundColor(item: item)) {
                
                sailorInfo(boardingPass: item)
            }
            
            TicketStubSection(position: .middle) {
                
                additionalSailorInfo(boardingPass: item)
            }
            
            TicketStubTearOffSection()
            
            TicketStubSection(position: .bottom,
                              paddingTop: Spacing.space16,
                              paddingBottom: Spacing.space0) {
                
                receiptFooterView()
            }
            
        })
        .task {
            await viewModel.getBoardingPassAppleWalletData(reservationGuestId: item.reservationGuestId)
        }
        .sheet(isPresented: $viewModel.isPassSheetVisible) {
            if let pass = viewModel.pass {
                AddBoardingPassToWalletView(pass: pass)
            }
        }
        .fullScreenCover(isPresented: $viewModel.didFailedGeneratingPass) {
            
            VVSheetModal(title: "Boarding Pass can not be added on Apple Wallet at the moment! Please try again latter.",
                         primaryButtonText: "OK",
                         primaryButtonAction: {
                viewModel.didFailedGeneratingPass = false
            }, dismiss: {
                viewModel.didFailedGeneratingPass = false
            })
            .background(Color.clear)
            .transition(.opacity)
            
        }
        .shadow(color: .black.opacity(0.07), radius: 24, x: 0, y: 8)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
        
    }
    
    private func receiptHeaderView(boardingPass: SailorBoardingPass.BoardingPassItem) -> some View {
        
        VStack(spacing: .zero) {
            if let url = URL(string: boardingPass.imageUrl) {
                DynamicSVGImageLoader(url: url, isLoading: $isLoading)
                    .frame(height: 69)
                    .frame(maxWidth: .infinity)
            }
            
            Text(boardingPass.sailorTitle)
                .foregroundStyle(Color.vvWhite)
                .font(.vvBodyBold)
                .frame(maxWidth: .infinity, alignment: .center)
                
        }
        
    }
	
    private func voyageInfo(boardingPass: SailorBoardingPass.BoardingPassItem) -> some View {
        
        VStack(alignment: .leading, spacing: Spacing.space16) {
            
            VStack(alignment: .leading, spacing: Spacing.space4) {
                Text(boardingPass.shipName)
                    .foregroundStyle(Color.vvWhite)
                    .font(.vvSmall)
                
                Text(boardingPass.voyageName)
                    .foregroundStyle(Color.vvWhite)
                    .font(.vvBodyBold)
            }
            
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: Spacing.space2) {
                    Text("Depart")
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvSmall)
                    
                    Text(boardingPass.depart)
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvHeading1)
                }
                
                Spacer()
                
                VectorImage(name: "Anchor")
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.white)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: Spacing.space2) {
                    Text("Arrive")
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvSmall)
                    
                    Text(boardingPass.arrive)
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvHeading1)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        
    }
    
    private func sailorInfo(boardingPass: SailorBoardingPass.BoardingPassItem) -> some View {
        
        VStack(spacing: Spacing.space24) {
            
            HStack(alignment: .top, spacing: Spacing.space16) {
                VStack(alignment: .leading, spacing: Spacing.space4) {
                    Text("Sailor")
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvSmall)
                    
                    Text(boardingPass.sailor)
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvBodyBold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: Spacing.space4) {
                    Text("Booking ref")
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvSmall)
                    
                    Text(boardingPass.bookingRef)
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvBodyBold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack(alignment: .top, spacing: Spacing.space16) {
                VStack(alignment: .leading, spacing: Spacing.space4) {
                    Text("Arrival time")
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvSmall)
                    
                    Text(boardingPass.arrivalTime)
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvBodyBold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: Spacing.space4) {
                    Text("Cabin number")
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvSmall)
                    
                    Text(boardingPass.cabinNumber)
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvBodyBold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(alignment: .leading, spacing: Spacing.space4) {
                Text("Embarkation")
                    .foregroundStyle(Color.vvWhite)
                    .font(.vvSmall)
                
                Text(boardingPass.embarkation)
                    .foregroundStyle(Color.vvWhite)
                    .font(.vvBodyBold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
    }
    
    private func additionalSailorInfo(boardingPass: SailorBoardingPass.BoardingPassItem) -> some View {
        
        VStack(alignment: .leading, spacing: Spacing.space24) {
            
            VStack(alignment: .leading, spacing: Spacing.space4) {
                
                Text("Port location")
                    .foregroundStyle(Color.darkGray)
                    .font(.vvSmallBold)
                
				if !item.coordinates.isEmpty {
					Button {
                        guard let url = viewModel.getLocationURL(coordinates: item.coordinates, placeId: item.placeId) else { return }
						openURL(url)
						
					} label: {
						Text(boardingPass.portLocation)
							.foregroundStyle(Color.darkGray)
							.font(.vvSmall)
							.underline(true, pattern: .solid)
							.lineLimit(1)
					}
				} else {
					Text(boardingPass.portLocation)
						.foregroundStyle(Color.darkGray)
						.font(.vvSmall)
						.lineLimit(1)
				}
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: Spacing.space4) {
                Text("Sail time")
                    .foregroundStyle(Color.darkGray)
                    .font(.vvSmallBold)
                
                Text(boardingPass.sailTime)
                    .foregroundStyle(Color.darkGray)
                    .font(.vvSmall)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(alignment: .top, spacing: Spacing.space16) {
                VStack(alignment: .leading, spacing: Spacing.space4) {
                    Text("Cabin")
                        .foregroundStyle(Color.darkGray)
                        .font(.vvSmallBold)
                    
                    Text(boardingPass.cabin)
                        .foregroundStyle(Color.darkGray)
                        .font(.vvSmall)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: Spacing.space4) {
                    Text("Muster station")
                        .foregroundStyle(Color.darkGray)
                        .font(.vvSmallBold)
                    
                    Text(boardingPass.musterStation)
                        .foregroundStyle(Color.darkGray)
                        .font(.vvSmall)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        }
        
    }
    
    private func receiptFooterView() -> some View {
        
        VStack(alignment: .center, spacing: Spacing.space24){
            
            VVQRCodeView(
                viewModel: VVQRCodeViewModel(
                    input: viewModel.generateQRBoardingPassString(item: item),
                    profileImage: nil
                ),
                frameWidth: 140,
                frameHeight: 140,
                qrCodeImage: { (qr, deepLink) in }
            )
            .padding(Spacing.space16)
            .frame(maxWidth: .infinity, alignment: .center)
            
            AddPassToWalletButton {
                viewModel.handleWalletButtonAction()
            }
            .cornerRadius(10, corners: .allCorners)
            
        }
        .padding(.bottom, Spacing.space16)
        
    }
    
}


#Preview("Boarding Pass") {
    ScrollView(.vertical, showsIndicators: false){
        BoardingPassCardView(item: SailorBoardingPass.sample().items[0])
            .padding(24)
    }
}

#Preview("Boarding Pass without coordinates") {
	ScrollView(.vertical, showsIndicators: false){
		BoardingPassCardView(item: SailorBoardingPass.BoardingPassItem.sample().copy(coordinates: ""))
			.padding(24)
	}
}
