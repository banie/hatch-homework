//
//  DistanceComputor.swift
//
//  Created by banie setijoso on 2023-12-10.
//

import Contacts
import CoreLocation
import Foundation

public actor DistanceComputor: DistanceComputable {
    
    private var cache: [String: DistanceContainer?]
    private let locationComputor: LocationComputable
    
    public init(locationComputor: LocationComputable = LocationComputor()) {
        cache = [:]
        self.locationComputor = locationComputor
    }
    
    public func distanceInKmBetween(contact: Contact, deviceLocation: CLLocation) async throws -> (any DistanceRepresentable)? {
        guard let postalAddress = contact.postalAddress?.value else {
            logger.debug("postalAddress of \(contact.id) is nil")
            return nil
        }
        
        if let distanceContainer = cache[contact.id] {
            return distanceContainer
        }
        
        guard let contactLocation = await locationComputor.fetchLocation(from: postalAddress) else {
            cache.updateValue(nil, forKey: contact.id)
            return nil
        }
        
        let distance = contactLocation.distance(from: deviceLocation) / 1000
        let distanceContainer = DistanceContainer(contact: contact, deviceLocation: deviceLocation, distance: distance)
        cache.updateValue(distanceContainer, forKey: contact.id)
        
        return distanceContainer
    }
}
