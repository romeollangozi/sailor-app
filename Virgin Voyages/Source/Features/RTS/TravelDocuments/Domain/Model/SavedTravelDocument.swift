//
//  SavedTravelDocument.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 18.3.25.
//

struct SavedTravelDocument: Equatable, Hashable {
	let identificationId: String
    let hasPostVoyagePlans: Bool
}

extension SavedTravelDocument {
	static func sample() -> SavedTravelDocument {
        return SavedTravelDocument(identificationId: "2b7eb5cd-1614-4b66-ab43-d18c1a2f5a00", hasPostVoyagePlans: true)
	}
}

extension SavedTravelDocument {
	static func empty() -> SavedTravelDocument {
        return SavedTravelDocument(identificationId: "", hasPostVoyagePlans: false)
	}
}

