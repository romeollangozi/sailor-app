//
//  VisaTypePicker.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 7/9/24.
//

import SwiftUI

extension Endpoint.GetLookupData.Response.LookupData.VisaType: Identifiable {
	var id: String {
		"\(code) \(countryCode)"
	}
}
