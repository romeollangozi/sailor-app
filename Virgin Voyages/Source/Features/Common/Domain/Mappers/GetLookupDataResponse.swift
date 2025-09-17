//
//  GetLookupDataResponse.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 13.3.25.
//

import Foundation

extension GetLookupDataResponse {
    func toDomain() -> Lookup {
        return Lookup(
            airlines: self.referenceData?.airlines?.map { airline in
                Lookup.Airline(
                    code: airline.code.value,
                    name: airline.name.value
                )
            } ?? [],
            airports: self.referenceData?.airports?.map { airport in
                Lookup.Airport(
                    name: airport.name.value,
                    code: airport.code.value,
                    cityId: airport.cityId.value,
                    cityName: airport.cityName.value
                )
            } ?? [],
            cardTypes: self.referenceData?.cardTypes?.map { cardType in
                Lookup.CardType(
                    referenceId: cardType.referenceId.value,
                    name: cardType.name.value,
                    image: Lookup.CardType.Image(
                        src: cardType.image?.src ?? "",
                        alt: cardType.image?.alt ?? ""
                    )
                )
            } ?? [],
            cities: self.referenceData?.cities?.map { city in
                Lookup.City(
                    name: city.name.value,
                    id: city.id.value,
                    countryCode: city.countryCode.value
                )
            },
            countries: self.referenceData?.countries?.map { country in
                Lookup.Country(
                    name: country.name.value,
                    code: country.code.value,
                    threeLetterCode: country.threeLetterCode.value,
                    dialingCode: country.dialingCode.value
                )
            } ?? [],
            documentTypes: self.referenceData?.documentTypes?.map { documentType in
                Lookup.DocumentType(
                    code: documentType.code.value,
                    name: documentType.name.value
                )
            } ?? [],
            genders: self.referenceData?.genders?.map { gender in
                Lookup.Gender(
                    name: gender.name.value,
                    code: gender.code.value
                )
            } ?? [],
            languages: self.referenceData?.languages?.map { language in
                Lookup.Language(
                    code: language.code.value,
                    name: language.name.value
                )
            },
            paymentModes: self.referenceData?.paymentModes?.map { paymentMode in
                Lookup.PaymentMode(
                    id: paymentMode.id.value,
                    name: paymentMode.name.value
                )
            } ?? [],
            ports: self.referenceData?.ports?.map { port in
                Lookup.Port(
                    code: port.code.value,
                    name: port.name.value,
                    countryCode: port.countryCode.value
                )
            } ?? [],
            rejectionReasons: self.referenceData?.rejectionReasons?.map { rejectionReason in
                Lookup.RejectionReason(
                    rejectionReasonId: rejectionReason.rejectionReasonId.value,
                    name: rejectionReason.name.value
                )
            } ?? [],
            relations: self.referenceData?.relations?.map { relation in
                Lookup.Relation(
                    code: relation.code.value,
                    name: relation.name.value
                )
            } ?? [],
            states: self.referenceData?.states?.map { state in
                Lookup.State(
                    code: state.code.value,
                    countryCode: state.countryCode.value,
                    name: state.name.value
                )
            } ?? [],
            visaEntries: self.referenceData?.visaEntries?.map { visaEntry in
                Lookup.VisaEntry(
                    code: visaEntry.code.value,
                    name: visaEntry.name.value
                )
            } ?? [],
            visaTypes: self.referenceData?.visaTypes?.map { visaType in
                Lookup.VisaType(
                    code: visaType.code.value,
                    name: visaType.name.value,
                    countryCode: visaType.countryCode.value
                )
            } ?? [],
            postCruiseAddressTypes: self.referenceData?.postCruiseAddressTypes?.map { addressType in
                Lookup.PostCruiseAddressType(
                    name: addressType.name.value,
                    code: addressType.code.value
                )
            } ?? [],
            postCruiseTransportationOptions: self.referenceData?.postCruiseTransportationOptions?.map { transportOption in
                Lookup.PostCruiseTransportationOption(
                    name: transportOption.name.value,
                    code: transportOption.code.value
                )
            } ?? [],
            documentCategories: self.referenceData?.documentCategories?.map { documentCategory in
                Lookup.DocumentCategory(
                    id: documentCategory.id.value,
                    code: documentCategory.code.value,
                    name: documentCategory.name.value,
                    typeCode: documentCategory.typeCode.value
                )
            } ?? []
        )
    }
}
