//
//  GetMyVoyageHeaderRequestResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 26.2.25.
//

extension GetMyVoyageHeaderRequestResponse {
    func toDomain() -> MyVoyageHeader {
        return MyVoyageHeader(
            imageUrl: self.imageUrl.value,
            type: type?.toDomain() ?? .standard,
            name: self.name.value,
            profileImageUrl: self.profileImageUrl.value,
            cabinNumber: self.cabinNumber.value,
            lineUpOpeningDateTime: self.lineUpOpeningDateTime.value ,
            isLineUpOpened: self.isLineUpOpened.value
        )
    }
}

extension GetMyVoyageHeaderRequestResponse.MyVoyageType {
    func toDomain() -> MyVoyageType {
        switch self {
        case .standard:
            return .standard
        case .priority:
            return .priority
        case .rockStar:
            return .rockStar
        case .megaRockStar:
            return .megaRockStar
        }
    }
}
