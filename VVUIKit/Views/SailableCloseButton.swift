//
//  SailableCloseButton.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/8/25.
//

import SwiftUI

public struct SailableCloseButton: View {
	public var action: () -> Void
	public var body: some View {
		Button(action: action) {
			Image(systemName: "xmark.circle.fill")
				.resizable()
				.frame(width: 30, height: 30)
		}
		.foregroundStyle(.black, .white)
		.opacity(0.75)
	}

	public init(action: @escaping () -> Void) {
		self.action = action
	}
}
