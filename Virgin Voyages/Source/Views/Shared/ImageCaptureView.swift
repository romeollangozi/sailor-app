//
//  ImageCaptureView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/30/24.
//

import SwiftUI
import AVFoundation

struct ImageCaptureView<Content: View, OverlayContent: View>: View {
	@Bindable var task: ScreenTask
    @State var cameraDevice: UIImagePickerController.CameraDevice = .front
    var action: (Data) async throws -> Void
    @State private var showCamera = false
    @State private var showSettingsAlert = false
    @Environment(\.openURL) private var openURL
    @ViewBuilder var label: () -> Content
    @ViewBuilder var overlay: () -> OverlayContent

#if targetEnvironment(simulator)
    var body: some View {
		PhotoPickerView(task: task) { data in
			try await action(data)
		} label: {
			label()
		}
    }
#else
	var body: some View {
		Button {
            Task {
                let granted = await checkCameraPermission()
                guard granted else {
                    showSettingsAlert = true
                    return
                }
                showCamera = true
            }
		} label: {
			label()
		}
		.fullScreenCover(isPresented: $showCamera) {
            CameraView(compressionQuality: 0.5, task: task, cameraDevice: cameraDevice) { data in
				try await action(data)
			} overlay: {
				overlay()
			}
		}
        .alert("Permission not granted", isPresented: $showSettingsAlert) {
            Button("OK") {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Hey Sailor! To use this, permission required for camera. Do you wish to open the app's settings?")
        }
	}
#endif
}

#Preview {
	@State var task = ScreenTask()
	return ImageCaptureView(task: task) { data in
		
	} label: {
		Text("Capture")
    } overlay: {
        CameraSelfieOverlayView()
    }
}
