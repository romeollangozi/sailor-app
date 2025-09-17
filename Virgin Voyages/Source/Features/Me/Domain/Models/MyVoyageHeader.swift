//
//  MyVoyageHeader.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 26.2.25.
//

import Foundation

struct MyVoyageHeader: Equatable {
    let imageUrl: String
    let type: MyVoyageType
    let name: String
    let profileImageUrl: String
    let cabinNumber: String
    let lineUpOpeningDateTime: String
    let isLineUpOpened: Bool
}

extension MyVoyageHeader {
    static func empty() -> MyVoyageHeader {
        return MyVoyageHeader(
            imageUrl: "",
            type: .standard,
            name: "",
            profileImageUrl: "",
            cabinNumber: "",
            lineUpOpeningDateTime: "",
            isLineUpOpened: false
        )
    }
}

extension MyVoyageHeader {
    static func sample() -> MyVoyageHeader {
        return MyVoyageHeader(
            imageUrl: "https://www.virginvoyages.com/wp-content/uploads/2021/02/1024x576_1-1024x576.jpg",
            type: .standard,
            name: "John Doe",
            profileImageUrl: "https://www.virginvoyages.com/wp-content/uploads/202",
            cabinNumber: "1234",
            lineUpOpeningDateTime: "01.01.2024",
            isLineUpOpened: false
        )
    }
}
