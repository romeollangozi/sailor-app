//
//  HomeComingGuideScreen.swift
//  Virgin Voyages
//
//  Created by Pajtim on 2.4.25.
//

import SwiftUI
import VVUIKit

protocol HomeComingGuideScreenViewModelProtocol {
	var screenState: ScreenState { get set }
	var homeComingGuide: HomeComingGuide {get}
	var eateriesWithSlots : EateriesSlots {get}
	var eateriesList: EateriesList  {get}
	var isEateriesSlotsLoading: Bool {get}
	var showSlotBookSheet: Bool {get set}
	var showEditSlotBookSheet: Bool {get set}
    var showSoldOutSheet: Bool { get set }

	var filter: EateriesSlotsInputModel {get set}
	var isEateriesListLoading: Bool {get}
	var newBookingViewModel: EaterySlotBookViewModel? {get}
	var editBookingViewModel: EditBookingSheetViewModel? {get}
	var errorOnLoadingSlots: Bool { get }
    var infoDrawerModel: InfoDrawerModel { get }

	func onViewWalletClick()
	func onFirstAppear()
	func onReAppear()
	func onRefresh()
	func onBackClick()
	
	func onEateryClick(eatery: EateriesList.Eatery)
	
	func onSlotClick(eatery: EateriesSlots.Restaurant, slot: Slot)
	func onBookCompleted()
	func onSlotBookSheetDismissed()
	
	func onEditEateryWithSlotsButtonClick(eatery: EateriesSlots.Restaurant)
	func onEditBookingCompleted()
	func onEditBookingSheetDismissed()
	func onBookingCanceled()
    func onReadMoreClick(eatery: EateriesSlots.Restaurant)
    func onReadMoreDismiss()
}

struct HomeComingGuideScreen: View {
	@State var viewModel: HomeComingGuideScreenViewModelProtocol
	
	init(viewModel: HomeComingGuideScreenViewModelProtocol = HomeComingGuideScreenViewModel()) {
		_viewModel = State(wrappedValue: viewModel)
	}
	
	var body: some View {
		DefaultScreenView(state: $viewModel.screenState) {
			VStack(alignment: .leading, spacing: Spacing.space24) {
				ScrollView {
					header()
					
					DoubleDivider()
					
					sections()
					
					HStack {
						Button("View my wallet") {
							viewModel.onViewWalletClick()
						}
						.buttonStyle(TertiaryButtonStyle(.flexible))
						Spacer()
					}
					.frame(maxWidth: .infinity, alignment: .leading)
				}
			}.sheet(isPresented: $viewModel.showSlotBookSheet) {
				if let newBookingViewModel = viewModel.newBookingViewModel {
					EaterySlotBookSheet(viewModel: newBookingViewModel,
					onBooked: {
						viewModel.onBookCompleted()
					}, onCancelClick: {
						viewModel.onSlotBookSheetDismissed()
					})
				}
			}.sheet(isPresented: $viewModel.showEditSlotBookSheet) {
				if let editBookingViewModel = viewModel.editBookingViewModel {
					EditEateryBookingSheet(viewModel: editBookingViewModel,
										   onBooked: {
						viewModel.onEditBookingCompleted()
					},
										   onDismiss: {
						viewModel.onEditBookingSheetDismissed()
					},
										   onCanceled: {
						viewModel.onBookingCanceled()
					})
				}
			}
            .sheet(isPresented: $viewModel.showSoldOutSheet) {
                InfoDrawerView(
                    title: viewModel.infoDrawerModel.title,
                    description: viewModel.infoDrawerModel.description,
                    buttonTitle: viewModel.infoDrawerModel.buttonTitle) {
                    viewModel.onReadMoreDismiss()
                }
                .presentationDetents([.height(450)])
            }
		} onRefresh: {
			viewModel.onRefresh()
		}
		.onAppear(onFirstAppear: {
			viewModel.onFirstAppear()
		}, onReAppear: {
			viewModel.onReAppear()
		})
	}
	
	private func header() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space24) {
			
			BackButton {
				viewModel.onBackClick()
			}
			.padding(.horizontal, Spacing.space24)
			
			VStack(alignment: .leading) {
				Text(viewModel.homeComingGuide.header.title)
					.font(.vvHeading1Bold)
				
				Text(viewModel.homeComingGuide.header.description)
					.font(.vvHeading5)
					.foregroundStyle(Color.slateGray)
			}
			.padding(.horizontal, Spacing.space24)
			
			VStack(alignment: .leading, spacing: Spacing.space24) {
				AuthURLImageView(imageUrl: viewModel.homeComingGuide.header.bannerImageUrl)
					.background(Color.lightGray)
					.frame(maxWidth: .infinity, minHeight: 240)
				
				HStack(spacing: Spacing.space40) {
					VStack(alignment: .leading) {
						Text("WHERE")
							.font(.vvSmallBold)
							.foregroundStyle(Color.slateGray)
							.kerning(1.4)
						
						Text(viewModel.homeComingGuide.header.deck)
							.font(.vvHeading3Bold)
					}
					
					VStack(alignment: .leading) {
						Text("WHEN")
							.font(.vvSmallBold)
							.foregroundStyle(Color.slateGray)
							.kerning(1.4)
						
						Text(viewModel.homeComingGuide.header.time)
							.font(.vvHeading3Bold)
					}
				}
				
				HStack(spacing: Spacing.space16) {
					Image(.clockIcon)
						.resizable()
						.frame(width: 32, height: 32, alignment: .leading)
					
					HTMLText(htmlString: viewModel.homeComingGuide.header.queueDescription, fontType: .medium, fontSize: .size14, color: Color.slateGray)
				}
			}
			.padding(.horizontal, Spacing.space16)
		}
		.padding(.bottom, Spacing.space32)
	}
	
	private func sections() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space24) {
			ForEach(Array(viewModel.homeComingGuide.sections.enumerated()), id: \.element.id) { index, section in
				AuthURLImageView(imageUrl: section.bannerImageUrl ?? "")
					.background(Color.lightGray)
					.frame(maxWidth: .infinity, minHeight: 240)
				
				VStack(alignment: .leading, spacing: Spacing.space8) {
					Text(section.title)
						.font(.vvHeading5Bold)
					
					if let subtitle = section.subtitle {
						HTMLText(htmlString: subtitle, fontType: .bold, fontSize: .size14, color: Color.blackText)
					}
                    HTMLText(htmlString: section.description, fontType: .normal, fontSize: .size14, color: Color.slateGray)
				}
				
				if index == 1 {
					eaterySection()
				}
				
				if section != viewModel.homeComingGuide.sections.last {
					Divider()
						.background(Color.iconGray)
						.frame(height: 1)
				}
			}
		}
		.padding(Spacing.space16)
	}
	
	private func eaterySection() -> some View {
		LoaderWrapper(isLoading: viewModel.isEateriesListLoading) {
			VStack (alignment: .leading, spacing: Spacing.space16) {
				bookables()
				
				walkIns()
			}
		}	
	}
	
	private func bookables() -> some View {
		VStack(alignment:.leading, spacing: Spacing.space16) {
			Text("Booking advised")
				.font(.vvBodyBold)
				.foregroundColor(.blackText)
				.multilineTextAlignment(.center)
			
			VStack(spacing: Spacing.space16) {
				ForEach(viewModel.eateriesList.bookable, id: \.id) { bookable in
					Card(title: bookable.name, imageUrl: bookable.squareThumbnailUrl, subheading: bookable.subHeading,
						 onTap : { viewModel.onEateryClick(eatery: bookable) },
						 footer: { eateryWithSlots(externalId: bookable.externalId, venueId: bookable.venueId) })
				}.padding(.horizontal, Paddings.defaultVerticalPadding24)
			}
		}
	}
	
	private func eateryWithSlots(externalId: String, venueId: String) -> some View {
		if viewModel.errorOnLoadingSlots {
			AnyView(
				EaterySlotsErrorView()
			)
		} else if let eatery = viewModel.eateriesWithSlots.find(byExternalId: externalId, byVenueId: venueId) {
			AnyView (
				EaterySlotsView(eatery: eatery,
								isLoading: viewModel.isEateriesSlotsLoading,
								slotsPadding : Spacing.space16,
                                readMoreText: viewModel.eateriesList.resources.soldOutReadMore,
								onSlotClick: { viewModel.onSlotClick(eatery:$0, slot: $1) },
								onEditClick: { viewModel.onEditEateryWithSlotsButtonClick(eatery: $0)},
                                onReadMoreClick: { viewModel.onReadMoreClick(eatery: $0) }
                               )
			)
		} else  {
			AnyView(
				EmptyView()
			)
		}
	}
	
	private func walkIns() -> some View {
		VStack(alignment:.leading, spacing: Spacing.space16) {
			Text("Walk-in Eateries")
				.font(.vvBodyBold)
				.foregroundColor(.blackText)
				.multilineTextAlignment(.center)
			
			VStack(spacing: Spacing.space16) {
				ForEach(viewModel.eateriesList.walkIns, id: \.id) { eatery in
					Card(title: eatery.name, imageUrl: eatery.squareThumbnailUrl, subheading: eatery.subHeading,  onTap: {
						viewModel.onEateryClick(eatery: eatery)
					   })
				}
			}
		}
	}
}

#Preview {
	HomeComingGuideScreen(viewModel: HomeComingGuideScreenPreviewViewModel())
}

final class HomeComingGuideScreenPreviewViewModel : HomeComingGuideScreenViewModelProtocol {
	var newBookingViewModel: EaterySlotBookViewModel? = nil
	var editBookingViewModel: EditBookingSheetViewModel? = nil
	var screenState: ScreenState = .content
	var homeComingGuide: HomeComingGuide
	var eateriesList: EateriesList
	var eateriesWithSlots: EateriesSlots
	var isEateriesSlotsLoading: Bool = false
	
	var showSlotBookSheet: Bool = false
	var showEditSlotBookSheet: Bool = false
	
	var filter: EateriesSlotsInputModel = .init()
	var isEateriesListLoading: Bool = false
	var errorOnLoadingSlots: Bool = false
    var showSoldOutSheet: Bool = false
    var infoDrawerModel: InfoDrawerModel = .empty()

	init(homeComingGuide: HomeComingGuide = .sample(),
		 eateriesList: EateriesList = .sample(),
		 eateriesWithSlots: EateriesSlots = .sample()) {
		self.homeComingGuide = homeComingGuide
		self.eateriesList = eateriesList
		self.eateriesWithSlots = eateriesWithSlots
	}
	
	func onViewWalletClick() {
		
	}
	
	func onFirstAppear() {
		
	}
	
	func onReAppear() {
		
	}
	
	func onRefresh() {
		
	}
	
	func onBackClick() {
		
	}
	
	func onEateryClick(eatery: EateriesList.Eatery) {
		
	}
	
	func onSlotClick(eatery: EateriesSlots.Restaurant, slot: Slot) {
		
	}
	
	func onBookCompleted() {
		
	}
	
	func onSlotBookSheetDismissed() {
		
	}
	
	func onEditEateryWithSlotsButtonClick(eatery: EateriesSlots.Restaurant) {
		
	}
	
	func onEditBookingCompleted() {
		
	}
	
	func onEditBookingSheetDismissed() {
		
	}
	
	func onBookingCanceled() {
		
	}

    func onReadMoreClick(eatery: EateriesSlots.Restaurant) {}

    func onReadMoreDismiss() {}
}
