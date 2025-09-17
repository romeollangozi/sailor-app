//
//  ProfilePlaceholderView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 22.1.25.
//


import SwiftUI

public struct ProfilePlaceholderView: View {

    public var body: some View {
        Image("ProfilePlaceholder")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .modifier(SailorPhotoModifier(style: .unselected, size: Sizes.drawerButtonWidth))
    }
}

#Preview {
    ProfilePlaceholderView()
}
