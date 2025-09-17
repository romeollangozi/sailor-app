//
//  HomeEmbarkationReceiptView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/26/25.
//

import SwiftUI
import VVUIKit

struct HomeEmbarkationReceiptView: View {
    
    @Environment(\.openURL) var openURL
    
    @State private var isLoading = false
    
    @State var viewModel: HomeCheckInViewModelProtocol
    
    init(viewModel: HomeCheckInViewModelProtocol) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        VStack(spacing: Spacing.space0) {
            
            if viewModel.isStandardSailorType {
                
                TicketStubSection(position: .top,
                                  backgroundColor: viewModel.sailorTypeBackgroundColor,
                                  paddingTop: Spacing.space32,
                                  paddingBottom: Spacing.space4) {
                    
                    if let embarkationDetail = viewModel.section.embarkation.details {
                        receiptStandardHeaderView(embarkationDetail: embarkationDetail)
                    }
                }
                
            } else {
                
                TicketStubSection(position: .top,
                                  backgroundColor: viewModel.sailorTypeBackgroundColor) {
                    
                    if let embarkationDetail = viewModel.section.embarkation.details {
                        receiptHeaderView(embarkationDetail: embarkationDetail)
                    }
                }
                
                TicketStubTearOffSection(foregroundColor: viewModel.sailorTypeBackgroundColor)
            }
            
            TicketStubSection(position: .middle, backgroundColor: viewModel.sailorTypeBackgroundColor) {
                
                if let embarkationDetail = viewModel.section.embarkation.details {
                    receiptDataView(embarkationDetail: embarkationDetail)
                }
            }
            
            TicketStubTearOffSection(foregroundColor: viewModel.sailorTypeBackgroundColor)
            
            TicketStubSection(position: .bottom, backgroundColor: viewModel.sailorTypeBackgroundColor) {
                receiptFooterView()
            }
            
        }
        
    }
    
    private func receiptHeaderView(embarkationDetail: HomeCheckInSection.EmbarkationSection.EmbarkationDetailsSection) -> some View {
        
        VStack(spacing: .zero) {
            if let url = URL(string: embarkationDetail.imageUrl) {
                DynamicSVGImageLoader(url: url, isLoading: $isLoading)
                    .frame(height: 69)
                    .frame(maxWidth: .infinity)
            }
            
            Text(embarkationDetail.title)
                .foregroundStyle(Color.vvWhite)
                .font(.vvBodyBold)
                .frame(maxWidth: .infinity, alignment: .center)
                
        }
        
    }
    
    private func receiptStandardHeaderView(embarkationDetail: HomeCheckInSection.EmbarkationSection.EmbarkationDetailsSection) -> some View {
        Text(embarkationDetail.title)
            .foregroundStyle(Color.vvWhite)
            .font(.vvHeading4Bold)
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    private func receiptDataView(embarkationDetail: HomeCheckInSection.EmbarkationSection.EmbarkationDetailsSection) -> some View {
        
        VStack(spacing: Spacing.space32) {
            
            HStack(alignment: .top, spacing: Spacing.space16) {
                
                VStack(alignment: .leading, spacing: Spacing.space4) {
                    
                    Text("Arrival slot")
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvSmall)
                    
                    Text(embarkationDetail.arrivalSlot)
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvBodyBold)
                }
                
                VStack(alignment: .leading, spacing: Spacing.space4) {
                    
                    Text("Location")
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvSmall)
                    
					if !embarkationDetail.coordinates.isEmpty {
						Button {
							guard let url = viewModel.getLocationURL() else { return }
							openURL(url)
							
						} label: {
							Text(embarkationDetail.location)
								.foregroundStyle(Color.vvWhite)
								.font(.vvBodyBold)
								.underline(true, pattern: .solid)
								.lineLimit(1)
								.frame(maxWidth: .infinity, alignment: .topLeading)
						}
					} else {
						Text(embarkationDetail.location)
							.foregroundStyle(Color.vvWhite)
							.font(.vvBodyBold)
							.lineLimit(1)
							.frame(maxWidth: .infinity, alignment: .topLeading)
					}
                }
            }
            
            VStack(alignment: .leading, spacing: Spacing.space4) {
                
                Text("Your cabin")
                    .foregroundStyle(Color.vvWhite)
                    .font(.vvSmall)
                
                Text(embarkationDetail.cabinType)
                    .foregroundStyle(Color.vvWhite)
                    .font(.vvBodyBold)
                
                Text(embarkationDetail.cabinDetails)
                    .foregroundStyle(Color.vvWhite)
                    .font(.vvSmall)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
        }
        
    }
    
    private func receiptFooterView() -> some View {
        VStack {
            
            if viewModel.section.embarkation.status == .completed && viewModel.section.healthCheck.status == .completed {
                Button {
                    viewModel.didTapViewBoardingPass()
                } label: {
                    Text("View Boarding pass")
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvBodyMedium)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .cornerRadius(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .inset(by: 0.5)
                                .stroke(.white, lineWidth: 1)
                        )
                }
            } else {
                Text("Complete check-in to view Boarding pass")
                    .foregroundStyle(Color.vvWhite)
                    .font(.vvSmall)
                    .multilineTextAlignment(.center)
            }
            
        }
        .frame(maxWidth: .infinity)
    }
    
}

#Preview("Embarkation receipt") {
    ScrollView {
        HomeEmbarkationReceiptView(viewModel: HomeCheckInViewModel.mockViewModel(healthCheckStatus: .opened))
    }
}

#Preview("Embarkation receipt without coordinates") {
	ScrollView {
		HomeEmbarkationReceiptView(viewModel: HomeCheckInViewModel.mockViewModel(healthCheckStatus: .opened, coordinates: ""))
	}
}
