//
//  ShoreThingDetailsScreen.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 15.5.25.
//

import SwiftUI
import VVUIKit

protocol ShoreThingDetailsScreenViewModelProtocol {
	var screenState: ScreenState { get set }
	var shoreThingItem: ShoreThingItem {get}
	var bookingSheetViewModel: BookingSheetViewModel? { get }
	var showPreVoyageBookingStopped: Bool { get set }
	var showBookEventSheet: Bool { get set }
    var ctaTitle: String { get }
    var isBookAvailable: Bool { get }
    
	func onAppear()
	func onRefresh()
	func onPurchaseTapped()
	func onContactSupportTapped()
}

struct ShoreThingDetailsScreen : View {
	// MARK: - ViewModel
	@State private var viewModel: ShoreThingDetailsScreenViewModelProtocol
	private let onBackClick: VoidCallback?
	private let onAppointmentTapped: ((String) -> Void)?

	// MARK: - Init
	init(viewModel: ShoreThingDetailsScreenViewModelProtocol,
		 onBackClick: VoidCallback? = nil,
		 onAppointmentTapped: ((String) -> Void)? = nil) {
		_viewModel = State(wrappedValue: viewModel)
		self.onBackClick = onBackClick
		self.onAppointmentTapped = onAppointmentTapped
	}

	var body: some View {
		DefaultScreenView(state: $viewModel.screenState) {
			ZStack(alignment: .top) {
				ScrollView(.vertical) {
					VStack(spacing: Spacing.space0) {
						header()
						
						titleAndInfo()
						
						content()
						
						if !viewModel.shoreThingItem.needToKnows.isEmpty {
							needToKnowsView()
						}
						
						if let url = viewModel.shoreThingItem.editorialBlocks.count > 0
							? viewModel.shoreThingItem.editorialBlocks[0]
							: nil {
							policiesView(url: url)
						}
						
						contactView()
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
		.sheet(isPresented: $viewModel.showBookEventSheet) {
			if let bookingSheetViewModel = viewModel.bookingSheetViewModel {
				BookingSheetFlow(isPresented: $viewModel.showBookEventSheet, bookingSheetViewModel: bookingSheetViewModel)
			}
		}
		.sheet(isPresented: $viewModel.showPreVoyageBookingStopped) {
			PreVoyageEditingModal {
				viewModel.showPreVoyageBookingStopped = false
			}
		}
		.background(Color.white)
		.ignoresSafeArea(edges: [.top])
		.navigationTitle("")
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItem(placement: .bottomBar) {
				purchaseButton()
					.background(Color.white)
			}
		}
		.toolbarBackground(.white, for: .bottomBar)
	}

	private func toolbar() -> some View {
		HStack(alignment: .top) {
			BackButton({onBackClick?()})
                .padding(.leading, Spacing.space32)
				.padding(.top, Spacing.space32)
			Spacer()
		}
	}
	
	private func header() -> some View {
		BookableHeader(imageUrl: viewModel.shoreThingItem.imageUrl,
					   inventoryState: viewModel.shoreThingItem.inventoryState,
					   slot: viewModel.shoreThingItem.selectedSlot,
					   appointments: viewModel.shoreThingItem.appointments,
					   priceFormatted: viewModel.shoreThingItem.priceFormatted,
					   heightRatio: 0.6,
					   onAppointmentTapped: onAppointmentTapped)
	}
	
	private func titleAndInfo() -> some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading, spacing: Spacing.space16) {
				Text(viewModel.shoreThingItem.name)
					.font(.vvHeading1Bold)
				
				VStack(alignment: .leading, spacing: Spacing.space8) {
					if let selectedSlot = viewModel.shoreThingItem.selectedSlot {
						HStack(spacing: Spacing.space8) {
							Image("Calendar")
							Text(selectedSlot.startDateTime.toDayMonthDayTime())
								.font(.vvHeading5)
								.foregroundColor(.blackText)
						}
					}
					
					HStack(spacing: Spacing.space8) {
						Image("Location")
						Text(viewModel.shoreThingItem.location)
							.font(.vvHeading5)
							.foregroundColor(.blackText)
					}
				}
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(Spacing.space24)
		}
		.frame(maxWidth: .infinity)
		.background(Color.softGray)
	}
	
	private func content() -> some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading, spacing: Spacing.space24) {
				VStack(alignment: .leading, spacing: Spacing.space16) {
					Text(viewModel.shoreThingItem.introduction)
						.font(.vvHeading3Light)
						.foregroundColor(Color.slateGray)
					
					HTMLText(htmlString: viewModel.shoreThingItem.longDescription,
							 fontType: FontType.normal,
							 fontSize: FontSize.size16,
							 color: Color.slateGray)
				}
				
				Divider()
				
				moreInfoView()
				
				if !viewModel.shoreThingItem.tourDifferentiators.isEmpty {
					Divider()
					
					tourDifferentiatorView()
				}
				
				if !viewModel.shoreThingItem.highlights.isEmpty {
					
					Divider()
					
					highlightsView()
				}
			}.padding(Spacing.space24)
		}.background(Color.white)
	}
	
	private func moreInfoView() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space14) {
			VStack(alignment: .leading) {
				Text("Duration")
					.textCase(.uppercase)
					.font(.vvSmallBold)
					.foregroundColor(Color.slateGray)
				
				Text(viewModel.shoreThingItem.duration)
					.font(.vvBody)
					.foregroundColor(Color.slateGray)
			}
		
			
			if viewModel.shoreThingItem.types.count > 0 {
				VStack(alignment: .leading, spacing: Spacing.space0) {
					Text("Type")
						.textCase(.uppercase)
						.font(.vvSmallBold)
						.foregroundColor(Color.slateGray)
					
					Text(viewModel.shoreThingItem.types.joined(separator: ", "))
						.font(.vvBody)
						.foregroundColor(Color.slateGray)
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}
	
	private func tourDifferentiatorView() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space16) {
			ForEach(viewModel.shoreThingItem.tourDifferentiators) { tourDifferentiator in
				HStack(alignment: .top, spacing: Spacing.space16) {
					if let imageURL = URL(string: tourDifferentiator.imageUrl) {
						ProgressImage(url: imageURL)
							.frame(width: 48, height: 48)
					}
					
					VStack(alignment: .leading, spacing: Spacing.space8) {
						Text(tourDifferentiator.name)
							.font(.vvHeading5Bold)
							.foregroundColor(.blackText)
							.multilineTextAlignment(.leading)

						Text(tourDifferentiator.description)
							.font(.vvHeading5)
							.foregroundColor(.slateGray)
							.multilineTextAlignment(.leading)
					}
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}
	
	private func highlightsView() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space16) {
			Text("Highlights")
				.font(.vvHeading3Bold)
				.foregroundStyle(Color.blackText)
			
			ForEach(viewModel.shoreThingItem.highlights, id: \.self) { item in
				HStack(alignment: .top, spacing: Spacing.space16) {
					Image(systemName: "checkmark")
						.resizable()
						.frame(width: 16, height: 16)
						.foregroundColor(Color.aquaBlue)
											
					Text(item)
						.fontStyle(.lightBody)
						.foregroundColor(.lightGreyColor)
						.multilineTextAlignment(.leading)
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}
	
	private func needToKnowsView() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space16) {
			Text("Need to know")
				.font(.vvHeading3Bold)
				.foregroundStyle(Color.blackText)
			
			ForEach(viewModel.shoreThingItem.needToKnows, id: \.self) { item in
				HStack(alignment: .top, spacing: Spacing.space16) {
					Image("NeedToKnow")
						.resizable()
						.frame(width: Sizes.defaultSize24, height: Sizes.defaultSize24)
						.aspectRatio(contentMode: .fit)
					
					Text(item)
						.fontStyle(.lightBody)
						.foregroundColor(.lightGreyColor)
						.multilineTextAlignment(.leading)
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(Spacing.space24)
		.background(Color.softGray)
	}
	
	private func policiesView(url: String) -> some View {
		VStack(spacing: Spacing.space0) {
			if let url = URL(string: url) {
				VVWebLinkView(url: url)
					.frame(height: 500)
					.edgesIgnoringSafeArea(.all)
			}
		}
	}
	
	private func contactView() -> some View {
		VStack(alignment: .center, spacing: Spacing.space16) {
			Text("Any questions?")
				.font(.vvHeading5Bold)
				.foregroundStyle(Color.blackText)
			
			Text("If you have any questions about this, or Shore Things in general, give us a shout.")
				.font(.vvBody)
				.foregroundStyle(Color.slateGray)
			
			SecondaryButton("Contact Sailor Services") {
				viewModel.onContactSupportTapped()
			}
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.padding(Spacing.space24)
		.background(Color.softGray)
	}
	
	private func purchaseButton() -> some View {
		LoadingButton(title: viewModel.ctaTitle, loading: false) {
			viewModel.onPurchaseTapped()
		}
        .disabled(!viewModel.isBookAvailable)
		.buttonStyle(PrimaryButtonStyle())
		.padding(.bottom, Spacing.space24)
	}
}

#Preview("Shore things details") {
	let item: ShoreThingItem = .sample()
		.copy(
			types: ["RELAXING"]
		)
	
	ShoreThingDetailsScreen(viewModel: ShoreThingDetailsScreenPreviewViewModel(shoreThingItem: item))
}

final class  ShoreThingDetailsScreenPreviewViewModel: ShoreThingDetailsScreenViewModelProtocol {
	
	var screenState: ScreenState = .content
	var shoreThingItem: ShoreThingItem
	var bookingSheetViewModel: BookingSheetViewModel? = nil
	var showPreVoyageBookingStopped: Bool = false
	var showBookEventSheet: Bool = false
    var ctaTitle: String = "Book"
    var isBookAvailable: Bool = true

	init(shoreThingItem: ShoreThingItem = .sample()) {
		self.shoreThingItem = shoreThingItem
	}
	
	func onAppear() {
		
	}
	
	func onRefresh() {
		
	}
	
	func onPurchaseTapped() {
		
	}
	
	func onContactSupportTapped() {
		
	}
}
