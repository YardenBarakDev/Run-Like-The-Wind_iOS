
import Foundation
import UIKit
import GoogleMaps

class LocationPermissionHelper{
    
    let locationManager : CLLocationManager
    
    init(locationManager : CLLocationManager) {
        self.locationManager = locationManager
    }
    
    func askLocationPermission(){
        print("ask location")
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestLocation()
        }
        else{
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func isLoctionPermissionEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                    return false
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    return true
                @unknown default:
                break
                    
            }
        }
        return false
    }
}
