//
//  ShipCode.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 11/24/23.
//

import Foundation

enum CruiseShip: String, Codable, CaseIterable, Identifiable, Hashable {
	case scarlet = "SC"
	case valiant = "VL"
	case resilient = "RS"
	case brilliant = "BR"
	case placeholder = "XE"
	case vpn = "VPN"
	case any = "ANY"
	
	static let ships: [CruiseShip] = [.scarlet, .valiant, .resilient]
	
	var name: String {
		switch self {
		case .scarlet: "Scarlet Lady"
		case .valiant: "Valiant Lady"
		case .resilient: "Resilient Lady"
		case .brilliant: "Brilliant Lady"
		case .vpn: "VPN"
		case .placeholder: "Placeholder"
		case .any: "Ship"
		}
	}
	
	var domain: String {
		switch self {
		case .scarlet: "scl"
		case .valiant: "val"
		case .resilient: "res"
		case .vpn: ""
		case .brilliant: ""
		case .placeholder: ""
		case .any: ""
		}
	}
	
	var hostName: String {
		if self == .vpn {
			return "certmobile.ship.virginvoyages.com"
		}

		return "mobile.ship.virginvoyages.com"
	}
	
	var chatName: String {
		"chat.\(domain).virginvoyages.com"
	}
	
	var id: String {
		name
	}
}

// Time zone

extension TimeZone {
	enum City: Int, CustomStringConvertible {
		case bakerIsland = -1200
		case pagoPago = -1100
		case honolulu = -1000
		case anchorage = -900
		case losAngeles = -800
		case denver = -700
		case chicago = -600
		case newYork = -500
		case caracas = -400
		case buenosAires = -300
		case southGeorgia = -200
		case azores = -100
		case london = 0
		case paris = 100
		case istanbul = 200
		case moscow = 300
		case tehran = 350
		case dubai = 400
		case kabul = 450
		case karachi = 500
		case kolkata = 550
		case kathmandu = 575
		case almaty = 600
		case yangon = 650
		case bangkok = 700
		case singapore = 800
		case tokyo = 900
		case adelaide = 950
		case sydney = 1000
		case norfolkIsland = 1050
		case honiara = 1100
		case noumea = 1150
		case suva = 1200
		case chathamIslands = 1275
		case apia = 1300
		case kiritimati = 1400
		
		var description: String {
			switch self {
			case .bakerIsland: return "Baker Island"
			case .pagoPago: return "Pago Pago"
			case .honolulu: return "Honolulu"
			case .anchorage: return "Anchorage"
			case .losAngeles: return "Los Angeles"
			case .denver: return "Denver"
			case .chicago: return "Chicago"
			case .newYork: return "New York"
			case .caracas: return "Caracas"
			case .buenosAires: return "Buenos Aires"
			case .southGeorgia: return "South Georgia"
			case .azores: return "Azores"
			case .london: return "London"
			case .paris: return "Paris"
			case .istanbul: return "Istanbul"
			case .moscow: return "Moscow"
			case .tehran: return "Tehran"
			case .dubai: return "Dubai"
			case .kabul: return "Kabul"
			case .karachi: return "Karachi"
			case .kolkata: return "Kolkata"
			case .kathmandu: return "Kathmandu"
			case .almaty: return "Almaty"
			case .yangon: return "Yangon"
			case .bangkok: return "Bangkok"
			case .singapore: return "Singapore"
			case .tokyo: return "Tokyo"
			case .adelaide: return "Adelaide"
			case .sydney: return "Sydney"
			case .norfolkIsland: return "Norfolk Island"
			case .honiara: return "Honiara"
			case .noumea: return "Noumea"
			case .suva: return "Suva"
			case .chathamIslands: return "Chatham Islands"
			case .apia: return "Apia"
			case .kiritimati: return "Kiritimati"
			}
		}
	}
	
	var cityName: String? {
		let value = secondsFromGMT() / Int(36)
		return City(rawValue: value)?.description
	}
}
