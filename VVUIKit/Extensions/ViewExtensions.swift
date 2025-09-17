//
//  ViewExtensions.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 3.4.25.
//

import SwiftUI

extension View {
	@ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
		if condition {
			transform(self)
		} else {
			self
		}
	}
}
