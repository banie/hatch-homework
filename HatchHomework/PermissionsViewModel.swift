//
//  PermissionsViewModel.swift
//  HatchHomework
//
//  Created by hatch.co
//

import HatchContacts
import SwiftData

@Observable
class PermissionsViewModel {
    // MARK: Internal vars
    
    var hasAllRequiredPermissions: Bool {
        statuses.allSatisfy { $0 == .authorized }
    }
    
    var hasDeniedPermissions: Bool {
        statuses.contains { $0 == .unauthorized }
    }
    
    // MARK: Private vars
    
    private var statuses: [AuthorizationStatus] {
        [
            contactManager.authorizationStatus,
            locationManager.authorizationStatus
        ]
    }
    
    private let contactManager: ContactManager
    private let locationManager: LocationManager
    
    // MARK: Init
    
    init(
        contactManager: ContactManager,
        locationManager: LocationManager
    ) {
        self.contactManager = contactManager
        self.locationManager = locationManager
    }
}
