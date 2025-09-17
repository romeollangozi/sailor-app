//
//  Image+Data.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 3.9.24.
//

import SwiftUI

extension Image {
    
    init(data: Data?) {
        if let data = data, let uiImage = UIImage(data: data) {
            self.init(uiImage: uiImage)
        } else {
            self.init("")
        }
    }
    
    init(uiImageWithData image: UIImage) {
        self = Image(uiImage: image)
    }
}
