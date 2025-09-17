//
//  Lookup.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 13.3.25.
//

import Foundation
import VVUIKit

struct Lookup: Equatable, Hashable {
    static let countiesKey: String = "countries"

    let airlines: [Airline]
    let airports: [Airport]
    let cardTypes: [CardType]
    let cities: [City]?
    let countries: [Country]
    let documentTypes: [DocumentType]
    let genders: [Gender]
    let languages: [Language]?
    let paymentModes: [PaymentMode]
    let ports: [Port]
    let rejectionReasons: [RejectionReason]
    let relations: [Relation]
    let states: [State]
    let visaEntries: [VisaEntry]
    let visaTypes: [VisaType]
    let postCruiseAddressTypes: [PostCruiseAddressType]
    let postCruiseTransportationOptions: [PostCruiseTransportationOption]
    let documentCategories: [DocumentCategory]

    struct Airline: Equatable, Hashable {
        let code: String
        let name: String
    }

    struct Airport: Equatable, Hashable {
        let name: String
        let code: String
        let cityId: String
        let cityName: String
    }

    struct CardType: Equatable, Hashable {
        let referenceId: String
        let name: String
        let image: Image

        struct Image: Equatable, Hashable {
            let src: String
            let alt: String
        }
    }

    struct City: Equatable, Hashable {
        let name: String
        let id: String
        let countryCode: String
    }

    struct Country: Equatable, Hashable {
        let name: String
        let code: String
        let threeLetterCode: String?
        let dialingCode: String?
    }

    struct DocumentType: Equatable, Hashable {
        let code: String
        let name: String
    }

    struct Gender: Equatable, Hashable {
        let name: String
        let code: String
    }

    struct Language: Equatable, Hashable {
        let code: String
        let name: String
    }

    struct PaymentMode: Equatable, Hashable {
        let id: String
        let name: String
    }

    struct Port: Equatable, Hashable {
        let code: String
        let name: String
        let countryCode: String
    }

    struct RejectionReason: Equatable, Hashable {
        let rejectionReasonId: String
        let name: String
    }

    struct Relation: Equatable, Hashable {
        let code: String
        let name: String
    }

    struct State: Equatable, Hashable {
        let code: String
        let countryCode: String
        let name: String
    }

    struct VisaEntry: Equatable, Hashable {
        let code: String
        let name: String
    }

    struct VisaType: Equatable, Hashable {
        let code: String
        let name: String
        let countryCode: String
    }

    struct PostCruiseAddressType: Equatable, Hashable {
        let name: String
        let code: String
    }

    struct PostCruiseTransportationOption: Equatable, Hashable {
        let name: String
        let code: String
    }

    struct DocumentCategory: Equatable, Hashable {
        let id: String
        let code: String
        let name: String
        let typeCode: String
    }
}

// MARK: - Extensions
extension Lookup {
    static func sample() -> Lookup {
        return Lookup(
            airlines: [Airline(code: "VB", name: "Virgin Blue")],
            airports: [Airport(name: "Heathrow Airport", code: "LHR", cityId: "ba3d9d1a-cd67-45e4-b3fd-b55c82c573e0", cityName: "Alaska")],
            cardTypes: [CardType(referenceId: "001", name: "VISA", image: CardType.Image(src: "https://example.com/visa.png", alt: "VISA"))],
            cities: [City(name: "Abbeville", id: "30fc54fb-036c-4a22-8cce-d836167aa92f", countryCode: "US")],
            countries: [Country(name: "Austria", code: "AT", threeLetterCode: "USA", dialingCode: "43")],
            documentTypes: [DocumentType(code: "BC", name: "Birth Certificate")],
            genders: [Gender(name: "Male", code: "M")],
            languages: [Language(code: "en", name: "ENGLISH")],
            paymentModes: [PaymentMode(id: "02ee248e-e3d5-4242-8c99-94a51608a63d", name: "Cash Payment")],
            ports: [Port(code: "PCV", name: "Port Canaveral (Orlando), FL", countryCode: "NL")],
            rejectionReasons: [RejectionReason(rejectionReasonId: "62d2fd04-94a9-4e2b-8656-43938af1c2f0", name: "Photo has no valid face.")],
            relations: [Relation(code: "FATHER", name: "Father")],
            states: [State(code: "AG", countryCode: "CH", name: "Aagau")],
            visaEntries: [VisaEntry(code: "SINGLE", name: "Single")],
            visaTypes: [VisaType(code: "BCC", name: "Border Crossing Card", countryCode: "US")],
            postCruiseAddressTypes: [PostCruiseAddressType(name: "Home", code: "HOME")],
            postCruiseTransportationOptions: [PostCruiseTransportationOption(name: "Airways", code: "AIR")],
            documentCategories: [DocumentCategory(id: "1c31c19a-3fde-4777-860c-d265f1e546b6", code: "EV", name: "E-Visa", typeCode: "V")]
        )
    }
    
    static func empty() -> Lookup {
        return Lookup(
            airlines: [],
            airports: [],
            cardTypes: [],
            cities: nil,
            countries: [],
            documentTypes: [],
            genders: [],
            languages: nil,
            paymentModes: [],
            ports: [],
            rejectionReasons: [],
            relations: [],
            states: [],
            visaEntries: [],
            visaTypes: [],
            postCruiseAddressTypes: [],
            postCruiseTransportationOptions: [],
            documentCategories: []
        )
    }
}

extension Lookup {
    func toLookupOptionsDictionary() -> [String: [Option]] {
        return [
            "airlines": airlines.map { Option(key: $0.code, value: $0.name) },
            "airports": airports.map { Option(key: $0.code, value: $0.name) },
            "cardTypes": cardTypes.map { Option(key: $0.referenceId, value: $0.name) },
            "cities": cities?.map { Option(key: $0.id, value: $0.name) } ?? [],
            "countries": countries
                .sorted {
                    ["GB", "US"].firstIndex(of: $0.code) ?? Int.max
                    < ["GB", "US"].firstIndex(of: $1.code) ?? Int.max
                    || (
                        !["GB", "US"].contains($0.code)
                        && !["GB", "US"].contains($1.code)
                        && $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                    )
                }
                .map { Option(key: $0.code, value: $0.name) },
            "documentTypes": documentTypes.map { Option(key: $0.code, value: $0.name) },
            "genders": genders.map { Option(key: $0.code, value: $0.name) },
            "languages": languages?.map { Option(key: $0.code, value: $0.name) } ?? [],
            "paymentModes": paymentModes.map { Option(key: $0.id, value: $0.name) },
            "ports": ports.map { Option(key: $0.code, value: $0.name) },
            "rejectionReasons": rejectionReasons.map { Option(key: $0.rejectionReasonId, value: $0.name) },
            "relations": relations.map { Option(key: $0.code, value: $0.name) },
            "states": states.map { Option(key: "\($0.code)|\($0.countryCode)", value: $0.name) },
            "visaEntries": visaEntries.map { Option(key: $0.code, value: $0.name) },
            "visaTypes": visaTypes.map { Option(key: $0.code, value: "\($0.code) \($0.name)")},
            "postCruiseAddressTypes": postCruiseAddressTypes.map { Option(key: $0.code, value: $0.name) },
            "postCruiseTransportationOptions": postCruiseTransportationOptions.map { Option(key: $0.code, value: $0.name) },
            "documentCategories": documentCategories.map { Option(key: $0.code, value: $0.name) }
        ]
    }
}

struct StateKeyParser {
    static func parse(from key: String) -> (code: String, countryCode: String)? {
        let parts = key.components(separatedBy: "|")
        guard parts.count == 2 else { return nil }
        return (code: parts[0], countryCode: parts[1])
    }
}
