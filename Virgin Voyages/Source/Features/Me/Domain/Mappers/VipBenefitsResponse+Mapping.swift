//
//  VipBenefitsResponse+Mappings.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 4.3.25.
//

extension VipBenefitsResponse {
	func toDomain() -> VipBenefits {
		let benefits = (self.benefits ?? []).compactMap { benefit in
			return VipBenefits.Benefit(
				sequence: benefit.sequence.value,
				iconUrl: benefit.iconUrl.value,
				summary: benefit.summary.value
			)
		}
		return VipBenefits(benefits: benefits, supportEmailAddress: self.supportEmailAddress.value)
	}
}
