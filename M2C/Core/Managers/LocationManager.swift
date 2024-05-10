//
//  LocationManager.swift
//  ODIE
//
//  Created by Abdul Samad on 03/02/2022.
//

import Foundation
import CoreLocation
import UIKit


enum LMDeviceBatteryState {
    case good
    case enough
    case tolerable
    case critical
}
enum  LMError: Error {
    case authorizationFailed(String)
    case locationUpdationFailed(String)
}
enum LMResponse {
    case success(CLLocation)
    case failure(LMError)
}
enum LMLocationAccuracy {
    case kilometer
    case best
    case nearestTenMeters
    case hundredMeter
    case threeKilometers
    case bestForNavigation
}
class LocationManager: NSObject {
    typealias LMHandler = (LMResponse) -> Void
    typealias LMUntilHandler = (LMResponse) -> Bool
    // MARK: - Variable
    private var oneTimeUse: Bool = true
    private let locationManager = CLLocationManager()
    private var callback: LMHandler?
    private var trackingHandler: LMUntilHandler?
    // MARK: - Device Status
    private var batteryStatus: LMDeviceBatteryState {
        switch UIDevice.current.batteryLevel {
        case 0 ..< 30.0 :
            return LMDeviceBatteryState.critical
        case 30.0 ..< 70.0:
            return LMDeviceBatteryState.tolerable
        case 70.0 ..< 90.0:
            return LMDeviceBatteryState.enough
        case 90.0 ..< 100.0:
            return LMDeviceBatteryState.good
        default:
            return LMDeviceBatteryState.tolerable
        }
    }
    /// MARK: - Initializer
    override init() {
        super.init()
        locationManager.delegate = self
    }
    convenience init(withAccuracy accuracy: LMLocationAccuracy) {
        self.init()
        locationManager.desiredAccuracy = getCLAccuracy(forLMAccurcy: accuracy)
    }
    // MARK: - Helpers
    private func getCLAccuracy(forLMAccurcy lmAccuracy: LMLocationAccuracy) -> CLLocationAccuracy {
        switch  lmAccuracy {
        case .best:
            return kCLLocationAccuracyBest
        case .bestForNavigation:
            return kCLLocationAccuracyBestForNavigation
        case .hundredMeter:
            return kCLLocationAccuracyHundredMeters
        case .kilometer:
            return kCLLocationAccuracyKilometer
        case .nearestTenMeters:
            return kCLLocationAccuracyNearestTenMeters
        case .threeKilometers:
            return kCLLocationAccuracyThreeKilometers
        }
    }
    private func setAccuracyAccordingToBattery () {
        switch self.batteryStatus {
        case .good:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .enough:
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        case .tolerable:
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        case .critical:
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        }
    }

    private func trackingHandle (response: LMResponse) {
        if let callback = self.callback {
            callback(response)
            locationManager.stopUpdatingLocation()
        }
        if let trackingHandler = self.trackingHandler {
            if trackingHandler(response) {
                setAccuracyAccordingToBattery()
                locationManager.startUpdatingLocation()
            } else {
                locationManager.stopUpdatingLocation()
            }
        }
    }
    // MARK: - Public Fuctions
    public func getCurrentLocation(handler: @escaping LMHandler) {
        locationManager.requestWhenInUseAuthorization()
        self.callback = handler
        locationManager.startUpdatingLocation()
    }

    public func startLiveTracking(handler: @escaping LMUntilHandler) {
        oneTimeUse = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        trackingHandler = handler
        locationManager.startUpdatingLocation()
    }

    public func stopUpdatinglocation () {
        locationManager.stopUpdatingLocation()
    }

    public func stopUpdatingLocation(after: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            self.locationManager.stopUpdatingLocation()
        }
    }

}
extension LocationManager: CLLocationManagerDelegate {
    func  locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            let error = LMError.authorizationFailed("Failed to get Authorisation from user.")
            let resposne = LMResponse.failure(error)
            _ = trackingHandler?(resposne)
            callback?(resposne)
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let lmError = LMError.locationUpdationFailed(error.localizedDescription)
        let response = LMResponse.failure(lmError)
        callback?(response)
        _ = trackingHandler?(response)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            print("Location Not fetched")
            return
        }
        let responseSuccess = LMResponse.success(lastLocation)
        trackingHandle(response: responseSuccess)
    }
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
}




//protocol LocationUpdateProtocol {
//    func locationDidUpdateToLocation(location : CLLocation)
//}
//
///// Notification on update of location. UserInfo contains CLLocation for key "location"
//let kLocationDidChangeNotification = "LocationDidChangeNotification"

//class LocationManager: NSObject, CLLocationManagerDelegate {
//
//    static let shared = LocationManager()
//
//    private var locationManager = CLLocationManager()
//    let locationManager = LocationManager(withAccuracy: LMLocationAccuracy.bestForNavigation)
//    var currentLocation : CLLocation?
//
//    var delegate : LocationUpdateProtocol!
//
//    private override init () {
//        super.init()
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
//        locationManager.requestAlwaysAuthorization()
//        self.locationManager.startUpdatingLocation()
//    }
//
//    // MARK: - CLLocationManagerDelegate
//    let locationManager = LocationManager(withAccuracy: LMLocationAccuracy.bestForNavigation)
//            locationManager.getCurrentLocation { (response) in
//                switch response {
//                case .failure(let locationError):
//                    switch locationError {
//                    case .authorizationFailed(let description):
//                        print(description)
//                    case .locationUpdationFailed(let description):
//                        print(description)
//                    }
//                case .success(let location):
//                    print("location is :", location)
//                    self.lbllat.text = "\(location.coordinate.latitude)"
//                    self.lblLong.text = "\(location.coordinate.longitude)"
//                }
//            }
//    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
//        currentLocation = newLocation
//        let userInfo : NSDictionary = ["location" : currentLocation!]
//
//        DispatchQueue.global(qos: .background).async {
//
//            // Background Thread
//            self.delegate.locationDidUpdateToLocation(location: self.currentLocation!)
//            NotificationCenter.default.post(name: NSNotification.Name.DidUpdateLocation, object: self, userInfo: userInfo as [NSObject : AnyObject])
//
//            DispatchQueue.main.async {
//                // Run UI Updates
//            }
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation :CLLocation = locations[0] as CLLocation
//
//        print("user latitude = \(userLocation.coordinate.latitude)")
//        print("user longitude = \(userLocation.coordinate.longitude)")
//
//        print("\(userLocation.coordinate.latitude)")
//        print("\(userLocation.coordinate.longitude)")
//
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
//            if (error != nil){
//                print("error in reverseGeocode")
//            }
//            let placemark = placemarks! as [CLPlacemark]
//            if placemark.count>0{
//                let placemark = placemarks![0]
//                print(placemark.locality!)
//                print(placemark.administrativeArea!)
//                print(placemark.country!)
//
//                print("\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)")
//            }
//        }
//
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Error \(error)")
//    }
//
//}


