//
//  BookableHeader.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 15.5.25.
//

import SwiftUI
import VVUIKit

struct BookableHeader : View {
	let imageUrl: String
	let inventoryState: InventoryState
	let slot: Slot?
	let appointments: Appointments?
	let priceFormatted: String?
	let heightRatio: CGFloat
	let onAppointmentTapped: ((String) -> Void)?
	
	init(imageUrl: String,
		 inventoryState: InventoryState,
		 slot: Slot? = nil,
		 appointments: Appointments? = nil,
		 priceFormatted: String? = nil,
		 heightRatio: CGFloat = 0.8,
		 onAppointmentTapped: ((String) -> Void)? = nil) {
		self.imageUrl = imageUrl
		self.inventoryState = inventoryState
		self.slot = slot
		self.appointments = appointments
		self.priceFormatted = priceFormatted
		self.heightRatio = heightRatio
		self.onAppointmentTapped = onAppointmentTapped
	}
	
	var body: some View {
		VStack(alignment:.leading, spacing: Spacing.space0) {
			ZStack(alignment: .bottomLeading) {
				imageView()
				
				statusView()
			}.padding(Spacing.space0)
			
			appointmentsView()
		}
	}
	
	private func imageView() -> some View {
		VStack(spacing: Spacing.space0) {
			if let url = URL(string: imageUrl) {
				FlexibleProgressImage(url: url, heightRatio: heightRatio)
					.grayscale(slot?.status != SlotStatus.available ? 1.0 : 0.0)
			} else {
				Color.gray
					.frame(maxWidth: .infinity)
			}
		}.padding(Spacing.space0)
	}
	
	private func statusView() -> some View {
		VStack(spacing: Spacing.space0) {
			if let price = priceFormatted, !price.isEmpty {
				let style = slot?.status == .available ? MessageBarStyle.Purple : MessageBarStyle.Dark
				let text = slot?.status == .available || (slot?.statusText?.isEmpty ?? true)
					? price
					: "\(price) | \(slot!.statusText!)"
				let fullWidth = slot?.status != .available
				MessageBar(style: style, text: text, fullWidht: fullWidth)
			} else if slot?.status != .available {
				if let selectedSlotStatusText = slot?.statusText {
					MessageBar(
						style: MessageBarStyle.Dark,
						text: selectedSlotStatusText
					)
				}
			}
		}.padding(Spacing.space0)
	}
	
	private func appointmentsView() -> some View {
		VStack(spacing: Spacing.space0) {
			if let appointments = appointments, appointments.items.count > 0 {
				let style = inventoryState == .nonInventoried
					? MessageBarStyle.Info
					: MessageBarStyle.Success
				
				if appointments.items.count == 1 {
					MessageBar(style: style, text: appointments.items[0].bannerText)
						.onTapGesture {
							onAppointmentTapped?(appointments.items[0].id)
						}
				} else {
					VStack(spacing: Spacing.space0) {
						MessageBar(style: style, text: appointments.bannerText)
						
						ForEach(appointments.items, id: \.id) { item in
							MessageBar(style: style, text: item.bannerText)
								.onTapGesture {
									onAppointmentTapped?(item.id)
								}
						}
					}
				}
			}
		}.padding(Spacing.space0)
	}
}

#Preview("Bookable header") {
	ScrollView {
		VStack(spacing: Spacing.space24) {
			BookableHeader(imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:e8d4e2c7-c384-4c52-a55b-82de0ee58eae/Embarkation%20Image_Hero_1200x800.png",
						   inventoryState: .nonInventoried,
						   slot: Slot.sample().copy(status: .available),
						   priceFormatted: nil,
						   heightRatio: 0.5)
			
			BookableHeader(imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:e8d4e2c7-c384-4c52-a55b-82de0ee58eae/Embarkation%20Image_Hero_1200x800.png",
						   inventoryState: .paidInventoried,
						   slot: Slot.sample().copy(status: .available),
						   priceFormatted: "$10",
						   heightRatio: 0.5)
			
			BookableHeader(imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:e8d4e2c7-c384-4c52-a55b-82de0ee58eae/Embarkation%20Image_Hero_1200x800.png",
						   inventoryState: .paidInventoried,
						   slot: Slot.sample().copy(status: .available),
						   appointments: Appointments.sample().copy(items: [.sample()]),
						   priceFormatted: "$10",
						   heightRatio: 0.5)
			
			BookableHeader(imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:e8d4e2c7-c384-4c52-a55b-82de0ee58eae/Embarkation%20Image_Hero_1200x800.png",
						   inventoryState: .nonInventoried,
						   slot: Slot.sample().copy(status: .soldOut),
						   priceFormatted: "$10",
						   heightRatio: 0.5)
			
			BookableHeader(imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:e8d4e2c7-c384-4c52-a55b-82de0ee58eae/Embarkation%20Image_Hero_1200x800.png",
						   inventoryState: .paidInventoried,
						   slot: Slot.sample().copy(status: .soldOut),
						   appointments: Appointments.sample().copy(items: [.sample()]),
						   priceFormatted: "$10",
						   heightRatio: 0.5)
			
			BookableHeader(imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:e8d4e2c7-c384-4c52-a55b-82de0ee58eae/Embarkation%20Image_Hero_1200x800.png",
						   inventoryState: .paidInventoried,
						   slot: Slot.sample().copy(status: .closed),
						   priceFormatted: "$10",
						   heightRatio: 0.5)
			
			BookableHeader(imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:e8d4e2c7-c384-4c52-a55b-82de0ee58eae/Embarkation%20Image_Hero_1200x800.png",
						   inventoryState: .paidInventoried,
						   slot: Slot.sample().copy(status: .closed),
						   appointments: Appointments.sample().copy(items: [.sample()]),
						   priceFormatted: "$10",
						   heightRatio: 0.5)
		}.padding(Spacing.space16)
	}
}
