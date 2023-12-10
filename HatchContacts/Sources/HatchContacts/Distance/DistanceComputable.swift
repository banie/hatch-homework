//
//  DistanceComputable.swift
//  HatchHomework
//
//  Created by hatch.co
//

import Contacts
import CoreLocation
import Foundation

public protocol DistanceComputable {
    func distanceInKmBetween(
        contact: Contact,
        deviceLocation: CLLocation
    ) async throws -> (any DistanceRepresentable)?
}

public class DistanceComputor: DistanceComputable {
    public func distanceInKmBetween(contact: Contact, deviceLocation: CLLocation) async throws -> (any DistanceRepresentable)? {
        
        
        DistanceContainer(contact: contact, deviceLocation: deviceLocation, distance: <#T##Double#>)
    }
}

public protocol DistanceRepresentable: Identifiable {
    var contact: Contact { get }
    var deviceLocation: CLLocation { get }
    var distance: Double { get }
}


