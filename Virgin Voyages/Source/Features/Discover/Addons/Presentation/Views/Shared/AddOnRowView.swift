//
//  AddOnRowView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 24.9.24.
//

import SwiftUI
import VVUIKit

struct AddOnRowView: View {

    // MARK: - Addon
    var addOn: AddOn
    
    // MARK: - Init
    init(addOn: AddOn) {
        self.addOn = addOn
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Paddings.zero) {
			AddOnHeaderView(viewModel: AddOnHeaderViewModel(addOn: addOn))
            VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding) {
                addOnContent()
            }
            .padding(.bottom, Paddings.defaultVerticalPadding)
        }
        .background(Color.white)
        .cornerRadius(CornerRadiusValues.defaultCornerRadius)
        .shadow(color: .black.opacity(0.1), radius: Paddings.defaultVerticalPadding)
    }

    private func addOnContent() -> some View{
        VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding) {
			if let addonCategory = addOn.addonCategory {
				Text(addonCategory)
					.fontStyle(.boldTagline)
					.foregroundColor(Color.squidInk)
					.padding(.top, Paddings.defaultVerticalPadding16)
					.multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
			}
			if let name = addOn.name {
				Text(name)
					.fontStyle(.smallTitle)
					.foregroundColor(.black)
					.multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
			}
			if let shortDescription = addOn.shortDescription {
                HTMLText(
                    htmlString: shortDescription,
                    fontType: .normal, fontSize: .size14,
                    color: Color.slateGray
                )
                .padding(.bottom)
                .lineLimit(3)
                .multilineTextStyle(.subheadline, alignment: .leading)
			}
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Paddings.defaultVerticalPadding16)
    }
}
