//
//  DependentsSection.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/11/24.
//

import Foundation

class DependentsSection {
	var completedPaymentDependentDescription: String
	var dependentTitle: String
	var pendingPaymentDependentDescription: String

	init(completedPaymentDependentDescription: String, dependentTitle: String, pendingPaymentDependentDescription: String) {
		self.completedPaymentDependentDescription = completedPaymentDependentDescription
		self.dependentTitle = dependentTitle
		self.pendingPaymentDependentDescription = pendingPaymentDependentDescription
	}
}
