//
//  SafeAreaReader.swift
//  Virgin Voyages
//
//  Created by TX on 8.4.25.
//

import SwiftUI

struct SafeAreaReader: UIViewRepresentable {
    var onChange: (UIEdgeInsets) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            if let window = view.window ?? UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) {
                self.onChange(window.safeAreaInsets)
            }
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
