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
            logger.debug("contact.postalAddress is nil")
            return nil
        }
        
        guard let contactLocation = try await fetchLocation(from: postalAddress) else {
            logger.debug("Location from contact failed to be fetched")
            return nil
        }
        
        let distance = contactLocation.distance(from: deviceLocation) / 1000
        return DistanceContainer(contact: contact, deviceLocation: deviceLocation, distance: distance)
    }
    
    func fetchLocation(from postalAddress: CNPostalAddress) async throws -> CLLocation? {
        return try await CLGeocoder().geocodePostalAddress(postalAddress).compactMap({$0.location}).first
    }
}
