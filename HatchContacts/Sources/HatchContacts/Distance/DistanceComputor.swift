//
//  DistanceComputor.swift
//
//  Created by banie setijoso on 2023-12-10.
//

import Contacts
import CoreLocation
import Foundation

public class DistanceComputor: DistanceComputable {
    
    public init() {}
    
    public func distanceInKmBetween(contact: Contact, deviceLocation: CLLocation) async throws -> (any DistanceRepresentable)? {
        guard let postalAddress = contact.postalAddress?.value else {
            return nil
        }
        
        guard let contactLocation = await fetchLocation(from: postalAddress) else {
            // log that location from contact failed to be fetched
            return nil
        }
        
        let distance = contactLocation.distance(from: deviceLocation)
        return DistanceContainer(contact: contact, deviceLocation: deviceLocation, distance: distance)
    }
    
    func fetchLocation(from postalAddress: CNPostalAddress) async -> CLLocation? {
        let geocoder = CLGeocoder()
        return await withCheckedContinuation { continuation in
            geocoder.geocodePostalAddress(postalAddress) { placemarks, error in
                if let placemark = placemarks?.first, let location = placemark.location {
                    continuation.resume(returning: location)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
