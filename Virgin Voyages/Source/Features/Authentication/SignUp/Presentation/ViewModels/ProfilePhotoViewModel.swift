//
//  ProfilePhotoViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 3.9.24.
//

import SwiftUI

protocol ProfilePhotoViewModelProtocol {
    var signUpInputModel: SignUpInputModel { set get }
    var cameraTask: ScreenTask { set get }
    var profileImage: Image { get }
    
    func navigateBack()
    func navigateToSocialProfileView()
}

@Observable class ProfilePhotoViewModel: ProfilePhotoViewModelProtocol {
    
    var appCoordinator: CoordinatorProtocol
    
    // MARK: - Properties
    var signUpInputModel: SignUpInputModel
    var cameraTask: ScreenTask = ScreenTask()
    var profileImage: Image {
        guard let imageData = signUpInputModel.imageData else { return Image("ProfilePlaceholder")}
        return Image(data: imageData)
    }
    
    // MARK: - Init
    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared, signUpInputModel: SignUpInputModel, cameraTask: ScreenTask = ScreenTask()) {
        self.appCoordinator = appCoordinator
        self.signUpInputModel = signUpInputModel
    }
    
    func navigateBack() {
        appCoordinator.executeCommand(SignupCoordinator.GoBackCommand())
    }
    
    func navigateToSocialProfileView() {
        appCoordinator.executeCommand(SignupCoordinator.OpenSocialProfileViewCommand(signUpInputModel: signUpInputModel))
    }
        
}
