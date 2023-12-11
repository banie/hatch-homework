//
//  ContactView.swift
//  HatchHomework
//
//  Created by hatch.co
//

import HatchContacts
import SwiftUI
import CoreLocation

struct ContactView: View {
    @Environment(LocationManager.self)
    private var locationManager: LocationManager
    
    let distanceComputor: DistanceComputable
    
    @State var contact: Contact
    @State private var distanceContainer: (any DistanceRepresentable)?
    @State private var isVisible = false
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text("\(contact.name)")
                .font(.body)
                .italic()
            
            if let postalAddressDescription = contact.postalAddressDescription {
                Text("\(postalAddressDescription)")
                    .font(.callout)
            }
            
            if let distanceContainer = distanceContainer {
                Text("Distance: \(String(format: "%.2f km", distanceContainer.distance))")
                    .font(.callout)
                    .foregroundColor(.red)
            }
            
            Text("\(contact.identifier)")
                .font(.caption2)
        }
        .onAppear {
            isVisible = true
            fetchDistanceRepresentable()
        }
        .onDisappear {
            isVisible = false
        }
        .onChange(of: locationManager.locationUpdated) {
            if isVisible {
                logger.debug("xxxx locationUpdated is triggered, update visible rows")
                fetchDistanceRepresentable()
            }
        }
    }
    
    private func fetchDistanceRepresentable() {
        guard let deviceLocation = locationManager.currentLocation else {
            return
        }
        Task.detached {
            distanceContainer = try await distanceComputor.distanceInKmBetween(contact: contact, deviceLocation: deviceLocation)
        }
    }
}

#Preview("ContactView") {
    ContactView(distanceComputor: DistanceComputor(), contact: .placeholder())
}
