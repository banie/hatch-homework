//
//  ContactsView.swift
//  HatchHomework
//
//  Created by hatch.co
//

import HatchContacts
import SwiftUI

struct ContactsView: View {
    @Environment(ContactManager.self)
    private var contactManager: ContactManager
    
    @Environment(LocationManager.self)
    private var locationManager: LocationManager
    
    @Environment(PermissionsViewModel.self)
    private var permissionsViewModel: PermissionsViewModel
    
    @State private var isPermissionSheetPresented = false
        
    private let distanceComputor = DistanceComputor()
    
    var body: some View {
        NavigationView {
            List(contactManager.contacts) { contact in
                ContactView(distanceComputor: distanceComputor, contact: contact)
                    .environment(LocationManager.shared)
            }
            .navigationBarTitle("Contacts", displayMode: .inline)
            
            .toolbar {
                #if targetEnvironment(simulator)
                    // For simulators, allow importing of fake contacts
                    Button("Import", systemImage: "person.crop.circle.badge.plus") {
                        do {
                            try ContactImporter.shared.importContactsFromJson()
                            refreshContacts()
                        } catch ContactImporter.Error.alreadyImported {
                            logger.error("Contact have already been imported.")
                        } catch {
                            logger.fault("Failed to import contacts from json file: \(error.localizedDescription)")
                        }
                    }
                    .disabled(ContactImporter.Defaults.contactsImported())
                #endif
            }
            .refreshable {
                refreshContacts()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            guard !isPreview else { return }
            
            if !permissionsViewModel.hasAllRequiredPermissions, !isPermissionSheetPresented {
                isPermissionSheetPresented = true
                return
            }
            refreshContacts()
            locationManager.requestAuthorization(authorizationChanged: nil)
        }
        .sheet(isPresented: $isPermissionSheetPresented) {
            PermissionsView()
        }
        .onChange(of: permissionsViewModel.hasAllRequiredPermissions) { hadPermissions, hasPermissions in
            guard !isPreview else { return }
            
            if !hadPermissions, hasPermissions, isPermissionSheetPresented {
                isPermissionSheetPresented = false
                refreshContacts()
            }
        }
    }
    
    private func refreshContacts() {
        Task {
            try await contactManager.loadContacts()
        }
    }
}

#Preview("ContactsView") {
    ContactsView()
        .environment(ContactManager.shared)
        .environment(LocationManager.shared)
        .environment(
            PermissionsViewModel(
                contactManager: ContactManager.shared,
                locationManager: LocationManager.shared
            )
        )
}

extension View {
    var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
