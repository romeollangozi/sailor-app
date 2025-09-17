//
//  TicketLabel.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/17/24.
//

import SwiftUI

public struct TicketLabelDivider: View {
	var spacing: CGFloat
    
    public init(spacing: CGFloat) {
        self.spacing = spacing
    }
    
    public var body: some View {
		HStack(spacing: 0) {
			LeadingArcShape()
				.frame(width: 6)
            DashedLine(color: Color.borderGray)
				.padding(EdgeInsets(top: 0, leading: spacing - 6, bottom: 0, trailing: spacing - 6))
			TrailingArcShape()
				.frame(width: 6)
		}
		.frame(height: 12)
	}
}

public struct MultiTicketLabel<Header: View, Content: View, Footer : View>: View {
	var spacing: CGFloat
	var backgroundColor: Color
	@ViewBuilder var header: () -> Header
	@ViewBuilder var label: () -> Content
	@ViewBuilder var footer: () -> Footer
    
    public init(
        spacing: CGFloat,
        backgroundColor: Color,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder label: @escaping () -> Content,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.spacing = spacing
        self.backgroundColor = backgroundColor
        self.header = header
        self.label = label
        self.footer = footer
    }
	
    public var body: some View {
		VStack(spacing: 0) {
			header()
			TicketLabelDivider(spacing: spacing)
				.foregroundStyle(backgroundColor)
			label()
			TicketLabelDivider(spacing: spacing)
				.foregroundStyle(backgroundColor)
			footer()
		}
		.listRowStyle()
	}
}

public struct AdaptiveMultiTicketLabel<Header: View, Content: View, Footer : View>: View {
    var spacing: CGFloat
    var backgroundColor: Color
    var hasLabel: Bool
    @ViewBuilder var header: () -> Header
    @ViewBuilder var label: () -> Content
    @ViewBuilder var footer: () -> Footer
    
    public init(
        spacing: CGFloat,
        backgroundColor: Color,
        hasLabel: Bool,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder label: @escaping () -> Content,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.spacing = spacing
        self.backgroundColor = backgroundColor
        self.hasLabel = hasLabel
        self.header = header
        self.label = label
        self.footer = footer
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header()
            TicketLabelDivider(spacing: spacing)
                .foregroundStyle(backgroundColor)
            if hasLabel {
                label()
                TicketLabelDivider(spacing: spacing)
                    .foregroundStyle(backgroundColor)
            }

            footer()
        }
        .listRowStyle()
    }
}
