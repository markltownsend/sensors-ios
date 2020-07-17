//
//  LocationManager.swift
//  Sensors
//
//  Created by Mark Townsend on 6/16/20.
//  Copyright © 2020 Mark Townsend. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    private let secondsInHour: Double = 3600
    private let metersPerMile: Double = 1609.344

    var speed: Int = 0
    var latLong: (Double, Double) = (0, 0)
    var isLocationAuthorized: Bool = false
    var course: Double = 0
    var heading: Double = 0
    var error: Error?
    var cityState: String = ""

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func start() {
        if !isLocationAuthorized {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }

    func stop() {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }

    private func convertToMPH(_ speed: Double) -> Int {
        // Speed is in meters/second
        let speedMPH = Int(speed * (secondsInHour / metersPerMile))
        return speedMPH
    }

    private func getCityState(with location: CLLocation) {
        geoCoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            guard error == nil else {
                print("Error getting reverse geoLocation: \(error!)")
                return
            }
            guard let placemarks = placemarks, let placemark = placemarks.first else { return }
            if let city = placemark.locality, let state = placemark.administrativeArea {
                let neighborhood = placemark.subLocality ?? ""
                let street = placemark.thoroughfare ?? ""
                self.cityState = "\(neighborhood)\n\(street)\n\(city), \(state)"
                self.objectWillChange.send()
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Failed with : \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            isLocationAuthorized = true
        case .denied, .notDetermined, .restricted:
            isLocationAuthorized = false
        @unknown default:
            fatalError()
        }
        objectWillChange.send()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }
        let convertedSpeed = convertToMPH(latest.speed)
        speed = convertedSpeed > 0 ? convertedSpeed : 0
        latLong = (latest.coordinate.latitude, latest.coordinate.longitude)
        course = latest.course
        getCityState(with: latest)
        objectWillChange.send()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.magneticHeading
        objectWillChange.send()
    }
}
