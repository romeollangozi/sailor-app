//
//  HelpAndSupportScreen.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 22.4.25.
//

import SwiftUI
import VVUIKit

protocol HelpAndSupportScreenViewModelProtocol {
	var screenState: ScreenState {get set}
	var helpAndSupport: HelpAndSupport {get}
	var searchableCategories: [HelpAndSupport.Category] {get}
	var categoriesForFilter: [HelpAndSupport.Category] {get}
	var searchText: String {get set}
	var selectedCategory: HelpAndSupport.Category? {get}
	
	var isOnShip: Bool {get}
	
	func onAppear()
	func onRefresh()
	func onBackTapped()
	func onArticleTapped(article: HelpAndSupport.Article)
	func onSearchTextChanged()
	func onCategoryTapped(category: HelpAndSupport.Category)
}

struct HelpAndSupportScreen: View {
	@State var viewModel: HelpAndSupportScreenViewModelProtocol
	
	init(viewModel: HelpAndSupportScreenViewModelProtocol = HelpAndSupportScreenViewModel()) {
		_viewModel = State(wrappedValue: viewModel)
	}
	
	var body: some View {
		DefaultScreenView(state: $viewModel.screenState) {
			VVUIKit.ContentView {
				VStack(spacing: Spacing.space0) {
					header()
					
					search()
					
					if viewModel.searchableCategories.isEmpty {
						noResults()
					} else {
						ZStack(alignment: .top) {
							articles()
								.padding(.top, Spacing.space32)
							
							categories()
								.padding(.horizontal, Spacing.space8)
						}
					}
		
					HelpAndSupportFooter(supportPhoneNumber: viewModel.helpAndSupport.supportPhoneNumber, sailorServiceLocation: viewModel.helpAndSupport.sailorServiceLocation, isOnShip: viewModel.isOnShip)
				}
			}
		} onRefresh:  {
			viewModel.onRefresh()
		}.onAppear() {
			viewModel.onAppear()
		}
		.ignoresSafeArea(edges: [.top])
		.navigationTitle("")
		.navigationBarBackButtonHidden(true)
		.onChange(of: viewModel.searchText) {
			viewModel.onSearchTextChanged()
		}
	}
	
	private func header() -> some View {
		VStack(alignment:.leading, spacing: Spacing.space0) {
			VStack(alignment:.leading, spacing: Spacing.space24) {
				BackButton {
					viewModel.onBackTapped()
				}
				
				VStack(spacing: Spacing.space8) {
					Text("Help & Support")
						.font(.vvHeading1Bold)
						.foregroundColor(.charcoalBlack)
					
					Text("Whether you’re looking for a specific answer or for a little knowledge… we've got you.")
						.font(.vvBody)
						.foregroundColor(.slateGray)
				}.padding(.horizontal, Spacing.space24)
			}
		}
		.padding(.leading, Spacing.space16)
		.padding(.top, Spacing.space48)
	}
	
	private func search() -> some View {
		VStack {
			VVTextField(label: "Search FAQs", value: $viewModel.searchText)
				.background(.white)
		}.padding(Spacing.space24)
	}
	
	private func categories() -> some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack {
				ForEach(viewModel.categoriesForFilter, id:\.sequenceNumber) { category in
					createCategoryButton(category: category)
				}
			}.padding(Spacing.space8)
		}
	}
	
	private func createCategoryButton(category: HelpAndSupport.Category) -> some View {
		if viewModel.selectedCategory?.sequenceNumber == category.sequenceNumber {
			return AnyView(
				CapsulePrimaryButton(category.cta) {
					viewModel.onCategoryTapped(category: category)
				}
			)
		} else {
			return AnyView(
				CapsuleSecondaryButton(category.cta) {
					viewModel.onCategoryTapped(category: category)
				}
			)
		}
	}
	
	private func articles() -> some View {
		VStack(alignment:.leading) {
			VStack(spacing: Spacing.space24) {
				ForEach(viewModel.searchableCategories, id:\.sequenceNumber) { category in
					VStack(alignment:.leading, spacing: Spacing.space16) {
						Text(category.cta)
							.font(.vvSmallBold)
							.foregroundColor(.slateGray)
							.textCase(.uppercase)
						
						VStack(spacing: Spacing.space16) {
							ForEach(category.articles, id:\.id) { article in
								Button(action: {
									viewModel.onArticleTapped(article: article)
								}) {
									HStack {
										Text(article.name)
											.font(.vvHeading5Bold)
											.foregroundColor(.charcoalBlack)
											.multilineTextAlignment(.leading)
										
										Spacer()
										
										Image(systemName: "chevron.right")
											.foregroundColor(.vvRed)
									}
								}
							}
						}
					}.frame(maxWidth: .infinity, alignment: .leading)
				}
			}
			.padding(.top, Spacing.space32)
			.padding(Spacing.space24)
		}.background(Color.white)
	}
	
	private func noResults() -> some View {
		VStack(spacing: Spacing.space8) {
			VStack(spacing: Spacing.space16) {
				Image("emptyResultNakedMan")
					.resizable()
					.frame(width: 100, height: 167)
				
				Text("Uh oh - our results are naked.")
					.font(.vvHeading1Bold)
					.foregroundColor(.charcoalBlack)
					.multilineTextAlignment(.center)
				
				HStack {
					Text("We couldn’t find anything for")
						.font(.vvBody)
						.foregroundColor(.slateGray)
					
					Text("\"\(viewModel.searchText)\"")
						.font(.vvBodyBold)
						.foregroundColor(.slateGray)
				}
			}
			.frame(maxWidth: .infinity, alignment: .center)
			.padding(Spacing.space24)
		}.background(Color.white)
	}
}

#Preview("Help and support pre cruise") {
	HelpAndSupportScreen(viewModel: HelpAndSupportScreenPreviewViewModel())
}

#Preview("Help and support on ship") {
	HelpAndSupportScreen(viewModel: HelpAndSupportScreenPreviewViewModel(isOnShip: true))
}

#Preview("Help and support with empty search results") {
	HelpAndSupportScreen(viewModel: HelpAndSupportScreenPreviewViewModel(helpAndSupport: .sampleWithEmptyCategories(), isOnShip: false, searchText: "Bsbsbbsbsbbs"))
}

struct HelpAndSupportScreenPreviewViewModel: HelpAndSupportScreenViewModelProtocol {
	var screenState: ScreenState = .content
	var helpAndSupport: HelpAndSupport
	var searchableCategories: [HelpAndSupport.Category] = []
	var categoriesForFilter: [HelpAndSupport.Category] = []
	var searchText: String = ""
	var isOnShip: Bool = false
	var selectedCategory: HelpAndSupport.Category? = nil
	
	init(helpAndSupport: HelpAndSupport = .sample(), isOnShip: Bool = false, searchText: String = "") {
		self.helpAndSupport = helpAndSupport
		self.searchableCategories = helpAndSupport.categories.withArticles()
		self.categoriesForFilter = helpAndSupport.categories.withArticles()
		self.isOnShip = isOnShip
		self.searchText = searchText
	}
	
	func onAppear() {
		
	}
	
	func onRefresh() {
		
	}
	
	func onBackTapped() {
		
	}
	
	func onArticleTapped(article: HelpAndSupport.Article) {
		
	}
	
	func onSearchTextChanged() {
		
	}
	
	func onCategoryTapped(category: HelpAndSupport.Category) {
		
	}
}
