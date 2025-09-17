//
//  ComponentSetting.swift
//  Virgin Voyages
//
//  Created by Pajtim on 20.5.25.
//

import Foundation

struct ComponentSettings {
    let id: String
    let value: String
    let name: String
    let dataType: String
    let yamlKey: String
    let valueWithPlaceholder: String
    let isConstant: Bool
}

extension ComponentSettingsResponse {
    func toDomain() -> ComponentSettings {
        return ComponentSettings(
            id: self.id.value,
            value: self.value.value,
            name: self.name.value,
            dataType: self.dataType.value,
            yamlKey: self.yamlKey.value,
            valueWithPlaceholder: self.valueWithPlaceHolder.value,
            isConstant: self.isConstant.value
        )
    }
}

extension Array where Element == ComponentSettingsResponse {
    func toDomain() -> [ComponentSettings] {
        return self.map { $0.toDomain() }
    }
}

extension Array where Element == ComponentSettings {
	func findByName(_ name: String) -> ComponentSettings? {
		return self.first { $0.name == name }
	}
}

extension ComponentSettings {
	static func sample() -> ComponentSettings {
		return ComponentSettings(
			id: "sampleId",
			value: "sampleValue",
			name: "sampleName",
			dataType: "sampleDataType",
			yamlKey: "sampleYamlKey",
			valueWithPlaceholder: "sampleValueWithPlaceholder",
			isConstant: false
		)
	}
	
	static func sampleWithForceUdpate() -> ComponentSettings {
		.init(id: "aa7c8864-0a21-11ec-a1c2-42010a380a1b",
			  value: "false",
			  name: "globals.forceUpdateRequiredForNewSailorApp",
			  dataType: "string",
			  yamlKey: "globals.forceUpdateRequiredForNewSailorApp",
			  valueWithPlaceholder: "$FORCE_UPDATE_REQUIRED$",
			  isConstant: false)
	}
    
    static func sampleWithMinVersion() -> ComponentSettings {
        .init(id: "aa7c8864-0a21-11ec-a1c2-42010a380a1b",
              value: "1.0.0",
              name: "globals.minimumVersionForNewSailorAppiOS",
              dataType: "string",
              yamlKey: "globals.minimumVersionForNewSailorAppiOS",
              valueWithPlaceholder: "$FORCE_UPDATE_REQUIRED$",
              isConstant: false)
    }
    
}

extension ComponentSettings {
	func copy(
		id: String? = nil,
		value: String? = nil,
		name: String? = nil,
		dataType: String? = nil,
		yamlKey: String? = nil,
		valueWithPlaceholder: String? = nil,
		isConstant: Bool? = nil
	) -> ComponentSettings {
		return ComponentSettings(
			id: id ?? self.id,
			value: value ?? self.value,
			name: name ?? self.name,
			dataType: dataType ?? self.dataType,
			yamlKey: yamlKey ?? self.yamlKey,
			valueWithPlaceholder: valueWithPlaceholder ?? self.valueWithPlaceholder,
			isConstant: isConstant ?? self.isConstant
		)
	}
}
