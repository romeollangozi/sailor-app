//
//  MeAddonsView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 7.3.25.
//

import SwiftUI
import VVUIKit

struct MeAddonsView: View {

	private var myVoyageAddons: MyVoyageAddOns
	private var myVoyageHeader: MyVoyageHeaderModel
    private var sailingMode: SailingMode
    private let navigateToAddons: () -> Void
	private let navigateToAddonsReceipt: (String) -> Void

    init(
        myVoyageAddons: MyVoyageAddOns,
        myVoyageHeader: MyVoyageHeaderModel,
        sailingMode: SailingMode,
        navigateToAddons: @escaping () -> Void,
        navigateToAddonsReceipt: @escaping (String) -> Void
    ) {
		self.myVoyageAddons = myVoyageAddons
		self.myVoyageHeader = myVoyageHeader
        self.sailingMode = sailingMode
        self.navigateToAddons = navigateToAddons
		self.navigateToAddonsReceipt = navigateToAddonsReceipt
	}

	var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
			switch myVoyageAddons.addOns.isEmpty  {
			case true:
				MeEmptyStateView(
					imageUrl: myVoyageAddons.emptyStatePictogramUrl,
					message: myVoyageAddons.emptyStateText,
					buttonTitle: myVoyageHeader.buttonAddonsTitle,
                    showButton: myVoyageAddons.addOns.isEmpty && sailingMode == .preCruise,
                    action: navigateToAddons)
			case false:
				addonListView(addOns: myVoyageAddons.addOns)
			}
			Spacer()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.softGray)
	}

	private func addonListView(addOns: [MyVoyageAddOns.Addon]) -> some View {
        return VStack {
            Text(myVoyageAddons.title)
				.font(.vvBody)
				.foregroundColor(.slateGray)
				.multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.space16)
                .padding(.top, Spacing.space32)
                .padding(.bottom, Spacing.space16)

			ForEach(addOns, id: \.uuid) { addon in
				Card(
					title: addon.name,
					titleFont: .vvHeading4Bold,
					imageUrl: addon.imageUrl,
					subheading: addon.description,
					showArrow: false,
					onTap: {
						if addon.isViewable {
							navigateToAddonsReceipt(addon.id)
						}
					}
				)
				.padding(.horizontal)
			}
		}
	}
}

#Preview {
    MeAddonsView(myVoyageAddons: .sample(), myVoyageHeader: .empty(), sailingMode: .preCruise, navigateToAddons: {}, navigateToAddonsReceipt: {_ in })
}
