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
    
    @State var contact: Contact
    
    @State private var distanceContainer: (any DistanceRepresentable)?
    
    private let distanceComputor = DistanceComputor()
    
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
        }.onChange(of: locationManager.locationUpdated) {
            if let deviceLocation = locationManager.currentLocation {
                fetchDistanceRepresentable(with: deviceLocation)
            }
        }
    }
    
    private func fetchDistanceRepresentable(with deviceLocation: CLLocation) {
        Task.detached {
            distanceContainer = try await distanceComputor.distanceInKmBetween(contact: contact, deviceLocation: deviceLocation)
        }
    }
}

#Preview("ContactView") {
    ContactView(contact: .placeholder())
}
