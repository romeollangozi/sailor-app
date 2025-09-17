//
//  PreVoyageEditingModal.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 28.11.24.
//

import SwiftUI

protocol PreVoyageEditingViewModelProtocol {
    var title: String { get }
    var descriptionText: String { get }
    var goItButtonText: String { get }
    func onAppear()
}

struct PreVoyageEditingModal: View {
    
    @State var viewModel: PreVoyageEditingViewModelProtocol
    let dismiss: () -> Void

    init(viewModel: PreVoyageEditingViewModelProtocol = PreVoyageEditingViewModel(), dismiss: @escaping () -> Void) {
        self.viewModel = viewModel
        self.dismiss = dismiss
    }
    
    var body: some View {
        VStack {
            Spacer()
            Image("PreVoyageEditingStopped")
                .resizable()
                .scaledToFit()
                .frame(width: Sizes.preVoyageEditingStopped, height: Sizes.preVoyageEditingStopped)
                .foregroundColor(.blue)
                .clipShape(Circle())
            Text(viewModel.title)
                .fontStyle(.largeCaption)
                .multilineTextAlignment(.center)
                .padding()
            Text(viewModel.descriptionText)
                .fontStyle(.lightBody)
                .multilineTextAlignment(.center)
                .padding()
            DoubleDivider()
            
            Button(viewModel.goItButtonText) {
                dismiss()
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding()
        }
        .frame(alignment: .center)
        .onAppear {
            viewModel.onAppear()
        }
        .presentationDetents([.fraction(0.8)])
    }
}

struct PreVoyageEditingModal_Previews: PreviewProvider {
    struct MockPreVoyageEditingViewModel: PreVoyageEditingViewModelProtocol {
        var title: String = "Preview Title"
        var descriptionText: String = "This is a description text for the preview of the PreVoyageEditingModal. It illustrates how the view will look in real usage."
        var goItButtonText: String = "Got It!"
        
        func onAppear() {
            print("Mock ViewModel: onAppear triggered")
        }
    }

    static var previews: some View {
        PreVoyageEditingModal(
            viewModel: MockPreVoyageEditingViewModel(),
            dismiss: {
                print("Dismiss action triggered in Preview")
            }
        )
    }
}
