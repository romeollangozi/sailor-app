//
//  ZoomableScrollView.swift
//  Virgin Voyages
//
//  Created by TX on 18.6.25.
//
import SwiftUI
import UIKit

public struct ZoomableScrollView<Content: View>: UIViewRepresentable {
    let imageHeight: CGFloat
    let content: () -> Content
    let onSingleVerticalDrag: (() -> Void)?

    public init(imageHeight: CGFloat,
         onSingleVerticalDrag: (() -> Void)? = nil,
         @ViewBuilder content: @escaping () -> Content) {
        self.imageHeight = imageHeight
        self.content = content
        self.onSingleVerticalDrag = onSingleVerticalDrag
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(onSingleVerticalDrag: onSingleVerticalDrag, content: content)
    }

    public func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.backgroundColor = .black
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bouncesZoom = true

        guard let contentView = context.coordinator.hostingController.view else {
            return scrollView
        }

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: imageHeight)
        ])

        let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)

        let panGesture = scrollView.panGestureRecognizer
        panGesture.addTarget(context.coordinator, action: #selector(context.coordinator.handlePan(_:)))

        return scrollView
    }

    public func updateUIView(_ uiView: UIScrollView, context: Context) {
        context.coordinator.hostingController.rootView = content()
        DispatchQueue.main.async {
            if !context.coordinator.didInitialCentering {
                uiView.layoutIfNeeded()
                context.coordinator.centerContent(uiView)
                context.coordinator.didInitialCentering = true
            }
        }

    }

    public class Coordinator: NSObject, UIScrollViewDelegate {
        var didInitialCentering = false
        var onSingleVerticalDrag: (() -> Void)?
        let hostingController: UIHostingController<Content>

        public init(onSingleVerticalDrag: (() -> Void)?, content: @escaping () -> Content) {
            self.onSingleVerticalDrag = onSingleVerticalDrag
            self.hostingController = UIHostingController(rootView: content())
        }

        public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            hostingController.view
        }

        func scrollViewDidLayoutSubviews(_ scrollView: UIScrollView) {
            if !didInitialCentering {
                centerContent(scrollView)
                didInitialCentering = true
            }
        }

        public func scrollViewDidZoom(_ scrollView: UIScrollView) {
            centerContent(scrollView)
        }

        func centerContent(_ scrollView: UIScrollView) {
            guard hostingController.view != nil else { return }

            let scrollViewSize = scrollView.bounds.size
            let contentSize = scrollView.contentSize

            let verticalInset = max((scrollViewSize.height - contentSize.height) / 2, 0)
            let horizontalInset = max((scrollViewSize.width - contentSize.width) / 2, 0)

            scrollView.contentInset = UIEdgeInsets(
                top: verticalInset,
                left: horizontalInset,
                bottom: verticalInset,
                right: horizontalInset
            )
        }

        @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
            guard let scrollView = gesture.view as? UIScrollView else { return }

            if scrollView.zoomScale != 1.0 {
                scrollView.setZoomScale(1.0, animated: true)
            } else {
                let pointInView = gesture.location(in: hostingController.view)
                let zoomRect = zoomRectForScale(scale: 2.5, center: pointInView, in: scrollView)
                scrollView.zoom(to: zoomRect, animated: true)
            }
        }

        private func zoomRectForScale(scale: CGFloat, center: CGPoint, in scrollView: UIScrollView) -> CGRect {
            let width = scrollView.bounds.width / scale
            let height = scrollView.bounds.height / scale
            let origin = CGPoint(x: center.x - width / 2, y: center.y - height / 2)
            return CGRect(origin: origin, size: CGSize(width: width, height: height))
        }

        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard let scrollView = gesture.view as? UIScrollView else { return }

            if gesture.state == .began {
                let translation = gesture.translation(in: scrollView.superview)
                let isVerticalDrag = abs(translation.y) > abs(translation.x) && abs(translation.y) > 10

                if (0.99...1.01).contains(scrollView.zoomScale) && isVerticalDrag {
                    onSingleVerticalDrag?()
                }
            }
        }
    }
}

