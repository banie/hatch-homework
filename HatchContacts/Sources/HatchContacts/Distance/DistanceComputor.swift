//
//  DistanceComputor.swift
//
//  Created by banie setijoso on 2023-12-10.
//

import Contacts
import CoreLocation
import Foundation

public actor DistanceComputor: DistanceComputable {
    
    var cache: [String: CLLocation?] = [:]
    
    public init() {}
    
    public func distanceInKmBetween(contact: Contact, deviceLocation: CLLocation) async throws -> (any DistanceRepresentable)? {
        guard let postalAddress = contact.postalAddress?.value else {
            logger.debug("postalAddress of \(contact.id) is nil")
            return nil
        }
        
        guard let contactLocation = await fetchLocation(from: contact.id, postalAddress: postalAddress) else {
            return nil
        }
        
        let distance = contactLocation.distance(from: deviceLocation) / 1000
        return DistanceContainer(contact: contact, deviceLocation: deviceLocation, distance: distance)
    }
    
    private func fetchLocation(from contactId: String, postalAddress: CNPostalAddress) async -> CLLocation? {
        if let location = cache[contactId] {
            return location
        }
        
        let location: CLLocation?
        do {
            location = try await CLGeocoder().geocodePostalAddress(postalAddress).compactMap({$0.location}).first
        } catch {
            logger.debug("No location is found for contact: \(contactId)")
            location = nil
        }
        
        cache.updateValue(location, forKey: contactId)
        return location
    }
}
