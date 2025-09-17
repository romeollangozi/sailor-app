//
//  ContactsHelpToolTipSheet.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 1.11.24.
//

import SwiftUI
import VVUIKit

extension ContactsHelpToolTipSheet {
    static func create(title: String, message: String, back: @escaping () -> Void) -> ContactsHelpToolTipSheet {
        return ContactsHelpToolTipSheet(title: title, message: message, back: back)
    }
}

struct ContactsHelpToolTipSheet: View {
    
    // MARK: - Properties
    let title: String
    let message: String
    
    // MARK: - Navigation handlers
    let back: (() -> Void)
    
    // MARK: - Init
    init(title: String, message: String, back: @escaping () -> Void) {
        self.title = title
        self.message = message
        self.back = back
    }
    
    var body: some View {
        VStack {
            toolbar()
                .padding(.bottom)
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
                .padding(.horizontal)
                .fontStyle(.title)
            Text(message)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
                .fontStyle(.lightBody)
            Spacer()
        }
        .frame(alignment: .leading)
    }
    
    // MARK: - View builders
    private func toolbar() -> some View {
        Toolbar(buttonStyle: .closeButton) {
            back()
        }
    }
}

#Preview {
    ContactsHelpToolTipSheet.create(title: "Help", message: "Ask the sailor who's contact you want to add to open their contacts list within the VV App and then post lorem ipsum dolor atem it consectetur.", back: {})
}
