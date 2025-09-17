//
//  PhotoPickerView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/30/24.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView<Content: View>: View {
	@State private var photoPickerItem: PhotosPickerItem?
	private let emptyPhotoPickerItem = PhotosPickerItem(itemIdentifier: "")
	@Bindable var task: ScreenTask
	var action: (Data) async throws -> Void
	@ViewBuilder var label: () -> Content
	
    var body: some View {
		PhotosPicker(selection: $photoPickerItem) {
			label()
		}
		.onChange(of: photoPickerItem ?? emptyPhotoPickerItem) { oldValue, newValue in
            if oldValue != newValue {
                newValue.loadTransferable(type: Data.self) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data?):
                            Task {
                                try await task.run {
                                    try await action(data)
                                    return
                                }
                            }
                            break
                        case .success(nil):
                            break
                        case .failure(let error):
                            print(error)
                            break
                        }
                    }
                }
            }
		}
    }
}

#Preview {
	PhotoPickerView(task: ScreenTask()) { data in
		
	} label: {
		Image(systemName: "photo")
	}
}
