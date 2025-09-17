//
//  AddToPlannerView.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 29.8.25.
//

import SwiftUI
import VVUIKit

protocol AddToPlannerViewModelProtocol: ObservableObject {
    var actions: [PlannerAction] { get }
    func onDismiss()
}

struct AddToPlannerView: View {
    @StateObject private var viewModel: AddToPlannerViewModel

    public init(viewModel: AddToPlannerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GeometryReader { geo in
                FloatingBottomCornerButton(icon: "xmark", action: viewModel.onDismiss)

                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: Spacing.space16) {
                        Spacer()
                        ForEach(viewModel.actions, id: \.id) { category in
                            Button(category.title) {
                                category.action()
                            }
                            .buttonStyle(PrimaryAddCapsuleButtonStyle())
                        }
                    }
                    .padding(.trailing, FloatingBottomCornerButton.trailingPadding)
                    .padding(.bottom, FloatingBottomCornerButton.size + FloatingBottomCornerButton.extraSafeAreaPadding + FloatingBottomCornerButton.bottomPadding + Spacing.space16)
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct AddToPlannerView_Previews: PreviewProvider {
    static var previews: some View {
        AddToPlannerView(viewModel: AddToPlannerViewModel())
    }
}
