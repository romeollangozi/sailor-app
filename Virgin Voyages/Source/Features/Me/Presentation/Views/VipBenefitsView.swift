//  VipBenefitsView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 3.3.25.
//

import SwiftUI
import VVUIKit

protocol VipBenefitsViewModelProtocol {
	var vipBenefits: VipBenefitsModel { get }
	var screenState: ScreenState { get set }
	func onAppear()
	func contactAction()
}

struct VipBenefitsView: View {

	@State var viewModel: VipBenefitsViewModelProtocol
	let onBackClick: () -> Void
	var screenState: ScreenState = .loading

	init(onBackClick: @escaping () -> Void, viewModel: VipBenefitsViewModelProtocol = VipBenefitsViewModel()) {
		self.onBackClick = onBackClick
		_viewModel = State(wrappedValue: viewModel)
	}

	var body: some View {
		DefaultScreenView(state: $viewModel.screenState, content: {
			VStack {
				toolbar()
				contentView()
				Spacer()
			}
			.background(Color.rockstarGray)
			.edgesIgnoringSafeArea(.vertical)
		}, onRefresh: {})
		.onAppear {
			viewModel.onAppear()
		}
	}

	private func toolbar() -> some View {
		HStack(alignment: .top) {
			BackButton(onBackClick)
				.padding(.leading, Spacing.space32)
				.opacity(0.8)
			Spacer()
		}
		.padding(.top, Spacing.space48)
		.zIndex(1)
	}

	private func contentView() -> some View {
		ScrollView {
			VStack {
				UnderLineTextView(text: viewModel.vipBenefits.title)
				HTMLTextView(viewModel.vipBenefits.subtitle)
					.foregroundStyle(.white)
					.padding()
					.multilineTextAlignment(.center)

				benefitsList()

				VVUIKit.DoubleDivider(color: .secondaryRockstar)
					.padding(.vertical)

				contactView()
					.padding(.vertical, Spacing.space48)
			}
			.padding(.top)
		}
	}

	private func benefitsList() -> some View {
		ForEach(viewModel.vipBenefits.benefits.indices, id: \.self) { index in
			let benefit = viewModel.vipBenefits.benefits[index]
			benefitRow(
				title: benefit.summary,
				subTitle: benefit.sequence,
				icon: benefit.iconUrl,
				isLastRow: index == viewModel.vipBenefits.benefits.count - 1
			)
		}
	}

	private func benefitRow(title: String, subTitle: String, icon: String, isLastRow: Bool) -> some View {
		VStack(spacing: Spacing.space4) {
			HStack(alignment: .center, spacing: Spacing.space4) {
				SVGImageView(url: URL(string: icon)!, frameSize: CGSizeMake(Spacing.space32, Spacing.space32))
					.foregroundColor(.green)

				VStack(alignment: .leading) {
					Text(title)
						.font(.vvHeading5Bold)
						.foregroundColor(.white)

					if !subTitle.isEmpty {
						Text(subTitle)
							.font(.vvBody)
							.foregroundColor(.secondaryRockstar)
					}
				}
				.padding()

				Spacer()
			}
			.padding(.horizontal)

			if !isLastRow {
				Divider()
					.background(Color.rockstarDark)
					.padding(.horizontal)
			}
		}
		.padding(.vertical, Spacing.space8)
	}

	private func contactView() -> some View {
		VStack(alignment: .center) {
			Text(viewModel.vipBenefits.contactTitle)
				.foregroundStyle(.white)
				.font(.vvSmallBold)
				.padding(.horizontal)
			CircleImageButton(
				color: .secondaryRockstar,
				imageName: viewModel.vipBenefits.contactImage,
				action: {
					viewModel.contactAction()
				}
			)
			.padding(.bottom, Spacing.space48)
		}
	}
}

final class MockVipBenefitsViewModel: VipBenefitsViewModelProtocol {

	var screenState: ScreenState = .content
	var vipBenefits: VipBenefitsModel
	var mockUseCase: GetVipBenefitsUseCaseProtocol

	init(vipBenefits: VipBenefitsModel = .mock(), mockUseCase: GetVipBenefitsUseCaseProtocol = GetVipBenefitsUseCase()) {
		self.vipBenefits = vipBenefits
		self.mockUseCase = mockUseCase
	}

	func contactAction() {}

	func onAppear() {
		Task {
			vipBenefits = try await mockUseCase.execute()
		}
	}
}

#Preview {
	VipBenefitsView(onBackClick: {}, viewModel: MockVipBenefitsViewModel())
}
