//
//  ErrorStatusView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 17.3.25.
//


import SwiftUI

public struct ErrorStatusView: View {
	public init() {}
	public var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white, lineWidth: 2)
                .background(Circle().fill(Color.orange))
				.frame(width: Spacing.space20, height: Spacing.space20)

            Image(systemName: "exclamationmark.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.white, .orange)
        }
    }
}

#Preview {
    VStack {
        ErrorStatusView()
    }
}
