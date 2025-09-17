//
//  HomeItineraryDetailsSheet.swift
//  Virgin Voyages
//
//  Created by Pajtim on 3.4.25.
//

import Foundation

import SwiftUI
import VVUIKit

struct HomeItineraryDetailsSheet: View {
    @State var viewModel: HomeItineraryDetailsSheetViewModelProtocol
    @Environment(\.openURL) var openURL

    init(viewModel: HomeItineraryDetailsSheetViewModelProtocol = HomeItineraryDetailsSheetViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            VStack {
                VVUIKit.ContentView {
                    HStack {
                        Spacer()
                        XClosableButton {
                            viewModel.dismissSheet()
                        }
                    }
                    .padding(.top, Spacing.space24)
                    .padding([.trailing, .bottom], Spacing.space16)

                    VStack {
                        URLImage(url: URL(string: viewModel.homeItineraryDetails.imageUrl))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: Spacing.space4) {
                        Text(viewModel.homeItineraryDetails.ship)
                            .font(.vvSmall)
                            .kerning(1.4)
                            .foregroundColor(.darkGray)
                        
                        Text(viewModel.homeItineraryDetails.title)
                            .font(.vvHeading3Bold)
                        
                        Text(viewModel.homeItineraryDetails.date)
                            .font(.vvSmallMedium)
                            .kerning(1.4)
                            .foregroundColor(.vvRed)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, Spacing.space24)
					.padding(.horizontal, Spacing.space24)

                    VStack(alignment: .leading, spacing: Spacing.space12) {
                        HStack(alignment: .center, spacing: Spacing.space64) {
                            Text("DAY")
                                .font(.vvSmall)
                                .foregroundColor(.coolGray)
                            Text("PORT")
                                .font(.vvSmall)
                                .foregroundColor(.coolGray)
                        }
                        
                        ForEach(viewModel.homeItineraryDetails.itinerary, id: \.itineraryDay) { itinerary in
                            let isLast: Bool = itinerary == viewModel.homeItineraryDetails.itinerary.last ? true : false
                            itineraryRow(item: itinerary, isLastItem: isLast)
                        }
                    }
					.padding(.horizontal, Spacing.space24)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }  onRefresh: {
            viewModel.onAppear()
        }
        .onAppear {
            viewModel.onAppear()
        }
    }

    private func itineraryRow(item: HomeItineraryDetails.ItineraryItem, isLastItem: Bool) -> some View {
        HStack(alignment: .top, spacing: Spacing.space12) {

            VStack {
                Text(item.itineraryDay.description)
                    .font(.vvSmall)
                    .foregroundColor(.coolGray)
            }
            .frame(minWidth: 10)
            .padding(.trailing, Spacing.space24)

            // Timeline Indicator
            VStack(spacing: .zero) {
                iconView(for: item)
                if !isLastItem {
                    dashedLine
                        .frame(width: 2)
                        .frame(minHeight: 40)
                        .padding(.leading, Spacing.space2)
                }
            }

            // Destination Details
            VStack(alignment: .leading, spacing: Spacing.space8) {
                Text(item.name)
                    .font(.vvBodyBold)
                    .foregroundColor(.charcoalBlack)
                    .underline(item.link != nil, color: .charcoalBlack)
                    .onTapGesture {
                        if let link = item.link, let url = URL(string: link) {
                            openURL(url)
                        }
                    }
                if let time = item.time {
                    Text(time)
                        .font(.vvSmall)
                        .foregroundColor(.black)
                }
                if let info = item.info {
                    HTMLText(htmlString: info, fontType: .normal, fontSize: .size14, color: .coolGray)
                }
            }
            .padding(.leading, Spacing.space12)

            Spacer()
        }
        .padding(.top, Spacing.space4)
    }

    // Icon Mapping
    private func iconView(for item: HomeItineraryDetails.ItineraryItem) -> some View {
        let iconName: String
        switch item.icon {
        case .marker:
            iconName = "pinIcon"
        case .anchor:
            iconName = "anchorIcon"
        case .ship:
            iconName = "shipIcon"
        }

        return Image(iconName)
            .resizable()
            .frame(width: 21, height: 21)
            .foregroundColor(.vvPurple)
    }

    var dashedLine: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: 8))
                path.addLine(to: CGPoint(x: 0, y: geometry.size.height + Spacing.space10))
            }
            .stroke(style: StrokeStyle(lineWidth: 2, dash: [4, 4]))
            .foregroundColor(.deepPurple)
        }
    }
}

#Preview {
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            HomeItineraryDetailsSheet(
                viewModel: HomeItineraryDetailsSheetViewModel(
                    homeItineraryDetails: .sample()
                )
            )
        }
}
