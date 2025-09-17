//
//  CabinServiceOpeningTimeScreen.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 3.5.25.
//

import SwiftUI
import VVUIKit

protocol CabinServiceOpeningTimeScreenViewModelProtocol {
	var screenState: ScreenState { get set }
	var cabinServiceOpenTime: CabinServiceOpeninTime { get }
	
	func onAppear()
	func onRefresh()
	func onBackTapped()
}

struct CabinServiceOpeningTimeScreen : View {
	@State var viewModel: CabinServiceOpeningTimeScreenViewModelProtocol
	
	init(viewModel: CabinServiceOpeningTimeScreenViewModelProtocol = CabinServiceOpeningTimeScreenViewModel()) {
		_viewModel = State(wrappedValue: viewModel)
	}
	
	var body: some View {
		DefaultScreenView(state: $viewModel.screenState) {
			VVUIKit.ContentView {
				VStack(spacing: Spacing.space40) {
					toolbar()
					
					OpeningTimeView(imageURL: viewModel.cabinServiceOpenTime.imageURL,
									title: viewModel.cabinServiceOpenTime.title,
									subtitle: viewModel.cabinServiceOpenTime.subtitle)
				}
				
			}
		} onRefresh: {
			viewModel.onRefresh()
		}
		.onAppear {
			viewModel.onAppear()
		}
		.ignoresSafeArea(edges: [.top])
		.navigationTitle("")
		.navigationBarBackButtonHidden()
	}
	
	func toolbar() -> some View {
		HStack {
			BackButton {
				viewModel.onBackTapped()
			}
			.padding(.leading, Spacing.space16)
			.padding(.top, Spacing.space48)
			
			Spacer()
		}
	}
}

#Preview {
	CabinServiceOpeningTimeScreen(viewModel: CabinServiceOpeningTimeScreenPreviewViewModel(cabinServiceOpenTime: .sample()))
}


struct CabinServiceOpeningTimeScreenPreviewViewModel: CabinServiceOpeningTimeScreenViewModelProtocol {
	var screenState: ScreenState = .content
	var cabinServiceOpenTime: CabinServiceOpeninTime
	
	init(cabinServiceOpenTime: CabinServiceOpeninTime) {
		self.cabinServiceOpenTime = cabinServiceOpenTime
	}
	
	func onAppear() {
		
	}
	
	func onRefresh() {
		
	}
	
	func onBackTapped() {
		
	}
}
