//
//  WalletView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/20/23.
//

import SwiftUI

struct WalletView: View {
	@State var viewModel: WalletViewModel

	init(viewModel: WalletViewModel) {
		_viewModel = State(wrappedValue: viewModel)
	}

	var body: some View {
		ScreenView(name: "Wallet", viewModel: WalletViewer(), content: $viewModel.wallet) { wallet in
			WalletScreen(wallet: wallet)
		}
		.onAppear() {
			viewModel.onAppear()
		}
	}
}

protocol WalletViewModelProtocol {
	var wallet: WalletViewer.Content? { get set }
	func onAppear()
}

@Observable class WalletViewModel: BaseViewModelV2, WalletViewModelProtocol {
	var wallet: WalletViewer.Content?

	func onAppear() {
		guard let sailor = try? AuthenticationService.shared.currentSailor() else { return }
		Task {
			let wallet = await sailor.preload(WalletViewer())
			self.wallet = wallet
		}
	}
}
