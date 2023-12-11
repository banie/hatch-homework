//
//  DistanceComputorTests.swift
//  HatchHomeworkTests
//
//  Created by banie setijoso on 2023-12-11.
//

import XCTest
import CoreLocation
import Contacts

@testable import HatchContacts

final class DistanceComputorTests: XCTestCase {
    
    private var locationComputorSpy: LocationComputableSpy!
    private var distanceComputor: DistanceComputor!
    
    override func setUpWithError() throws {
        locationComputorSpy = LocationComputableSpy()
        distanceComputor = DistanceComputor(locationComputor: locationComputorSpy)
    }

    func testNoLocation() async throws {
        let dummyContact = Contact.placeholder()
        let appleHQLocation = CLLocation(latitude: 37.334606, longitude: -122.009102)
        
        locationComputorSpy.mockedLocation = nil
        let distanceContainer = try await distanceComputor.distanceInKmBetween(contact: dummyContact, deviceLocation: appleHQLocation)
        
        XCTAssertNil(distanceContainer)
    }
    
    func testAppleToGoogleDistance() async throws {
        let dummyContact = Contact.placeholder()
        let appleHQLocation = CLLocation(latitude: 37.334606, longitude: -122.009102)
        let googlePlexLocation = CLLocation(latitude: 37.334606, longitude: -122.009102)
        
        locationComputorSpy.mockedLocation = googlePlexLocation
        let distanceContainer = try await distanceComputor.distanceInKmBetween(contact: dummyContact, deviceLocation: appleHQLocation)
        let calculatedDistance = googlePlexLocation.distance(from: appleHQLocation) / 1000
        XCTAssertEqual(calculatedDistance, distanceContainer?.distance)
    }
}

class LocationComputableSpy: LocationComputable {
    
    var mockedLocation: CLLocation?
    func fetchLocation(from postalAddress: CNPostalAddress) async -> CLLocation? {
        mockedLocation
    }
}
