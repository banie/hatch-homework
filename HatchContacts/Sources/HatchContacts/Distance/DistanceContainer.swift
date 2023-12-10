//
//  DistanceContainer.swift
//
//  Created by banie setijoso on 2023-12-10.
//

import Foundation
import CoreLocation

public struct DistanceContainer: DistanceRepresentable {
    public var id: String {
        contact.identifier
    }
    
    public var contact: Contact
    
    public var deviceLocation: CLLocation
    
    public var distance: Double
}
