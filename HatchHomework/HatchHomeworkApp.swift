//
//  HatchHomeworkApp.swift
//  HatchHomework
//
//  Created by hatch.co
//

import HatchContacts
import SwiftUI

@main
struct HatchHomeworkApp: App {
    @State private var permissionsViewModel = PermissionsViewModel(
        contactManager: ContactManager.shared,
        locationManager: LocationManager.shared
    )
    
    var body: some Scene {
        WindowGroup {
            ContactsView()
                .environment(ContactManager.shared)
                .environment(LocationManager.shared)
                .environment(permissionsViewModel)
        }
    }
}
