//
//  NoTopBounceWithinScrollView.swift
//  VVUIKit
//
//  Created by TX on 4.4.25.
//

import SwiftUI

struct NoTopBounceScrollViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(NoTopBounceScrollViewIntrospector())
    }
}

struct NoTopBounceScrollViewIntrospector: UIViewRepresentable {

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.isHidden = true

        DispatchQueue.main.async {
            guard let scrollView = findEnclosingScrollView(from: view) else { return }
            scrollView.delegate = context.coordinator
            context.coordinator.scrollView = scrollView
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    private func findEnclosingScrollView(from view: UIView?) -> UIScrollView? {
        var current = view?.superview
        while let view = current {
            if let scrollView = view as? UIScrollView {
                return scrollView
            }
            current = view.superview
        }
        return nil
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        weak var scrollView: UIScrollView?

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let yOffset = scrollView.contentOffset.y

            if yOffset < 0 {
                scrollView.contentOffset = CGPoint(x: 0, y: 0)
            }
        }
    }
}

extension View {
    public func noTopBounceWithinScrollView() -> some View {
        self.modifier(NoTopBounceScrollViewModifier())
    }
}
