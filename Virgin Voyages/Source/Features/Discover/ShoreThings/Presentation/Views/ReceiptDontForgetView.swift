//
//  ReceiptDontForgetView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 24.11.24.
//

import SwiftUI

protocol ReceiptDontForgetViewModelProtocol {
	var dontForgetText: String { get }
	var reminders: [ReceiptDontForgetViewReminders] { get }
}

struct ReceiptDontForgetViewReminders: Identifiable {
	var id: String {
		return name
	}

	var name: String
}

struct ReceiptDontForgetView: View {
    
    let viewModel: ReceiptDontForgetViewModelProtocol

    var body: some View {
        VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding16) {
            Text(viewModel.dontForgetText)
                .fontStyle(.boldTagline)
                .foregroundStyle(Color.slateGray)
			ForEach(viewModel.reminders) { item in
				HStack(alignment: .top, spacing: Paddings.defaultVerticalPadding16) {
					Image("NeedToKnow")
						.resizable()
						.frame(width: Sizes.defaultSize24, height: Sizes.defaultSize24)
						.aspectRatio(contentMode: .fit)

					Text(item.name)
						.fontStyle(.lightBody)
						.foregroundColor(.lightGreyColor)
						.multilineTextAlignment(.leading)
				}
			}
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Paddings.defaultVerticalPadding)
    }
}

struct MockReceiptDontForgetViewModel: ReceiptDontForgetViewModelProtocol {
	var dontForgetText: String = "Don't forget to check out these important reminders:"
	var reminders: [ReceiptDontForgetViewReminders] = [
		ReceiptDontForgetViewReminders(name: "Pack your passport."),
		ReceiptDontForgetViewReminders(name: "Bring your travel insurance documents."),
		ReceiptDontForgetViewReminders(name: "Check-in online before departure."),
	]
}

struct ReceiptDontForgetView_Previews: PreviewProvider {
	static var previews: some View {
		ReceiptDontForgetView(viewModel: MockReceiptDontForgetViewModel())
			.previewLayout(.sizeThatFits)
			.padding()
	}
}
