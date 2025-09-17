//
//  VVNativePhotoPickerView.swift
//  VVUIKit
//
//  Created by Enxhi Kondakciu on 22.4.25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

public struct VVNativePhotoPickerView: UIViewControllerRepresentable {
    
    @Binding public var imageData: Data?
    @Environment(\.presentationMode) private var presentationMode

    public init(imageData: Binding<Data?>) {
        self._imageData = imageData
    }

    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: VVNativePhotoPickerView

        public init(_ parent: VVNativePhotoPickerView) {
            self.parent = parent
        }

        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()

            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else {
                return
            }

            provider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    let compressedData = image.jpegData(compressionQuality: 0.5)
                    DispatchQueue.main.async {
                        self.parent.imageData = compressedData
                    }
                }
            }
        }
    }
}
