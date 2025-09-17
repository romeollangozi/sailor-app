//
//  ClearAllNotificationsPopupScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 1.5.25.
//

import SwiftUI
import VVUIKit

protocol ClearAllNotificationsViewModelProtocol{
    func clearAllNotifications(completion: @escaping () -> Void)
    func dismissClearAllPopup()
}

struct ClearAllNotificationsPopupScreen: View {

    @State var viewModel: ClearAllNotificationsViewModelProtocol
    private let action: () -> Void

    init(viewModel: ClearAllNotificationsViewModelProtocol = ClearAllNotificationsViewModel(), action: @escaping () -> Void) {
        self.viewModel = viewModel
        self.action = action
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.black
                .opacity(0.0)
                .ignoresSafeArea()
                VStack {
                    HStack(alignment: .top) {
                        Button(action: {}) {
                            Text("Clear All")
                                .foregroundStyle(Color.black)
                                .font(.vvSmallMedium)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(1000)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, Spacing.space24)
                    VStack{
                        VStack{
                            Text("Are you sure?")
                                .font(.vvHeading3Bold)
                                .padding(.bottom, Spacing.space8)
                                .padding(.top, Spacing.space24)
                            
                            Text("You can delete individual notifications by swiping them left or right")
                                .font(.vvSmall)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, Spacing.space24)
                        .padding(.bottom, Spacing.space16)
                        
                        HStack(spacing: 0.0) {
                            PrimaryButton("Yes, clear all") {
                                viewModel.clearAllNotifications(completion: action)
                            }
                                .frame(maxHeight: 36)
                            SecondaryButton("No", action: viewModel.dismissClearAllPopup)
                                .frame(maxHeight: 36)
                        }
                        .padding(.bottom, Spacing.space24)
                        .padding(.horizontal, Spacing.space8)
                    }
                    .background(Color.vvWhite)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    Spacer()
                }
                .padding(.top, Paddings.defaultVerticalPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
            }
    }

}
