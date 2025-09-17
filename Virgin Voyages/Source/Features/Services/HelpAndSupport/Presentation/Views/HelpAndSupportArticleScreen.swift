//
//  HelpAndSupportArticleScreen.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 23.4.25.
//

import SwiftUI
import VVUIKit


protocol HelpAndSupportArticleScreenViewModelProtocol {
	var screenState: ScreenState {get set}
	var article: HelpAndSupport.Article {get}
	var isOnShip: Bool {get}
	
	func onAppear()
	func onRefresh()
	func onBackTapped()
}

struct HelpAndSupportArticleScreen: View {
	@State var viewModel: HelpAndSupportArticleScreenViewModelProtocol
	
	init(article: HelpAndSupport.Article) {
		self.init(viewModel: HelpAndSupportArticleScreenViewModel(article: article))
	}
	
	init(viewModel: HelpAndSupportArticleScreenViewModelProtocol) {
		_viewModel = State(wrappedValue: viewModel)
	}
	
	var body: some View {
		DefaultScreenView(state: $viewModel.screenState) {
			VVUIKit.ContentView(backgroundColor: .white){
				VStack(alignment: .leading, spacing: Spacing.space24) {
					toolbar()
					
					articleDetails()
					
					HelpAndSupportFooter(supportPhoneNumber: viewModel.article.supportPhoneNumber, sailorServiceLocation: viewModel.article.sailorServiceLocation, isOnShip: viewModel.isOnShip)
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
	}
	
	private func toolbar() -> some View {
		BackButton {
			viewModel.onBackTapped()
		}
		.padding(.top, Spacing.space48)
		.padding(.horizontal, Spacing.space16)
	}
	
	private func articleDetails() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space24) {
			VStack(alignment: .leading, spacing: Spacing.space8) {
				Text(viewModel.article.categoryName)
					.font(.vvHeading5Bold)
					.foregroundColor(.mediumGray)
					.textCase(.uppercase)
				
				Text(viewModel.article.name)
					.font(.vvHeading1Bold)
					.foregroundColor(.charcoalBlack)
			}
			
			HTMLText(htmlString: viewModel.article.body, fontType: .normal, fontSize: FontSize.size18, color: Color.slateGray)
		}.padding(.horizontal, Spacing.space24)
	}
}

#Preview("Help and support article pre cruise") {
	HelpAndSupportArticleScreen(viewModel: HelpAndSupportArticleScreenPreviewViewModel())
}

#Preview("Help and support article on ship") {
	HelpAndSupportArticleScreen(viewModel: HelpAndSupportArticleScreenPreviewViewModel(isOnShip: true))
}

struct HelpAndSupportArticleScreenPreviewViewModel: HelpAndSupportArticleScreenViewModelProtocol {
	var article: HelpAndSupport.Article
	var screenState: ScreenState = .content
	var isOnShip: Bool = false
	
	init(article: HelpAndSupport.Article = .sample(), isOnShip: Bool = false) {
		self.article = article
		self.isOnShip = isOnShip
	}
	
	func onAppear() {
		
	}
	
	func onRefresh() {
		
	}
	
	func onBackTapped() {
		
	}
}
