//
//  MusterDrillHeaderView.swift
//  Virgin Voyages
//
//  Created by TX on 18.4.25.
//

import SwiftUI

public enum MusterDrillHeaderButtonMode {
    case none
    case chevronDown(() -> Void)
    case chevronUp(() -> Void)
    case close(() -> Void)
}

public struct MusterDrillHeaderView: View {
    let topInset: CGFloat
    let title: String
    let stationName: String
    let stationPlace: String
    let stationDeck: String
    let buttonMode: MusterDrillHeaderButtonMode

    public var body: some View {
        ZStack(alignment: .top) {
            Color.deepGreen
                .ignoresSafeArea(edges: .top)

            VStack(spacing: Spacing.space8) {
                Spacer().frame(height: topInset + 16)

                ZStack {
                    Text(title)
                        .font(.vvHeading5Bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)

                    HStack {
                        Spacer()
                        topRightButton
                            .padding(.trailing, Spacing.space24)
                    }
                }

                HStack(spacing: 0) {
                    VStack {
                        Image("MusterDrillPeople")
                            .resizable()
                            .frame(width: 73, height: 49)
                            .aspectRatio(contentMode: .fill)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()

                    Rectangle()
                        .frame(width: 1, height: 20)
                        .foregroundColor(.white)
                        .opacity(0.5)

                    VStack {
                        Text(stationName)
                            .font(.vvExtraHeadingMedium)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()

                    Rectangle()
                        .frame(width: 1, height: 20)
                        .foregroundColor(.white)
                        .opacity(0.5)

                    VStack {
                        Text(stationPlace)
                            .font(.vvSmallBold)
                            .foregroundColor(.white)
                        Text(stationDeck)
                            .font(.vvSmallMedium)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding()
                }
            }
        }
    }

    @ViewBuilder
    private var topRightButton: some View {
        switch buttonMode {
        case .none:
            EmptyView()
        case .chevronDown(let action):
            Button(action: action) {
                Image(systemName: "chevron.down")
                    .font(.vvBody)
                    .foregroundColor(.white)
            }
        case .chevronUp(let action):
            Button(action: action) {
                Image(systemName: "chevron.up")
                    .font(.vvBody)
                    .foregroundColor(.white)
            }
        case .close(let action):
            Button(action: action) {
                Image(systemName: "xmark")
                    .font(.vvBody)
                    .foregroundColor(.white)
            }
        }

    }
}
