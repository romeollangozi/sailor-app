//
//  ActivityLevel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 22.11.24.
//

struct ActivityLevel {
    
    static let activityLevelData: [String: [String: String]] = [
        "VERY EASY": [
            "cache": "true",
            "link": "https://int.gcpshore.virginvoyages.com/dam/jcr:02516e20-0130-4327-877b-83de3da75547/ILLO-my-voyage-energylvl_blue1-400x32.png",
            "format": "image/png",
            "width": "400",
            "type": "image",
            "height": "32"
        ],
        "ACTIVE": [
            "cache": "true",
            "link": "https://int.gcpshore.virginvoyages.com/dam/jcr:d48defe4-8c71-4024-84bc-074e5d2ddc14/ILLO-my-voygage-energylvl_blue4-400x32.png",
            "format": "image/png",
            "width": "400",
            "type": "image",
            "height": "32"
        ],
        "MODERATE": [
            "cache": "true",
            "link": "https://int.gcpshore.virginvoyages.com/dam/jcr:6e7ce9f2-b51d-452c-ba6f-f76faca578b5/ILLO-my-voyage-energylvl_blue3-400-32.png",
            "format": "image/png",
            "width": "400",
            "type": "image",
            "height": "32"
        ],
        "VERY ACTIVE": [
            "cache": "true",
            "link": "https://int.gcpshore.virginvoyages.com/dam/jcr:c1a5dc4e-43f2-4984-b9f6-e1562cd6976c/ILLO-my-voyage-energylvl_blue5-400-32.png",
            "format": "image/png",
            "width": "400",
            "type": "image",
            "height": "32"
        ],
        "EASY": [
            "cache": "true",
            "link": "https://int.gcpshore.virginvoyages.com/dam/jcr:d481ee2d-44f1-4c1d-9f50-e94255d347e0/ILLO-my-voyage-energylvl_blue2-400-x32.png",
            "format": "image/png",
            "width": "400",
            "type": "image",
            "height": "32"
        ]
    ]
    
    enum ActivityLevelType: String {
        case veryEasy = "VERY EASY"
        case easy = "EASY"
        case moderate = "MODERATE"
        case active = "ACTIVE"
        case veryActive = "VERY ACTIVE"
    }

    struct ImageData {
        let cache: Bool
        let link: String
        let format: String
        let width: Int
        let type: String
        let height: Int
    }

    let type: ActivityLevelType
    let imageData: ImageData
}

extension ActivityLevel {
    static func from(input: String) -> ActivityLevel? {
        guard let levelType = ActivityLevelType(rawValue: input),
              let data = activityLevelData[input],
              let cacheString = data["cache"],
              let link = data["link"],
              let format = data["format"],
              let widthString = data["width"],
              let type = data["type"],
              let heightString = data["height"],
              let cache = Bool(cacheString.lowercased()),
              let width = Int(widthString),
              let height = Int(heightString) else {
            return nil
        }
        
        let imageData = ImageData(
            cache: cache,
            link: link,
            format: format,
            width: width,
            type: type,
            height: height
        )
        
        return ActivityLevel(type: levelType, imageData: imageData)
    }
}
