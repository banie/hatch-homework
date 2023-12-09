//
//  PermissionsView.swift
//  HatchHomework
//
//  Created by hatch.co
//

import HatchContacts
import SwiftUI

struct PermissionsView: View {
    @Environment(ContactManager.self)
    private var contactManager: ContactManager
    
    @Environment(LocationManager.self)
    private var locationManager: LocationManager
    
    @Environment(PermissionsViewModel.self)
    private var permissionsViewModel: PermissionsViewModel
    
    @State
    private var isAlertPresented = false
    
    var body: some View {
        VStack {
            Text("Permissions Required")
                .font(.title)
                .padding(.top, 10)
            
            Spacer()
            
            Text("This app requires access to both Contacts and CoreLocation. Tap the buttons below to grant access to each.")
                .font(.body)
            
            Spacer()
            
            VStack(spacing: 10) {
                PermissionButton(
                    title: "Access Contacts",
                    foregroundColor: contactManager.authorizationStatus.buttonColor
                ) {
                    contactManager.requestAuthorization { authorizationStatus in
                        logger.debug("contactManager authorizationStatus: \(authorizationStatus)")
                        
                        if authorizationStatus == .unauthorized {
                            isAlertPresented = true
                        }
                    }
                }
                
                PermissionButton(
                    title: "Access Location",
                    foregroundColor: locationManager.authorizationStatus.buttonColor
                ) {
                    locationManager.requestAuthorization { authorizationStatus in
                        logger.debug("locationManager authorizationStatus: \(authorizationStatus)")
                        
                        if authorizationStatus == .unauthorized {
                            isAlertPresented = true
                        }
                    }
                }
            }
        }
        .padding()
        .alert("Status: Unauthorized", isPresented: $isAlertPresented, actions: {
            Button("No", role: .cancel) {}
            Button("Yes", role: .none) {
                guard let url = URL(string: UIApplication.openSettingsURLString) else {
                    assertionFailure("Must be able to get app settings url")
                    return
                }
                UIApplication.shared.open(url)
            }
        }, message: {
            Text("Would you like to change authorization status in HatchHomework app settings?")
        })
        .interactiveDismissDisabled()
        .onAppear {
            if permissionsViewModel.hasDeniedPermissions {
                isAlertPresented = true
            }
        }
    }
}

extension AuthorizationStatus {
    var buttonColor: Color {
        switch self {
        case .notDetermined: .primary
        case .authorized: .green
        case .unauthorized: .red
        }
    }
}

#Preview("PermissionsView") {
    PermissionsView()
        .environment(ContactManager.shared)
        .environment(LocationManager.shared)
        .environment(
            PermissionsViewModel(
                contactManager: ContactManager.shared,
                locationManager: LocationManager.shared
            )
        )
}
