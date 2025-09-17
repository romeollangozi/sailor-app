//
//  FolioDrawerInfoSheet.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 16.6.25.
//

import SwiftUI

struct FolioDrawerInfoSheet: View {
    let title: String
    let description: String
    let close: () -> Void

    init(title: String, description: String, close: @escaping () -> Void) {
        self.title = title
        self.description = description
        self.close = close
    }

    var body: some View {
        VStack(spacing: 0) {
            toolbar()
            drawerInfoContent()
        }
    }

    func toolbar() -> some View {
        Toolbar(buttonStyle: .closeButton) {
            close()
        }
    }

    private func drawerInfoContent() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space16) {
            Text(title)
                .font(.vvHeading3Bold)
                .foregroundColor(.blackText)

            Text(description)
                .font(.vvSmall)
                .multilineTextAlignment(.leading)
                .foregroundColor(.slateGray)
                .lineSpacing(8)
            Spacer()
        }
        .padding(Spacing.space24)
    }
}

#Preview {
    FolioDrawerInfoSheet(title: "Bar tab", description: "Bar Tab is automatically used when you purchase alcholic beverages onboard the ship.", close: {})
}

