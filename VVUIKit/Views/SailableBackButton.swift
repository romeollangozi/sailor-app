//
//  SailableBackButton.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/8/25.
//

import SwiftUI

public struct SailableBackButton: View {
	public var action: () -> Void
	public var body: some View {
		Button(action: action) {
			Image(systemName: "arrow.backward.circle.fill")
				.resizable()
				.frame(width: 30, height: 30)
		}
		.foregroundStyle(.black, .clear)
	}

	public init(action: @escaping () -> Void) {
		self.action = action
	}
}
