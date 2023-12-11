//
//  DistanceComputor.swift
//
//  Created by banie setijoso on 2023-12-10.
//

import Contacts
import CoreLocation
import Foundation

public class DistanceComputor: DistanceComputable {
    private let geocoder: CLGeocoder
    
    public init() {
        geocoder = CLGeocoder()
    }
    
    public func distanceInKmBetween(contact: Contact, deviceLocation: CLLocation) async throws -> (any DistanceRepresentable)? {
        guard let postalAddress = contact.postalAddress?.value else {
            logger.debug("contact.postalAddress is nil")
            return nil
        }
        
        guard let contactLocation = await fetchLocation(from: postalAddress) else {
            logger.debug("location from contact failed to be fetched")
            return nil
        }
        
        let distance = contactLocation.distance(from: deviceLocation) / 1000
        return DistanceContainer(contact: contact, deviceLocation: deviceLocation, distance: distance)
    }
    
    func fetchLocation(from postalAddress: CNPostalAddress) async -> CLLocation? {
        return await withCheckedContinuation { continuation in
            geocoder.geocodePostalAddress(postalAddress) { placemarks, error in
                if let error = error {
                    logger.debug("geocodePostalAddress from contact failed to be fetched \(error.localizedDescription)")
                }
                
                if let location = placemarks?.compactMap({$0.location}).first {
                    continuation.resume(returning: location)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
