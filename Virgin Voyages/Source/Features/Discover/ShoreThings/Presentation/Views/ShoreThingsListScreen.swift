//
//  ShoreThingsListScreen.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 15.5.25.
//

import SwiftUI
import VVUIKit

protocol ShoreThingsListScreenViewModelProtocol {
	var screenState: ScreenState { get set }
	var shoreThingsList: ShoreThingsList {get}
	var selectedType: ShoreThingsListType? {get set}
	var searchableItems: [ShoreThingItem] {get}
	
	func onAppear()
	func onRefresh()
	func onTypeTapped(_ type: ShoreThingsListType)
	func getExcursionsText() -> String
}

struct ShoreThingsListScreen : View {
	// MARK: - ViewModel
	@State private var viewModel: ShoreThingsListScreenViewModelProtocol
	private let onBackClick: VoidCallback?
	private let onViewDetails: ((ShoreThingItem) -> Void)?
	private let onAppointmentTapped: ((String) -> Void)?

	// MARK: - Init
	init(viewModel: ShoreThingsListScreenViewModelProtocol,
		 onBackClick: VoidCallback? = nil,
		 onViewDetails: ((ShoreThingItem) -> Void)? = nil,
	     onAppointmentTapped: ((String) -> Void)? = nil) {
		_viewModel = State(wrappedValue: viewModel)
		
		self.onBackClick = onBackClick
		self.onViewDetails = onViewDetails
		self.onAppointmentTapped = onAppointmentTapped
	}

	var body: some View {
		DefaultScreenView(state: $viewModel.screenState) {
			ZStack(alignment: .top) {
				ScrollView(.vertical) {
					VStack {
						header()
						
						ZStack(alignment: .top) {
							excursions()
								.padding(.top, Spacing.space32)
							
							types()
								.padding(.horizontal, Spacing.space8)
						}
					}
				}
				toolbar()
					.padding(.top, Spacing.space24)
			}
		} onRefresh: {
			viewModel.onRefresh()
		}
		.onAppear {
			viewModel.onAppear()
		}
		.background(Color.softGray)
		.ignoresSafeArea(edges: [.top])
		.navigationTitle("")
		.navigationBarBackButtonHidden(true)
	}

	private func toolbar() -> some View {
		HStack(alignment: .top) {
			BackButton({onBackClick?()})
				.padding(.leading, Spacing.space16)
				.padding(.top, Spacing.space32)
			
			Spacer()
		}
	}
	
	private func header() -> some View {
		VStack(alignment: .center, spacing: Spacing.space8) {
			Text(viewModel.shoreThingsList.title)
				.font(.vvHeading1Bold)
				.foregroundColor(.blackText)
				.multilineTextAlignment(.center)
			
			HTMLText(htmlString: viewModel.shoreThingsList.description,
					 fontType: FontType.normal,
					 fontSize: FontSize.size18,
					 color: Color.slateGray)
		}
		.padding(.top, Spacing.space88)
		.padding(.horizontal, Spacing.space24)
	}
	
	private func types() -> some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack {
				ForEach(viewModel.shoreThingsList.types, id:\.code) { item in
					createTypeButton(item: item)
				}
			}.padding(Spacing.space8)
		}
	}
	
	private func excursions() -> some View {
		VStack(alignment:.leading) {
			VStack(spacing: Spacing.space24) {
				Text(viewModel.getExcursionsText())
					.font(.vvSmallBold)
					.foregroundColor(Color.slateGray)
					.textCase(.uppercase)
				
				if viewModel.searchableItems.isEmpty {
					noResults()
				} else {
					VStack(alignment: .leading, spacing: Spacing.space24) {
						ForEach(viewModel.searchableItems) { item in
							Button(action: {
								onViewDetails?(item)
							}) {
								excursionCard(item: item)
							}
						}
					}
				}
			}
			.padding(.top, Spacing.space32)
			.padding(Spacing.space24)
		}.background(Color.white)
	}
	
	private func excursionCard(item: ShoreThingItem) -> some View {
		VStack(alignment: .leading, spacing: 0) {
			ZStack(alignment: .topTrailing) {
				BookableHeader(imageUrl: item.imageUrl,
							   inventoryState: item.inventoryState,
							   slot: item.selectedSlot,
							   appointments: item.appointments,
							   priceFormatted: item.priceFormatted,
							   heightRatio: 0.6,
							   onAppointmentTapped: onAppointmentTapped)
				
				if item.tourDifferentiators.count > 0 {
					HStack(spacing: Spacing.space8) {
						ForEach(item.tourDifferentiators) { item in
							if let imageURL = URL(string: item.imageUrl) {
								ProgressImage(url: imageURL)
									.frame(width: 32, height: 32)
							}
						}
					}.padding(Spacing.space8)
				}
			}
			
			
			VStack(alignment: .leading, spacing: Spacing.space16) {
				if item.types.count > 0 {
					Text(item.types.joined(separator: ", "))
						.font(.vvCaptionBold)
						.foregroundColor(Color.deepPurple)
						.textCase(.uppercase)
				}
				
				Text(item.name)
					.font(.vvHeading5Bold)
					.foregroundColor(Color.blackText)
					.multilineTextAlignment(.leading)
				
				if !item.shortDescription.isEmpty {
					Text(item.shortDescription)
						.font(.vvSmall)
						.foregroundColor(Color.slateGray)
				}
			}
			.padding(Spacing.space16)
			
			Divider()
			
			VStack(alignment: .leading) {
				Text(item.duration)
					.font(.vvSmall)
					.foregroundColor(Color.slateGray)
			}
			.padding(Spacing.space16)
		}
		.background(Color.white)
		.cardify()
	}
	
	private func noResults() -> some View {
		VStack(spacing: Spacing.space8) {
			VStack(spacing: Spacing.space16) {
				Image("clearPastVoyages")
					.resizable()
					.frame(width: 160, height: 168)
				
				Text("Oops…")
					.font(.vvHeading1Bold)
					.foregroundColor(.charcoalBlack)
					.multilineTextAlignment(.center)
				
				HStack {
					Text("Why not continue your search by selecting another category or browse another Port.")
						.font(.vvBody)
						.foregroundColor(.slateGray)
				}
			}
			.frame(maxWidth: .infinity, alignment: .center)
			.padding(Spacing.space24)
		}.background(Color.white)
	}
	
	private func createTypeButton(item: ShoreThingsListType) -> some View {
		if viewModel.selectedType == item {
			return AnyView(
				CapsulePrimaryButton(item.name) {
					viewModel.onTypeTapped(item)
				}
			)
		} else {
			return AnyView(
				CapsuleSecondaryButton(item.name) {
					viewModel.onTypeTapped(item)
				}
			)
		}
	}
}

#Preview("Shore things listing") {
	ShoreThingsListScreen(viewModel: ShoreThingsListScreenPreviewViewModel())
}

final class ShoreThingsListScreenPreviewViewModel: ShoreThingsListScreenViewModelProtocol {
	var screenState: ScreenState = .content
	var shoreThingsList: ShoreThingsList
	var searchableItems: [ShoreThingItem]
	var selectedType: ShoreThingsListType? = nil
	
	init(shoreThingsList: ShoreThingsList = .samplewithMultipleExcursions()) {
		self.shoreThingsList = shoreThingsList
		self.searchableItems = shoreThingsList.items
	}
	
	func onAppear() {
		
	}
	
	func onRefresh() {
		
	}

	func onTypeTapped(_ type: ShoreThingsListType) {
		
	}
	
	func getExcursionsText() -> String {
		"\(searchableItems.count) excursions"
	}
}
