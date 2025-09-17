//
//  ShakeForChampagnePermissionsView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/27/25.
//

import SwiftUI
import VVUIKit

protocol ShakeForChampagnePermissionsViewModelProtocol {
    
    var shouldShowLocationRecoveryAlert: Bool { get set }
    var shouldShowBluetoothOffAlert: Bool { get set }
    var shouldShowBluetoothPermissionRecoveryAlert: Bool { get set }
    
    func dismiss()
    func checkPermissions()
    func openAppSettings()
    func openBluetoothSettings()
    
}

struct ShakeForChampagnePermissionsView: View {
    
    @State var viewModel: ShakeForChampagnePermissionsViewModelProtocol
    var shakeForChampagne: ShakeForChampagne = ShakeForChampagne.empty()

    init(shakeForChampagne:ShakeForChampagne,
         onPermissionGranted: VoidCallback? = nil) {
        
        self.shakeForChampagne = shakeForChampagne
        _viewModel = State(wrappedValue: ShakeForChampagnePermissionsViewModel(onPermissionGranted: onPermissionGranted))
    }
    
    init(viewModel: ShakeForChampagnePermissionsViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        VStack {
            
            xButton()
                .padding(.top, Spacing.space24)
            
            VStack {
                VStack {
                    Text(shakeForChampagne.title)
                        .font(.vvHeading1Bold)
                        .foregroundStyle(Color.vvRed)
                        .multilineTextAlignment(.center)

                    Text(shakeForChampagne.description)
                        .font(.vvHeading1Bold)
                        .foregroundStyle(Color.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, Spacing.space40)
                
                Image("order_champagne_image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
                    .padding(.bottom, Spacing.space16)
                
                Text(shakeForChampagne.permission.description)
                    .font(.vvBody)
                    .foregroundStyle(Color.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, Spacing.space40)
            
            Spacer()
            
            VStack(spacing: Spacing.space16) {
                
                Button("Try again") {
                    viewModel.checkPermissions()
                }
                .buttonStyle(WhiteAdaptiveButtonStyle())
                
                Button {
                    viewModel.dismiss()
                } label: {
                    Text("Cancel")
                        .font(.vvBodyMedium)
                }
                .font(.vvBodyMedium)
                .buttonStyle(DismissServiceButtonStyle())
                .frame(maxWidth: .infinity)
                
            }
            .padding(.horizontal, Spacing.space24)
            .padding(.bottom, Spacing.space40)
            
        }
        .onAppear {
            viewModel.checkPermissions()
        }
        .alert("\"Virgin Voyages\" Would Like to use your location",
               isPresented: $viewModel.shouldShowLocationRecoveryAlert) {
            
            Button("Cancel") { }
                
            Button("Open app settings", role: .cancel) {
                viewModel.openAppSettings()
            }
            
        } message: {
            Text("We need to use your location to locate you to on the ship to deliver your Champagne.")
        }
        .alert("\"Virgin Voyages\" Would Like to use Bluetooth",
               isPresented: $viewModel.shouldShowBluetoothOffAlert) {
            Button("Cancel") { }
            Button("Open app settings", role: .cancel) {
                viewModel.openBluetoothSettings()
            }
        } message: {
            Text("We need to use your location to locate you to on the ship to deliver your Champagne.")
        }
        .alert("\"Virgin Voyages\" Would Like to use Bluetooth",
               isPresented: $viewModel.shouldShowBluetoothPermissionRecoveryAlert) {
            Button("Cancel") { }
            Button("Open app settings", role: .cancel) {
                viewModel.openAppSettings()
            }
        } message: {
            Text("We need to use your location to locate you to on the ship to deliver your Champagne.")
        }
        .alertButtonTint(color: Color(uiColor: .systemBlue))
        
    }
    
    private func xButton() -> some View {
        
        HStack {
            Spacer()
                
                BackButton({
                    viewModel.dismiss()
                },
                           isCircleButton: true,
                           buttonIconName: "xmark.circle.fill")
                .frame(width: 32, height: 32)
                .opacity(0.8)
                .background(.clear)
        }
        .padding(.trailing, Spacing.space16)        
    }
}

struct MockShakeForChampagnePermissionsViewModel: ShakeForChampagnePermissionsViewModelProtocol {
    var shouldShowLocationRecoveryAlert = false
    
    var shouldShowBluetoothOffAlert = false
    
    var shouldShowBluetoothPermissionRecoveryAlert = false
    
    func dismiss() {
        
    }
    
    func checkPermissions() {
        
    }
    
    func openAppSettings() {
        
    }
    
    func openBluetoothSettings() {
        
    }
}

#Preview {
    ShakeForChampagnePermissionsView(viewModel: MockShakeForChampagnePermissionsViewModel())
        .background(Color.black)
}
