//
//  StatusType.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 21.7.25.
//

import SwiftUI

// MARK: - Status Type
enum StatusType {
    case warning
    case success
    
    var iconName: String {
        switch self {
        case .warning: return "exclamationmark.circle.fill"
        case .success: return "checkmark.circle.fill"
        }
    }
    
    var colors: (icon: Color, background: Color, border: Color) {
        switch self {
        case .warning:
            return (.errorLight, .lightErrorBackground, .errorLight)
        case .success:
            return (.successLight, .successLight.opacity(0.1), .successLight)
        }
    }
}

// MARK: - Status Card View
public struct StatusCardView: View {
    let title: String
    let subTitle: String
    let type: StatusType
    
    public var body: some View {
        HStack(alignment: .center, spacing: Spacing.space12) {

            Image(systemName: type.iconName)
                .font(.title2)
                .foregroundStyle(type.colors.icon)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
					.foregroundStyle(type.colors.icon)
                Text(subTitle)
                    .font(.body)
					.foregroundStyle(type.colors.icon)
            }
            
            Spacer()
        }
		.padding(Spacing.space16)
        .background(type.colors.background)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(type.colors.border, lineWidth: 1.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Convenience Extensions
extension StatusCardView {
    public static func warning(title: String, body: String) -> StatusCardView {
        StatusCardView(title: title, subTitle: body, type: .warning)
    }
    
    public static func success(title: String, body: String) -> StatusCardView {
		StatusCardView(title: title, subTitle: body, type: .success)
    }
}

// MARK: - Preview
#Preview {
	VStack(spacing: Spacing.space20) {
        StatusCardView.warning(
            title: "Warning Title",
            body: "This is a warning message"
        )
        
        StatusCardView.success(
            title: "Success Title", 
            body: "This is a success message"
        )
    }
    .padding()
}
