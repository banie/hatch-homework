//
//  LocationManager.swift
//  HatchHomework
//
//  Created by hatch.co
//

import CoreLocation

@Observable
public class LocationManager: NSObject {
    // MARK: Static vars

    public static let shared = LocationManager()
    
    // MARK: Public vars
    public var currentLocation: CLLocation?
    public var locationUpdated: Bool = false
    
    // MARK: Private vars
    
    private let locationManager = CLLocationManager()
    private var authorizationChanged: ((AuthorizationStatus) -> Void)?
    
    // MARK: Inits
    
    override init() {
        super.init()
        locationManager.delegate = self
        self.authorizationStatus = mappedAauthorizationStatus
    }
    
    // MARK: Public functions
    
    public var mappedAauthorizationStatus: AuthorizationStatus {
        switch locationManager.authorizationStatus {
        case .notDetermined: .notDetermined
        case .authorizedWhenInUse,
             .authorizedAlways: .authorized
        default: .unauthorized
        }
    }
    
    public var authorizationStatus: AuthorizationStatus = .notDetermined
    
    public func requestAuthorization(
        authorizationChanged: ((AuthorizationStatus) -> Void)?
    ) {
        self.authorizationChanged = authorizationChanged
        authorizationStatus = mappedAauthorizationStatus
        authorizationChanged?(authorizationStatus)
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        authorizationStatus = mappedAauthorizationStatus
        authorizationChanged?(authorizationStatus)
        authorizationChanged = nil
        
        guard locationManager.authorizationStatus == .authorizedWhenInUse ||
            locationManager.authorizationStatus == .authorizedAlways else {
            return
        }
        
        locationManager.startUpdatingLocation()
    }

    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        currentLocation = locations.last
        locationUpdated.toggle()
        guard let location = locations.first else { return }
        logger.debug("User location: \(location)")
    }
}
