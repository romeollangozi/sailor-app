//
//  ReCaptchaView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 13.9.24.
//

import SwiftUI
import VVUIKit


struct ReCaptchaView: View {
    
    // MARK: - State properties
    @State private var viewModel: ReCaptchaViewModelProtocol

    // MARK: - Properties
    var confirmed: (Bool, String?) -> ()
    
    // MARK: - Init
    init(viewModel: ReCaptchaViewModelProtocol, confirmed: @escaping (Bool, String?) -> Void) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.confirmed = confirmed
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack (alignment: .center, spacing: .zero) {
                Button(action: {
                    viewModel.verifyToken()
                }) {
                    if viewModel.isLoading {
                        MaterialLoadingSquare()
                    } else {
                        CheckmarkSquareOrOutline(didPass: viewModel.reCaptchaStatus.status)
                    }
                }
                .frame(width: 28.0, height: 28.0)
                .disabled(viewModel.reCaptchaStatus.status)
                .padding(.horizontal, 14)
                .padding(.vertical, 24)
                
                Text("I'm not a robot")
                    .font(.system(size: 16))
                    .foregroundColor(.darkGray)
                
                Spacer()
                
                Image("reCAPTCHA")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 62, height: 62)
                    .padding(.trailing, 13)
                
            }
            .padding(.zero)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(statusColor(), lineWidth: 0.5)
                
            )
            .background(Color(hex: "f8f8f8"))
            .shadow(color: shadowColor(), radius: 2)
            
            Text(viewModel.error.value)
                .font(.vvSmall)
                .foregroundStyle(Color.orangeDark)
                .frame(height: 16.0)
        }
        .onChange(of: viewModel.reCaptchaStatus, { oldValue, newValue in
            confirmed(newValue.status, newValue.token)
        })
    }
    
    func statusColor() -> Color {
        guard (viewModel.error) != nil else {
            return .vvGray.opacity(0.2)
        }
        return Color.vvRed
    }
    
    private func shadowColor() -> Color {
        guard (viewModel.error) != nil else {
            return .vvGray.opacity(0.2)
        }
        return .clear
    }
    
}

struct ReCaptchaView_Previews: PreviewProvider {
    static var previews: some View {
        ReCaptchaView(viewModel: ReCaptchaViewModel(action: "")) {_,_ in
            
        }
    }
}
