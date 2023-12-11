//
//  LocationComputable.swift
//  
//  Created by banie setijoso on 2023-12-11.
//

import CoreLocation
import Contacts
import Foundation

public protocol LocationComputable {
    func fetchLocation(from postalAddress: CNPostalAddress) async -> CLLocation?
}

public class LocationComputor: LocationComputable {
    public init() {}
    
    public func fetchLocation(from postalAddress: CNPostalAddress) async -> CLLocation? {
        do {
            return try await CLGeocoder().geocodePostalAddress(postalAddress).compactMap({$0.location}).first
        } catch {
            logger.debug("No location is found for postalAddress: \(postalAddress)")
            return nil
        }
    }
}
