//
//  EmailNotRecognisedReasonView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 10.9.24.
//

import SwiftUI
import VVUIKit

extension EmailNotRecognisedReasonView {
    static func create(dismiss: @escaping (() -> Void)) -> EmailNotRecognisedReasonView {
        return EmailNotRecognisedReasonView(dismiss: dismiss)
    }
}

struct EmailNotRecognisedReasonView: View {
    
    // MARK: - Toolbar actions
    let dismiss: (() -> Void)
    
    var body: some View {
        toolbar()
        VStack(spacing: Paddings.defaultVerticalPadding16) {
            headerView()
            closeButton()
            Spacer()
        }
        .padding(.horizontal, Paddings.defaultVerticalPadding24)
    }
    
    // MARK: - View builders
    private func toolbar() -> some View {
        Toolbar(buttonStyle: .closeButton) {
            dismiss()
        }
    }
    
    private func headerView() -> some View {
        return VStack {
            Text("Why has this happened?")
                .fontStyle(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, Paddings.defaultVerticalPadding)
            Text("Sometimes accounts get deactivated when a sailor mistakenly claims a booking from another sailor in their cabin.\n\nAccounts can also be deactivated automatically or by sailor services if a sailor has two accounts in the system.\n\nIn these scenarios, the best and easiest solution is to register a new account. Once you have done this your existing bookings can be pulled into your new account by ‘claiming a booking’. You will find the ability to ‘claim a booking’ in the account dashboard on the website or on the Sailor App.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontStyle(.largeTagline)
                .foregroundColor(.gray)
        }
    }
    
    private func closeButton() -> some View {
        Button("Got it") {
            dismiss()
        }
        .buttonStyle(SecondaryButtonStyle())
        .padding(.vertical, Paddings.defaultVerticalPadding)
    }
}

#Preview {
    EmailNotRecognisedReasonView(dismiss: {})
}
