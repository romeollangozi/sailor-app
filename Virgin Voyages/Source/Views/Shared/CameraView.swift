//
//  CameraView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/27/24.
//

import SwiftUI
import AVKit

extension Data {
	func resize(targetSize: CGSize, compressionQuality: CGFloat) -> Data {
		if let image = UIImage(data: self) {
			let validateImage = image.scale(targetSize: targetSize)
			if let jpeg = validateImage.jpegData(compressionQuality: compressionQuality) {
				return jpeg
			}
		}
		
		return self
	}
}

extension UIDevice {
    static let pickerDidCaptureItem = Notification.Name("_UIImagePickerControllerUserDidCaptureItem")
    static let pickerDidRejectItem = Notification.Name("_UIImagePickerControllerUserDidRejectItem")
}

private class CameraOverlayUIView<Content: View>: UIView {
	private let hostingController: UIHostingController<Content>
	
	init(rootView: Content) {
		hostingController = UIHostingController(rootView: rootView)
		super.init(frame: .zero)
		setupHostingController()
		self.backgroundColor = .clear
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupHostingController() {
		guard let hostingView = hostingController.view else { return }
		
		hostingView.backgroundColor = .clear
		hostingView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(hostingView)
		
		NSLayoutConstraint.activate([
			hostingView.leadingAnchor.constraint(equalTo: leadingAnchor),
			hostingView.trailingAnchor.constraint(equalTo: trailingAnchor),
			hostingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			hostingView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
		])
	}
	
	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		return false
	}
}

private class CameraCoordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	var action: (Result<UIImage?, Error>) -> Void
	
	init(action: @escaping (Result<UIImage?, Error>) -> Void) {
		self.action = action
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		action(.success(nil))
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			action(.success(image))
		}
	}

    deinit {
        NotificationCenter.default.removeObserver(UIDevice.pickerDidRejectItem)
        NotificationCenter.default.removeObserver(UIDevice.pickerDidCaptureItem)
    }
}

private struct CameraViewRepresentable<OverlayView: View>: UIViewControllerRepresentable {
	var overlayView: OverlayView?
    @State var cameraDevice: UIImagePickerController.CameraDevice
    var action: (Result<UIImage?, Error>) -> Void

	func makeUIViewController(context: Context) -> UIViewControllerType {
		let viewController = UIImagePickerController()
		viewController.delegate = context.coordinator
		viewController.sourceType = .camera
        viewController.cameraDevice = cameraDevice

		if let overlayView {
			let cameraOverlayView = CameraOverlayUIView(rootView: overlayView)
			cameraOverlayView.frame = viewController.view.bounds
			viewController.cameraOverlayView = cameraOverlayView
            NotificationCenter.default.addObserver(forName: UIDevice.pickerDidRejectItem, object: nil, queue: nil) { _ in
                viewController.cameraOverlayView = cameraOverlayView
            }
		}
        NotificationCenter.default.addObserver(forName: UIDevice.pickerDidCaptureItem, object: nil, queue: nil) { _ in
            viewController.cameraOverlayView = nil
        }


		return viewController
	}
	
	func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
		
	}
	
	func makeCoordinator() -> CameraCoordinator {
		return CameraCoordinator(action: action)
	}
}


struct CameraView<OverlayView: View>: View {
	@Environment(\.dismiss) private var dismiss
	var compressionQuality: CGFloat
	@Bindable var task: ScreenTask
	var targetSize: CGSize?
    @State var cameraDevice: UIImagePickerController.CameraDevice = .front
    var action: (Data) async throws -> Void
    @ViewBuilder var overlay: () -> OverlayView

	var body: some View {
        CameraViewRepresentable(overlayView: overlay(), cameraDevice: cameraDevice) { result in
			switch result {
			case .success(nil):
				dismiss()
			case .success(let image?):
				dismiss()
				
				var targetImage = image
				if let targetSize {
					targetImage = image.scale(targetSize: targetSize)
				}
				
				if let data = targetImage.jpegData(compressionQuality: compressionQuality) {
					Task {
						try await task.run {
							try await action(data)
						}
					}
				}
			case .failure(let error):
				print(error)
			}
		}
		.ignoresSafeArea()
	}
}

struct CameraView_Previews: PreviewProvider {
	static var previews: some View {
		CameraView(compressionQuality: 0.6, task: ScreenTask()) { data in

		} overlay: {
			CameraSelfieOverlayView()
		}
	}
}
