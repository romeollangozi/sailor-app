//
//  SignUpProfileImageViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 3.9.24.
//

import SwiftUI

protocol SignUpProfileImageViewModelProtocol {
    var signUpInputModel: SignUpInputModel { set get }
    var cameraTask: ScreenTask { set get }
    func setupImage(from data: Data) 
    
    func navigateBack()
    func navigateToSocialProfileView()
    func navigateToProfilePhotoView()
}

@Observable class SignUpProfileImageViewModel: SignUpProfileImageViewModelProtocol {
    
    private var appCoordinator: CoordinatorProtocol
    // MARK: - Properties
    var signUpInputModel: SignUpInputModel
    var cameraTask: ScreenTask = ScreenTask()
    
    // MARK: - Init
    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared, signUpInputModel: SignUpInputModel, cameraTask: ScreenTask = ScreenTask()) {
        self.appCoordinator = appCoordinator
        self.signUpInputModel = signUpInputModel
    }
    
    func setupImage(from data: Data) {
        signUpInputModel.imageData = data
    }
    
    func navigateBack() {
        appCoordinator.executeCommand(SignupCoordinator.GoBackCommand())
    }
    
    func navigateToSocialProfileView() {
        appCoordinator.executeCommand(SignupCoordinator.OpenSocialProfileViewCommand(signUpInputModel: signUpInputModel))
    }
    
    func navigateToProfilePhotoView() {
        appCoordinator.executeCommand(SignupCoordinator.OpenProfileImageViewCommand(signUpInputModel: signUpInputModel))
    }

}
