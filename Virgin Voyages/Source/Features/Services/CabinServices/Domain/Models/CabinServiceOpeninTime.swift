//
//  CabinServiceOpeninTime.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 3.5.25.
//

struct CabinServiceOpeninTime {
	public let imageURL: String
	public var title: String
	public let subtitle: String
}


extension CabinServiceOpeninTime {
	public static func empty() -> CabinServiceOpeninTime {
		return CabinServiceOpeninTime(
			imageURL: "",
			title: "",
			subtitle: ""
		)
	}
}

extension CabinServiceOpeninTime {
	public static func sample() -> CabinServiceOpeninTime {
		return CabinServiceOpeninTime(
			imageURL: "https://cert.gcpshore.virginvoyages.com/dam/jcr:0079cb42-cb31-4677-985c-1d401e2f206d/Cabin_Services_464x464.jpg",
			title: "Making your cabin... ",
			subtitle: "Once you’re on board, come back here for all your cabin wants and needs."
		)
	}
}
