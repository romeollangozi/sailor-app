//
//  GetAddonDetailsResponse.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 22.10.24.
//

import Foundation

struct GetAddonDetailsRequest: AuthenticatedHTTPRequestProtocol {

    var addonCode: String
    var reservatioNumber: String
    var guestId: String
    var shipCode: String
    var code: String
    
    var path: String {
        return NetworkServiceEndpoint.getAddonDetails
    }

    var method: HTTPMethod {
        return .GET
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "reservation-number", value: reservatioNumber), URLQueryItem(name: "code", value: code), URLQueryItem(name: "guestId", value: guestId), URLQueryItem(name: "shipCode", value: shipCode)]
    }

    init(reservatioNumber: String, guestId: String, shipCode: String, code: String) {
        self.addonCode = code
        self.reservatioNumber = reservatioNumber
        self.guestId = guestId
        self.shipCode = shipCode
        self.code = code
    }

    var body: [String : Any]? {
        return nil
    }
}

struct GetAddonsDetailsResponse: Decodable {

    let cmsContent: CMSContent?
    let addOns: [AddOn]?
    let bookingConfirmationImage: String?

    // MARK: - CMSContent Model
    struct CMSContent: Decodable {
        let addonsHeaderText: String?
        let closedWindow: ClosedWindow?
        let addonsText: String?
        let purchasedForText: String?
        let wholeGroupText: String?
        let viewAddonPageText: String?
        let needToKnowsText: String?
        let cancelModalImageURL: String?
        let purchaseText: String?
        let cancelPurchaseText: String?
        let purchasedText: String?
        let cancelButtonText: String?
        let plusText: String?
        let circleIconURL: String?
        let cancelClarifyText: String?
        let confirmCancellation: ConfirmCancellation?
        let viewAddonText: String?
        let soldOut: SoldOut?
        let cancelRefuesdText: String?
        let giftIconURL: String?
        let purchaseCancelledText: String?
        let justForMeText: String?
        let contactSailorServiceText: String?
        let okButtonText: String?
        let baggedItText: String?
        let doneText: String?
        let viewAddonsText: String?
        
    }

    // MARK: - ClosedWindow Model
    struct ClosedWindow: Decodable {
        let text: String?
        let explainer: String?
    }

    // MARK: - ConfirmCancellation Model
    struct ConfirmCancellation: Decodable {
        let image: String?
        let subTitle: String?
        let heading: String?
        let yesCancelText: String?
        let title: String?
        let changedMindText: String?
    }

    // MARK: - SoldOut Model
    struct SoldOut: Decodable {
        let title: String?
    }

    // MARK: - AddOn Model
    // MARK: - AddOn Model
    struct AddOn: Decodable {
        let shortDescription, imageURL: String?
        let name: String?
        let subtitle: String?
        let needToKnows: [String]?
        let code, currencyCode: String?
        let bonusDescription, detailReceiptDescription, addonCategory: String?
        let longDescription: String?
        let landscapeTitleImage: LandscapeTitleImage?
        let isCancellable: Bool?
        let isPurchased: Bool?
        let isBookingEnabled: Bool?
        let guests: [String]?
        let isActionButtonsDisplay: Bool?
        let isSoldOut: Bool?
        let eligibleGuestIds: [String]?
        let amount, bonusAmount: Double?

        enum CodingKeys: String, CodingKey {
            case shortDescription, imageURL, name, subtitle, needToKnows, code, currencyCode,
                 bonusDescription, detailReceiptDescription, addonCategory, longDescription,
                 landscapeTitleImage, isCancellable, isPurchased, isBookingEnabled, guests,
                 isActionButtonsDisplay, isSoldOut, eligibleGuestIds, amount, bonusAmount
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.shortDescription = try container.decodeIfPresent(String.self, forKey: .shortDescription)
            self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
            self.subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
            self.needToKnows = try container.decodeIfPresent([String].self, forKey: .needToKnows)
            self.code = try container.decodeIfPresent(String.self, forKey: .code)
            self.currencyCode = try container.decodeIfPresent(String.self, forKey: .currencyCode)
            self.bonusDescription = try container.decodeIfPresent(String.self, forKey: .bonusDescription)
            self.detailReceiptDescription = try container.decodeIfPresent(String.self, forKey: .detailReceiptDescription)
            self.addonCategory = try container.decodeIfPresent(String.self, forKey: .addonCategory)
            self.longDescription = try container.decodeIfPresent(String.self, forKey: .longDescription)
            self.landscapeTitleImage = try container.decodeIfPresent(LandscapeTitleImage.self, forKey: .landscapeTitleImage)
            self.isCancellable = try container.decodeIfPresent(Bool.self, forKey: .isCancellable)
            self.isPurchased = try container.decodeIfPresent(Bool.self, forKey: .isPurchased)
            self.isBookingEnabled = try container.decodeIfPresent(Bool.self, forKey: .isBookingEnabled)
            self.guests = try container.decodeIfPresent([String].self, forKey: .guests)
            self.isActionButtonsDisplay = try container.decodeIfPresent(Bool.self, forKey: .isActionButtonsDisplay)
            self.isSoldOut = try container.decodeIfPresent(Bool.self, forKey: .isSoldOut)
            
            // Decode eligibleGuestIds and filter out nil values
            let rawGuestIds = try container.decodeIfPresent([String?].self, forKey: .eligibleGuestIds)
            self.eligibleGuestIds = rawGuestIds?.compactMap { $0 }
            
            self.amount = try container.decodeIfPresent(Double.self, forKey: .amount)
            self.bonusAmount = try container.decodeIfPresent(Double.self, forKey: .bonusAmount)
        }
    }

    // MARK: - LandscapeTitleImage Model
    struct LandscapeTitleImage: Decodable {
        let src: String?
        let alt: String?
    }


    static func mapFrom(input: GetAddonsDetailsResponse.AddOn) -> AddOnModel {
        return AddOnModel(shortDescription: input.shortDescription.value, imageURL: input.landscapeTitleImage?.src.value ?? "", name: input.name.value, subtitle: input.subtitle.value, needToKnows: input.needToKnows ?? [], code: input.code.value, currencyCode: input.currencyCode.value, bonusDescription: input.bonusDescription.value, detailReceiptDescription: input.detailReceiptDescription.value, addonCategory: input.addonCategory.value, longDescription: input.longDescription.value, isCancellable: input.isCancellable.value, isPurchased: input.isPurchased.value, isBookingEnabled: input.isBookingEnabled.value, guests: input.guests ?? [], isActionButtonsDisplay: input.isActionButtonsDisplay.value, isSoldOut: input.isSoldOut.value, eligibleGuestIds: input.eligibleGuestIds ?? [], amount: input.amount.value, bonusAmount: input.bonusAmount.value)
    }
    
    static func mapFrom(input: GetAddonsDetailsResponse.CMSContent) -> AddonCMSModel {
        return AddonCMSModel(addonsHeaderText: input.addonsHeaderText.value, closedWindowText: input.closedWindow?.text.value ?? "", closedWindowExplainer: input.closedWindow?.explainer.value ?? "", addonsText: input.addonsText.value, purchasedForText: input.purchasedForText.value, wholeGroupText: input.wholeGroupText.value, viewAddonPageText: input.viewAddonPageText.value, needToKnowsText: input.needToKnowsText.value, cancelModalImageURL: input.cancelModalImageURL.value, purchaseText: input.purchaseText.value, cancelPurchaseText: input.cancelPurchaseText.value, purchasedText: input.purchaseText.value, cancelButtonText: input.cancelButtonText.value, plusText: input.plusText.value, circleIconURL: input.circleIconURL.value, cancelClarifyText: input.cancelClarifyText.value, confirmationImage: input.confirmCancellation?.image.value ?? "", confirmationSubTitle: input.confirmCancellation?.subTitle.value ?? "", confirmationHeading: input.confirmCancellation?.heading.value ?? "", confirmationYesCancelText: input.confirmCancellation?.yesCancelText.value ?? "", confirmationTitle: input.confirmCancellation?.title.value ?? "", confirmationChangedMindText: input.confirmCancellation?.changedMindText.value ?? "", viewAddonText: input.viewAddonText.value, soldOut: input.soldOut?.title.value ?? "", cancelRefuesdText: input.cancelRefuesdText.value, giftIconURL: input.giftIconURL.value, purchaseCancelledText: input.purchaseCancelledText.value, justForMeText: input.justForMeText.value, contactSailorServiceText: input.contactSailorServiceText.value, okButtonText: input.okButtonText.value, baggedItText: input.baggedItText.value, doneText: input.doneText.value, viewAddonsText: input.viewAddonsText.value)
    }
    
}

extension NetworkServiceProtocol {
    
    func getAddonDetails(addonCode: String, reservatioNumber: String, guestId: String, shipCode: String) async throws -> GetAddonsDetailsResponse? {
        let request = GetAddonDetailsRequest(reservatioNumber: reservatioNumber, guestId: guestId, shipCode: shipCode, code: addonCode)
        return try await self.requestV2(request, responseModel: GetAddonsDetailsResponse.self)
    }
}

// MARK: - AddOn Model
struct AddOnModel: Decodable {
    var shortDescription: String = ""
    var imageURL: String = ""
    var name: String = ""
    var subtitle: String = ""
    var needToKnows: [String] = []
    var code: String = ""
    var currencyCode: String = ""
    var bonusDescription: String = ""
    var detailReceiptDescription: String = ""
    var addonCategory: String = ""
    var longDescription: String = ""
    var isCancellable: Bool = false
    var isPurchased: Bool = false
    var isBookingEnabled: Bool = false
    var guests: [String] = []
    var isActionButtonsDisplay: Bool = false
    var isSoldOut: Bool = false
    var eligibleGuestIds: [String] = []
    var amount: Double = 0.0
    var bonusAmount: Double = 0.0
}


struct AddonCMSModel: Decodable {
    var addonsHeaderText: String = ""
    var closedWindowText: String = ""
    var closedWindowExplainer: String = ""

    var addonsText: String = ""
    var purchasedForText: String = ""
    var wholeGroupText: String = ""
    var viewAddonPageText: String = ""
    var needToKnowsText: String = ""
    var cancelModalImageURL: String = ""
    var purchaseText: String = ""
    var cancelPurchaseText: String = ""
    var purchasedText: String = ""
    var cancelButtonText: String = ""
    var plusText: String = ""
    var circleIconURL: String = ""
    var cancelClarifyText: String = ""

    var confirmationImage: String = ""
    var confirmationSubTitle: String = ""
    var confirmationHeading: String = ""
    var confirmationYesCancelText: String = ""
    var confirmationTitle: String = ""
    var confirmationChangedMindText: String = ""

    var viewAddonText: String = ""
    var soldOut: String = ""
    var cancelRefuesdText: String = ""
    var giftIconURL: String = ""
    var purchaseCancelledText: String = ""
    var justForMeText: String = ""
    var contactSailorServiceText: String = ""
    var okButtonText: String = ""
    var baggedItText: String = ""
    var doneText: String = ""
    var viewAddonsText: String = ""
}


