//
//  ListCell.swift
//  VVUIKit
//
//  Created by TX on 13.2.25.
//

import Foundation
import SwiftUI

public enum ListCellType {
    case titleDescription
    case titleDescriptionAuxiliary
    case titleDescriptionBadge
    case titleDescriptionBadgeAuxiliary
    case imageTitleDescription
    case imageTitleDescriptionBadge
    case imageTitleDescriptionAuxiliary
    case imageTitleDescriptionBadgeAuxiliary
}

public struct ListCellViewModel {
    
    let id: String
    let title: String
    let description: String
    let imageURL: String?
    let placeholderImage: Image?
    let badgeNumber: Int?
    let auxiliaryText: String?
    let badgeColor: Color?
    let thumbLetter: String?
    
    
    public init(
        id: String,
        title: String,
        description: String,
        imageURL: String? = nil,
        placeholderImage: Image? = nil,
        badgeNumber: Int? = nil,
        auxiliaryText: String? = nil,
        badgeColor: Color? = .aquaBlue,
        thumbLetter: String? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.placeholderImage = placeholderImage
        self.badgeNumber = badgeNumber
        self.auxiliaryText = auxiliaryText
        self.badgeColor = badgeColor
        self.thumbLetter = thumbLetter
    }
}

public struct ListCell: View {
    let content: ListCellViewModel
    let type: ListCellType
    let onTap: (String) -> Void

    public init(content: ListCellViewModel,
                type: ListCellType = .titleDescription,
                onTap: @escaping (String) -> Void) {
        
        self.content = content
        self.type = type
        self.onTap = onTap
    }
    
    public var body: some View {
        Button {
            self.onTap(content.id)
        } label: {
            VStack (spacing: 0.0) {
                HStack(alignment: .center, spacing: Spacing.space12) {
                    
                    if type == .imageTitleDescription ||
                        type == .imageTitleDescriptionAuxiliary ||
                        type == .imageTitleDescriptionBadgeAuxiliary ||
                        type == .imageTitleDescriptionBadge {
                        
                        CircleImageView(imageURL: content.imageURL, placeholderImage: content.placeholderImage, letter: content.thumbLetter)
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.space4) {
                        Text(content.title)
                            .font(.vvBodyMedium)
                            .foregroundColor(.blackText)
                            .lineLimit(1)
                        
                        Text(content.description)
                            .font(.vvCaption)
                            .foregroundColor(.slateGray)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    VStack (alignment: .trailing, spacing: Spacing.space4){
                        if type == .titleDescriptionBadgeAuxiliary ||
                            type == .imageTitleDescriptionAuxiliary ||
                            type == .imageTitleDescriptionBadgeAuxiliary ||
                            type == .titleDescriptionAuxiliary,
                           let auxiliaryText = content.auxiliaryText {
                            VStack(alignment: .trailing) {
                                Text(auxiliaryText)
                                    .font(.vvCaption)
                                    .foregroundColor(.slateGray)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        if type == .titleDescriptionBadge ||
                            type == .titleDescriptionBadgeAuxiliary ||
                            type == .imageTitleDescriptionBadge ||
                            type == .imageTitleDescriptionBadgeAuxiliary,
                           let badgeNumber = content.badgeNumber, let badgeColor = content.badgeColor {
                                CircleBadgeView(number: badgeNumber, color: badgeColor)
                        }
                    }
                    .frame(maxWidth: 60.0, alignment: .trailing)
                }
                .padding(.vertical, Spacing.space24)
                
                Divider()
                    .padding(0)
            }

        }
    }
}

struct CircleImageView: View {
    let imageURL: String?
    let placeholderImage: Image?
    let letter: String?
    
    var body: some View {
        if let imageURL {
            URLImage(url: URL(string: imageURL))
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        } else if let placeholderImage {
            placeholderImage
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        } else if let letter {
            ZStack {
                Circle()
                    .fill(Color.darkGray)
                    .frame(width: 40, height: 40)
                Text(String(letter.prefix(1)).uppercased())
                    .font(.vvSmallBold)
                    .foregroundColor(.white)
            }

        } else {
            Circle()
                .fill(Color(.darkGray))
                .frame(width: 40, height: 40)
        }
    }
}

struct CircleBadgeView: View {
    let number: Int
    let color: Color
    
    var body: some View {
        Text("\(number)")
            .frame(width: 18.0, height: 18.0)
            .font(.vvBodyMedium)
            .padding(2)
            .background(color)
            .foregroundColor(.slateGray)
            .clipShape(Circle())
    }
}

#Preview {
    VStack {
        ListCell(content: ListCellViewModel(
            id: "1",
            title: "Sample Title", // String
            description: "This is a description of the item., ", // String
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/Philips_PM5544.svg/300px-Philips_PM5544.svg.png", // String
            badgeNumber: 5, // Int?
            auxiliaryText: "1:25pm" // String?
        ), type: .imageTitleDescriptionBadgeAuxiliary, onTap: { _ in }) // ListCellType

        ListCell(content: ListCellViewModel(
            id: "2",
            title: "No Image Title", // String
            description: "Description without image.", // String
            imageURL: nil, // String?
            badgeNumber: nil, // Int?
            auxiliaryText: nil // String?
        ), type: .titleDescription, onTap: { _ in }) // ListCellType

        ListCell(content: ListCellViewModel(
            id: "3",
            title: "Another Title", // String
            description: "Item description here.", // String
            imageURL: nil, // String
            badgeNumber: 10, // Int?
            auxiliaryText: nil // String?
        ), type: .imageTitleDescriptionBadge, onTap: { _ in }) // ListCellType

        ListCell(content: ListCellViewModel(
            id: "4",
            title: "Title Only", // String
            description: "Just a description", // String
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/Philips_PM5544.svg/300px-Philips_PM5544.svg.png", // String
            badgeNumber: nil, // Int?
            auxiliaryText: "yesterday 3h ago" // String?
        ), type: .titleDescriptionAuxiliary, onTap: { _ in }) // ListCellType

    }
    .padding()
    .background(.white)
}
