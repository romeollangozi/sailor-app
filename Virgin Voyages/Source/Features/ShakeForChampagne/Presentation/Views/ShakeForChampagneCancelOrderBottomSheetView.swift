//
//  ShakeForChampagneCancelOrderBottomSheetView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/4/25.
//

import SwiftUI
import VVUIKit

struct ShakeForChampagneCancelOrderBottomSheetView: View {
    
    @Binding var isLoading: Bool
    var errorMessage: String?
    let shakeForChampagne: ShakeForChampagne
    let onCancelChampagne: VoidCallback?
    let onDismiss: VoidCallback?
    
    init(isLoading: Binding<Bool>,
         errorMessage: String?,
         shakeForChampagne: ShakeForChampagne,
         onCancelChampagne: VoidCallback? = nil,
         onDismiss: VoidCallback? = nil) {
        
        self._isLoading = isLoading
        self.errorMessage = errorMessage
        self.shakeForChampagne = shakeForChampagne
        self.onCancelChampagne = onCancelChampagne
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        VStack {
            
            xButton()
            
            VStack(alignment: .leading, spacing: Spacing.space16) {
                
                Text(shakeForChampagne.cancellation.title)
                    .foregroundStyle(.white)
                    .font(.vvHeading3Bold)
                
                Text(shakeForChampagne.cancellation.description)
                    .foregroundStyle(Color.borderGray)
                    .font(.vvSmall)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.space24)
            .padding(.vertical, Spacing.space16)
            
            if let errorMessage = self.errorMessage {
                StatusCardView.warning(title: "Please try again",
                                       body: errorMessage)
                .padding(.horizontal, Spacing.space24)
            }
            
            VStack(spacing: Spacing.space16) {
                
                PrimaryButton(shakeForChampagne.cancellation.cancelButton,
                              padding: Spacing.space0,
                              isLoading: isLoading) {
                    
                    onCancelChampagne?()
                    
                }
                
                Button(shakeForChampagne.cancellation.continueButton) {
                    onDismiss?()
                }
                .buttonStyle(WhiteAdaptiveButtonStyle())
                .opacity(isLoading ? 0.5 : 1.0)
                .disabled(isLoading)
            }
            .padding(.horizontal, Spacing.space24)
            .padding(.top, Spacing.space24)
            
            Spacer()
            
        }
        .background(Color.vvBlack)
        .ignoresSafeArea()
    }
    
    private func xButton() -> some View {
        
        HStack {
            Spacer()
                
                BackButton({
                    onDismiss?()
                },
                           isCircleButton: true,
                           buttonIconName: "xmark.circle.fill")
                .frame(width: 32, height: 32)
                .opacity(isLoading ?  0.4 : 0.8)
                .background(.clear)
                .disabled(isLoading)
        }
        .padding(.trailing, Spacing.space16)
        .padding(.top, Spacing.space24)
        
    }
}

#Preview {
    
    @Previewable @State var isLoading = false
    
    ShakeForChampagneCancelOrderBottomSheetView(isLoading: $isLoading,
                                                errorMessage: "error error error",
                                                shakeForChampagne: ShakeForChampagne.sample(),
                                                onCancelChampagne: {},
                                                onDismiss: {})
}
