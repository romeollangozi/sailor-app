//
//  Constants.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 26.8.24.
//

import Foundation

struct CornerRadiusValues {
    static let defaultCornerRadius = 8.0
}

struct Paddings {
    static let minus50 = -50.0
    static let zero = 0.0
    static let defaultPadding8 = 8.0
    static let defaultHorizontalPadding = 24.0
    static let defaultHorizontalPadding20 = 20.0
    static let defaultVerticalPadding40 = 40.0
    static let defaultVerticalPadding = 8.0
    static let defaultVerticalPadding16 = 16.0
    static let defaultVerticalPadding24 = 24.0
    static let defaultVerticalPadding32 = 32.0
    static let defaultVerticalPadding48 = 48.0
    static let defaultVerticalPadding64 = 64.0
    static let defaultVerticalPadding128 = 128.0
    static let capsuleButtonHorizontalPadding = 20.0
    static let capsuleButtonVerticalPadding = 15.0
    static let smallVerticalPadding3 = 3.5
    static let cellTitleSubtitlePadding = 5.0
    static let minusPadding64 = -64.0
    static let padding12 = 12.0
}

struct Sizes {
    static let zero = 0.0
    static let defaultSize8 = 8.0
    static let defaultSize16 = 16.0
    static let defaultSize24 = 24.0
    static let defaultSize32 = 32.0
    static let defaultSize40 = 40.0
    static let defaultSize48 = 48.0
    static let defaultSize56 = 56.0
    static let defaultSize64 = 64.0
    static let defaultSize80 = 80.0
    static let defaultSize90 = 90.0
    static let defaultSize150 = 150.0
    static let defaultSize240 = 240.0
    static let defaultImageHeight234: CGFloat = 234.0
    static let defaultImageHeight292: CGFloat = 292.5
    static let defaultImageHeight390: CGFloat = 390.0
    static let drawerButtonWidth: CGFloat = 100.0
    static let drawerButtonHeight: CGFloat = 140.0
    static let socialLoginButtonSize = 50.0
    static let addonDetailsImageSize = 390.0
    static let receiptViewImageSize = 340.0
    static let qrCodeImageSize = 300.0
    static let activityPictogram = 80.0
    static let preVoyageEditingStopped = 200.0
    static let drawerCornerRadius: CGFloat = 20.0
    static let drawerProfileImage: CGFloat = 70.0
    static let meProfileImageSize: CGFloat = 80.0
    static let meProfileStarImageSize: CGFloat = 20.0
}

struct SupportServices {
    static let email = "redgloveservice@virginvoyages.com"
}

struct ConstantParameters {
    static let mediagroupid = "f67c581d-4a9b-e611-80c2-00155df80332"
    static let componentId = "38c1ab51-ce97-439c-9d20-c48d724e1fe5"
}

struct WebSocketConstants {
    static let url = "wss://\(APIEnvironmentProvider().getEnvironment().host)/websocket-service/ws"
    static let topic = "qa-ship-stateroomcontrol-vas.cabincontrols"
    static let kafkaTopicRoomcontrol = "kafka.topic.roomcontrol"
}
