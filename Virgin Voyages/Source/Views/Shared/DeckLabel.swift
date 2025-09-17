//
//  DeckLabel.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/22/24.
//

import SwiftUI
import VVUIKit

struct DeckLabel: View {
	var imageUrl: URL?
	var deckLocation: String
    var body: some View {
		HStack(spacing: 0) {
			if let imageUrl {
				ProgressImage(url: imageUrl)
					.frame(width: 60, height: 60)
			}
			
			VStack(spacing: 0) {
				Text(deckArea)
					.fontStyle(.subheadline)
					.foregroundStyle(.secondary)
					.multilineTextAlignment(.center)
				Text(deckNumber)
					.fontStyle(.title)
					.foregroundStyle(.primary)
			}
			.frame(width: 60, height: 60)
			.tint(.primary)
			.background(Color(uiColor: .systemGray6))
		}
		.cornerRadius(6)
    }
	
	private var deckNumber: String {
		deckLocation.components(separatedBy: " ").dropFirst().first ?? ""
	}
	
	private var deckArea: String {
		let deck = deckLocation.components(separatedBy: " ").dropFirst().dropFirst().joined(separator: " ")
		return deck == "" ? "Deck" : deck
	}
}

#Preview {
    DeckLabel(deckLocation: "Deck 7 Aft")
}
