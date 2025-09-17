//
//  ShakeForChampagneOrderErrorView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/21/25.
//

import SwiftUI
import VVUIKit

struct ShakeForChampagneOrderErrorView: View {
    
    @State private var animate = false
    
    private var onDismiss: VoidCallback?
    private var onTryAgain: VoidCallback?
    
    let topOffset: CGFloat = -50
    let bottomOffset: CGFloat = 50
    
    init(onDismiss: VoidCallback? = nil,
         onTryAgain: VoidCallback? = nil) {
        
        self.onDismiss = onDismiss
        self.onTryAgain = onTryAgain
    }
    
    var body: some View {
        
        VStack {
            
            toolbar
                .padding(.top, Spacing.space16)
                .padding(.trailing, Spacing.space16)
            
            Spacer()
            
            VStack(spacing: Spacing.space16) {
                Text("Hey sailor".uppercased())
                    .font(.vvSmallBold)
                    .foregroundStyle(Color.mediumGray)
                    .multilineTextAlignment(.center)

                Rectangle()
                    .frame(width: 64, height: 2)
                    .foregroundColor(.vvRed)

                Text("Oops… we were unable to take your order.")
                    .font(.vvVesterbroHeading3Bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .fixedSize(horizontal: false, vertical: true)
                    
            }
            .padding(.horizontal, Spacing.space40)
            .opacity(animate ? 1 : 0)
            .offset(y: animate ? 0 : topOffset)
            .animation(.easeInOut(duration: 0.8), value: animate)
            .onAppear {
                animate = true
            }
            
            Spacer()
            
            VStack(spacing: Spacing.space16) {
                
                Button("Try again") {
                    onTryAgain?()
                }
                .buttonStyle(WhiteAdaptiveButtonStyle())
                
                Button {
                    onDismiss?()
                } label: {
                    Text("Cancel")
                        .font(.vvBodyMedium)
                }
                .font(.vvBodyMedium)
                .buttonStyle(DismissServiceButtonStyle())
                .frame(maxWidth: .infinity)
                
            }
            .padding(.horizontal, Spacing.space24)
            .padding(.bottom, Spacing.space40)
            .opacity(animate ? 1 : 0)
            .offset(y: animate ? 0 : bottomOffset)
            .animation(.easeInOut(duration: 0.8).delay(0.3), value: animate)
            
        }
        .background(Color.vvBlack)
        
    }
    
    private var toolbar: some View {
        HStack {
            Spacer()
            ClosableButton(action: {
                onDismiss?()
            })
        }
    }
    
}

#Preview {
    ShakeForChampagneOrderErrorView()
}
