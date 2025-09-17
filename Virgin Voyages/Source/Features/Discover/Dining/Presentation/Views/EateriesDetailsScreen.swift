//
//  EateriesDetailsScreen.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 30.11.24.
//


import SwiftUI
import VVUIKit

protocol EateryDetailsScreenViewModelProtocol {
	var screenState: ScreenState {get set}
	var eateryDetails: EateryDetailsModel {get}
	var filter: EateriesSlotsInputModel {get set}
	var itineraryDates: [Date] {get}
	var isEateriesSlotsLoading: Bool {get}
	var eateryWithSlots: EateriesSlots.Restaurant? {get}
	var showFilterSheet: Bool {get set}
	var showSlotBookSheet: Bool {get set}
	var availableSailors: [SailorModel] {get}
	var showEditSlotBookSheet: Bool {get set}
	var showAddTocalendarSheet: Bool {get set}
    var showPDFMenuViewer: Bool { get set }
    var pdfMenuUrl: URL? { get }
	var newBookingViewModel: EaterySlotBookViewModel? {get}
	var editBookingViewModel: EditBookingSheetViewModel? {get}
	var errorOnLoadingSlots: Bool { get }
    var isMenuClickable: Bool { get }
    var showSoldOutSheet: Bool { get set }
    var infoDrawerModel: InfoDrawerModel { get }
    var openingTimesTitle: String { get }
    var editorialBlocks: [EditorialBlock] { get }

	func onAppear()
	func onRefresh()
	func onDateChanged()
	func onFilterChanged(date: Date, mealPeriod: MealPeriod, selectedSailors: [SailorModel])
	func onFilterButtonClick()
	func onSlotClick(eatery: EateriesSlots.Restaurant, slot: Slot)
	func onBookCompleted()
	func onEditEateryWithSlotsButtonClick(eatery: EateriesSlots.Restaurant)
	func onEditBookingCompleted()
	
	func onChangePartySize()
	func onAddToCalendarClick()
	func onEditBookingSheetDismiss()
	func onBookingCanceled()
	func onNewBookingSheetDismiss()
    func onOpenMenu()
    func onReadMoreClick(eatery: EateriesSlots.Restaurant)
    func onReadMoreDismiss()
}

struct EateriesDetailsScreen: View {
	@State var viewModel: EateryDetailsScreenViewModelProtocol
	let onBackClick: VoidCallback?
	let onViewReceiptClick: ((String) -> Void)?
	
	init(
		slug: String,
		filter: EateriesSlotsInputModel? = nil,
		onBackClick: VoidCallback? = nil,
		onViewReceiptClick: ((String) -> Void)? = nil) {
			self.init(viewModel: EateryDetailsScreenViewModel(slug: slug, filter: filter),
					  onBackClick: onBackClick,
					  onViewReceiptClick: onViewReceiptClick)
		}
	
	init(viewModel: EateryDetailsScreenViewModelProtocol,
		 onBackClick: VoidCallback? = nil,
		 onViewReceiptClick: ((String) -> Void)? = nil) {
		_viewModel = State(wrappedValue: viewModel)
		self.onBackClick = onBackClick
		self.onViewReceiptClick = onViewReceiptClick
	}
	
	var body: some View {
		DefaultScreenView(state: $viewModel.screenState) {
            ZStack(alignment: .top) {
                VVUIKit.ContentView {
                    
                    VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding16) {
                        
                        VStack(spacing: Spacing.space0) {
                            header()
                            
                            VStack(spacing: Spacing.space0) {
                                if !viewModel.eateryDetails.openingTimes.isEmpty {
                                    openingTimes()
                                }
                                
                                Divider().background(Color.gray)
                                
                                deckInfo()
                            }
                        }
                        
                        if(viewModel.eateryDetails.isBookable) {
                            if let leadTime = viewModel.eateryDetails.leadTime {
                                EateryLeadTimeView(title: leadTime.title,
                                                   subtitle: leadTime.subtitle,
                                                   description: leadTime.description,
                                                   date: leadTime.date) {
                                    viewModel.onAddToCalendarClick()
                                }
                                                   .padding(.top, Spacing.space16)
                                                   .padding(.horizontal, Spacing.space24)
                            } else if let preVoyageBookingStoppedInfo = viewModel.eateryDetails.preVoyageBookingStoppedInfo {
                                EateryBookingStoppedView(title: preVoyageBookingStoppedInfo.title, description: preVoyageBookingStoppedInfo.description)
                                    .padding(.top, Spacing.space16)
                                    .padding(.horizontal, Spacing.space24)
                            } else {
                                slots()
                            }
                        }
                        
                        introduction()
                    }.background(Color.white)
                    
                    if viewModel.isMenuClickable {
                        VVUIKit.DoubleDivider(color: Color.black)
                        menuSection
                        VVUIKit.DoubleDivider(color: Color.black)
                    }
                    
                    needToKnow()
                    editorialBlocks()
                }
                toolbar()
                    .padding(.top, Spacing.space24)

            }
		} onRefresh:  {
			viewModel.onRefresh()
		}.onAppear() {
			viewModel.onAppear()
		}
		.sheet(isPresented: $viewModel.showSlotBookSheet) {
			if let newBookingViewModel = viewModel.newBookingViewModel {
				EaterySlotBookSheet(viewModel: newBookingViewModel,
				onBooked: {
					viewModel.onBookCompleted()
				}, onCancelClick: {
					viewModel.onNewBookingSheetDismiss()
				}, onChangePartySizeClick: {
					viewModel.onChangePartySize()
				})
			}
		}
		.sheet(isPresented: $viewModel.showFilterSheet) {
			EateriesFilterSheet(filter: viewModel.filter,
								availableSailors: viewModel.availableSailors,
								availableDates: viewModel.itineraryDates,
                                infoDrawerModel: InfoDrawerModel(title: viewModel.eateryDetails.resources.partySizeInfoDrawerHeading, description: viewModel.eateryDetails.resources.partySizeInfoDrawerBody, buttonTitle: viewModel.eateryDetails.resources.gotItCta),
								onSearch: {
				(date, mealPeriod, selectedSailors) in viewModel.onFilterChanged(date: date, mealPeriod: mealPeriod, selectedSailors: selectedSailors)
			})
		}.sheet(isPresented: $viewModel.showEditSlotBookSheet) {
			if viewModel.eateryDetails.preVoyageBookingStoppedInfo != nil {
				PreVoyageEditingModal {
					viewModel.onEditBookingSheetDismiss()
				}
			}
			else if let editBookingViewModel = viewModel.editBookingViewModel {
			   EditEateryBookingSheet(viewModel: editBookingViewModel,
			   onBooked: {
				   viewModel.onEditBookingCompleted()
			   },
			   onDismiss: {
				   viewModel.onEditBookingSheetDismiss()
			   },
			   onCanceled: {
				  viewModel.onBookingCanceled()
			  })
		   }
		}
		.sheet(isPresented: $viewModel.showAddTocalendarSheet) {
			if let leadTime = viewModel.eateryDetails.leadTime {
				EventCalendarEditView(title: "Virgin Voyages - Restaurant booking opens", startDate: leadTime.date, endDate: leadTime.date)
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
        .fullScreenCover(isPresented: $viewModel.showPDFMenuViewer) {
            AsyncPDFViewer(url: viewModel.pdfMenuUrl) {
                viewModel.showPDFMenuViewer = false
            }
        }
		.ignoresSafeArea(edges: [.top])
		.navigationTitle("")
		.navigationBarBackButtonHidden(true)
	}
    
    private func toolbar() -> some View {
        HStack(alignment: .top) {
            BackButton({onBackClick?()})
            .padding(.leading, Spacing.space32)
            .padding(.top, Spacing.space32)
            .opacity(0.8)
            Spacer()
        }
    }
	
	private func header() -> some View {
		VStack(alignment:.leading, spacing: Spacing.space0) {
			ZStack(alignment: .topLeading) {
				ZStack(alignment: .bottomLeading) {
                    URLImage(url: URL(string: viewModel.eateryDetails.portraitHeroURL))
						.containerRelativeFrame(widthPercentage: 1, heightPercentage: 0.5)
					
					VStack(alignment:.leading, spacing: Spacing.space16) {
						Text(viewModel.eateryDetails.name)
							.font(.vvHeading1Bold)
							.foregroundColor(.white)
							.padding(Spacing.space16)
						
						appointmentsView()
					}
				}
			}
			.frame(maxWidth: .infinity)
		}
	}
	
	private func appointmentsView() -> some View {
		VStack(spacing: Spacing.space0) {
			if let appointments = viewModel.eateryWithSlots?.appointments, appointments.items.count > 0 {
				if appointments.items.count == 1 {
					MessageBar(style: .Success, text: appointments.bannerText)
						.onTapGesture {
							onViewReceiptClick?(appointments.items[0].id)
						}
				} else {
					VStack(spacing: Spacing.space0) {
						MessageBar(style: .Success, text: appointments.bannerText)
						
						ForEach(appointments.items, id: \.id) { item in
							MessageBar(style: .Success, text: item.bannerText)
								.onTapGesture {
									onViewReceiptClick?(item.id)
								}
						}
					}
				}
			}
		}
	}
	
	private func slots() -> some View {
		VStack(alignment: .center, spacing: Paddings.defaultVerticalPadding32) {
			Button {
				viewModel.onFilterButtonClick()
			} label: {
				HStack {
					Text(viewModel.filter.mealPeriod.rawValue.capitalizedFirstLetter())
					Image(systemName: "person")
					Text("\(viewModel.filter.guests.count)")
				}
				.contentStyle()
			}
			.fontStyle(.button)
			.buttonStyle(BorderedProminentButtonStyle())
			.clipShape(Capsule())
			
			
			DateSelector(selected: $viewModel.filter.searchSlotDate, options: viewModel.itineraryDates)
				.onChange(of: viewModel.filter.searchSlotDate) {
					viewModel.onDateChanged()
				}
			
			
			VStack(alignment: .leading, spacing: Paddings.defaultPadding8) {
				Divider()
				if viewModel.errorOnLoadingSlots {
					AnyView(
						EaterySlotsErrorView()
					)
				} else if let eatery = viewModel.eateryWithSlots {
					EaterySlotsView(eatery: eatery,
									isLoading: viewModel.isEateriesSlotsLoading,
									slotsPadding : Spacing.space0,
                                    readMoreText: viewModel.eateryDetails.resources.soldOutReadMore,
                                    selectSlotSubheading: viewModel.eateryDetails.resources.selectTimeSlotSubheading,
									onSlotClick: { viewModel.onSlotClick(eatery:$0, slot: $1) },
									onEditClick: { viewModel.onEditEateryWithSlotsButtonClick(eatery: $0)},
                                    onReadMoreClick: { viewModel.onReadMoreClick(eatery: $0) }
                    )
				}
				
				Divider()
			}
		}
        .padding(.vertical, Paddings.defaultVerticalPadding16)
        .padding(.horizontal, Spacing.space24)
	}
	
	private func introduction() -> some View {
		VStack(alignment: .leading, spacing: 20) {
			if let introduction = viewModel.eateryDetails.introduction {
				Text(introduction.markdown)
                    .font(.vvHeading3Light)
                    .foregroundStyle(Color.slateGray)
			}
			
			Text(viewModel.eateryDetails.longDescription.markdown)
                .font(.vvBody)
                .foregroundStyle(Color.slateGray)
		}
		.frame(maxWidth: .infinity)
        .padding(.vertical, Paddings.defaultVerticalPadding16)
        .padding(.horizontal, Spacing.space24)
		.background(.background)
	}
	
	private func openingTimes() -> some View {
        ExpandableRow(backgroundColor: .black, cornerRadius: 0, borderColor: .black) { isExpanded in
            VStack(alignment: .leading, spacing: .zero) {
                HStack(alignment: .center, spacing: Spacing.space8) {
                    Image(systemName: "clock")

                    Text(viewModel.openingTimesTitle)
                        .font(.vvHeading5Bold)

                    Spacer()

                    Text("SEE DETAILS")
                        .font(.vvCaptionBold)
                        .kerning(1.2)

                    Image(systemName: "chevron.\(isExpanded ? "up" : "down")")
                        .frame(width: Spacing.space24, height: Spacing.space24)
                }
                .padding(.vertical, Spacing.space12)
                .padding(.horizontal, Spacing.space16)
            }
        } content: {
            VStack {
                ForEach(viewModel.eateryDetails.openingTimes, id: \.id) { openingTime in
                    LabeledContent {
                        Text(openingTime.text.replacingOccurrences(of: ",", with: "\n"))
                            .font(.vvSmall)
                            .multilineTextAlignment(.trailing)
                    } label: {
                        Label(openingTime.label, systemImage: "clock")
                            .font(.vvSmall)
                    }
                }
            }
            .padding(Paddings.defaultVerticalPadding16)
            .fontStyle(.headline)
        }
        .background(Color.black)
        .foregroundColor(Color.borderGray)
	}
	
	private func deckInfo() -> some View {
		HStack {
			Image(systemName: "mappin.and.ellipse")
				
			Text(viewModel.eateryDetails.deckLocation)
				.font(.vvBody)
				.frame(maxWidth: .infinity, alignment: .leading)
		}
		.padding(Spacing.space16)
		.background(Color.black)
		.foregroundColor(Color.iconGray)
		.frame(maxWidth: .infinity, alignment: .leading)
	}

    private var menuSection: some View {
        VStack(alignment: .leading, spacing: Spacing.space24) {
            if let menu = viewModel.eateryDetails.menuData {
                VStack(alignment: .leading, spacing: Spacing.space16) {
                    Text(menu.header)
                        .font(.vvHeading3Bold)
                    Text(menu.description)
                        .font(.vvHeading5)
                        .foregroundColor(Color.vvGray)
                }
                VStack {
                    VStack {
                        Text("Menu")
                            .font(.vvSmallBold)
                            .foregroundStyle(Color(hex: menu.menuTextColor))
                            .kerning(1.4)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .top)
                            .opacity(0.7)
                    }
                    .frame(alignment: .top)
                    .padding(.top, Spacing.space24)


                    URLImage(url: URL(string: menu.logo), contentMode: .fit)
                        .padding(Spacing.space24)
                        .frame(width: 160, height: 160, alignment: .center)
                        .padding(Spacing.space64)

                    VStack {
                        Divider()
                            .frame(height: 1)
                            .background(.white.opacity(0.3))
                        Text(menu.coverDescription)
                            .font(.vvSmall)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    }
                    .frame(alignment: .bottom)
                    .padding(.bottom, Spacing.space16)
                }
                .background(
                    URLImage(url: URL(string: menu.coverImage), contentMode: .fill)
                )
                .background(
                    URLImage(url: URL(string: menu.pageBackground), contentMode: .fill)
                )
                .frame(minHeight: 392, maxHeight: 392)
                .cornerRadius(Spacing.space8, corners: .allCorners)
            }
        }
        .onTapGesture {
            viewModel.onOpenMenu()
        }
        .padding(.vertical, Spacing.space40)
        .padding(.horizontal, Spacing.space24)
    }

    private func needToKnow() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space24) {
            Text("Need to Know")
                .font(.vvHeading3Bold)
                .foregroundStyle(Color.blackText)
            ForEach(viewModel.eateryDetails.needToKnows, id: \.self) { item in
                HStack(alignment: .top, spacing: Spacing.space16) {
                    Image(.needToKnow)
                        .resizable()
                        .frame(width: Sizes.defaultSize24, height: Sizes.defaultSize24)
                        .aspectRatio(contentMode: .fit)
                    
                    Text(item)
                        .font(.vvHeading5)
                        .foregroundColor(Color.slateGray)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.space24)
    }

    private func editorialBlocks() -> some View {
        VStack {
            ForEach(viewModel.editorialBlocks, id: \.self) { editorial in
                HTMLText(htmlString: editorial.html ?? "", fontType: .normal, fontSize: .size16, color: .slateGray, options: .init(strongOverride: .init(fontType: .bold, fontSize: .size24, color: .blackText), shouldInsertLineBreakAfterStrong: true, wrapInPre: false))
                    .padding(.horizontal, Paddings.defaultHorizontalPadding)
                    .padding(.vertical, Paddings.defaultVerticalPadding32)
            }
        }
        .background(Color.white)
    }
}


#Preview("Eatery details with slots") {
	EateriesDetailsScreen(viewModel: EateryDetailsScreenPreviewViewModel())
}

#Preview("Eatery details with lead time") {
	EateriesDetailsScreen(viewModel: EateryDetailsScreenPreviewViewModel(eateryDetails: EateryDetailsModel.sampleWithLeadTime()))
}

#Preview("Eatery details with Pre voyage booking stopped") {
	EateriesDetailsScreen(viewModel: EateryDetailsScreenPreviewViewModel(eateryDetails: EateryDetailsModel.sampleWithPreVoyageBookingStoppedInfo()))
}

#Preview("Eatery details with multiple bookings") {
	let appointments = Appointments.sample().copy(bannerText: "Booked: Table for 3, Fri 23 May, 6pm", items: [
		.sample().copy(bannerText: "Booked for 2 @6:30pm"),
		.sample().copy(bannerText: "Booked for 1 @8:00pm")
	])
	
	EateriesDetailsScreen(viewModel: EateryDetailsScreenPreviewViewModel(eateryWithSlots: EateriesSlots.Restaurant.sample().copy(appointments: appointments)))
}

struct EateryDetailsScreenPreviewViewModel: EateryDetailsScreenViewModelProtocol {
	var screenState: ScreenState
	var eateryDetails: EateryDetailsModel
	var filter: EateriesSlotsInputModel
	var itineraryDates: [Date]
	var isEateriesSlotsLoading: Bool
	var isBookable: Bool
	
	var showFilterSheet: Bool
	
	var showSlotBookSheet: Bool
	var availableSailors: [SailorModel]
	var showEditSlotBookSheet: Bool
	
	var showAddTocalendarSheet: Bool = false
    var showPDFMenuViewer: Bool = false
    var pdfMenuUrl: URL? { nil }
	var eateryWithSlots: EateriesSlots.Restaurant? = nil
	var newBookingViewModel: EaterySlotBookViewModel? = nil
	var editBookingViewModel: EditBookingSheetViewModel? = nil
	var errorOnLoadingSlots: Bool = false
    var isMenuClickable: Bool = false
    var showSoldOutSheet: Bool = false
    var infoDrawerModel: InfoDrawerModel = .empty()
    var openingTimesTitle: String = ""
    var editorialBlocks: [EditorialBlock] = []

	init(eateryDetails: EateryDetailsModel = EateryDetailsModel.sample(), eateryWithSlots: EateriesSlots.Restaurant? = nil) {
		screenState = .content
		self.eateryDetails = eateryDetails
		self.eateryWithSlots = eateryWithSlots
		filter = EateriesSlotsInputModel.sample
		itineraryDates = DateGenerator.generateDates(from: Date(), totalDays: 5)
		isEateriesSlotsLoading = false
		isBookable = true
		
		showFilterSheet = false
	
		showSlotBookSheet = false
		availableSailors = []
		showEditSlotBookSheet = false
	}
	
	func onAppear() {
		
	}
	
	func onRefresh() {
		
	}
	
	func onDateChanged() {
		
	}
	
	func onFilterChanged(date: Date, mealPeriod: MealPeriod, selectedSailors: [SailorModel]) {
		
	}
	
	func onFilterButtonClick() {
		
	}
	
	func onEditBookingCompleted() {
		
	}
	
	func onNewSailorAdded() {
		
	}
	
	func onChangePartySize() {
		
	}
	
	func onAddToCalendarClick() {
		
	}
	
	func onEditBookingSheetDismiss() {
		
	}
	
	func onBookingCanceled() {
		
	}
	
	func onNewBookingSheetDismiss() {
		
	}

    func onOpenMenu() {

    }
	
	func onSlotClick(eatery: EateriesSlots.Restaurant, slot: Slot) {
		
	}
	
	func onBookCompleted() {
		
	}
	
	func onEditEateryWithSlotsButtonClick(eatery: EateriesSlots.Restaurant) {
		
	}

    func onReadMoreClick(eatery: EateriesSlots.Restaurant) { }

    func onReadMoreDismiss() { }
}
