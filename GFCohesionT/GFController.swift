//
//  GFController.swift
//  GFCohesionT
//
//  Created by Ruslan Ponomarenko on 12/29/21.
//

import Foundation
import CoreLocation

///GFController Delegate protocol
protocol GFControllerDelegate {
    func didEnterRegion(_ region: CLRegion)
    func didExitRegion(_ region: CLRegion)
}

/// GFController Handle geaofence feature.
///
class GFController: NSObject {
    
    private var locationManager: CLLocationManager?
    
    public var delegate: GFControllerDelegate?

    ///Enable location service  for geofensing. Request Permission
    public func enableLocationServices()
    {
        guard let locationManager = self.locationManager else {
            return
        }
        
        let authorizationStatus: CLAuthorizationStatus
        
        locationManager.delegate = self
        
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        switch authorizationStatus {
        case .notDetermined:
        
            locationManager.requestAlwaysAuthorization()
            break
            
        case .restricted, .denied:
            print("status restricted, .denied \(authorizationStatus)")
            break
            
        case .authorizedWhenInUse:
          
            print("status authorizedWhenInUse \(authorizationStatus)")
            break
            
        case .authorizedAlways:
            print("status authorizedAlways \(authorizationStatus)")
           
            break
        @unknown default:break;
        }
        
    }
}

//MARK: - CLLocationManagerDelegate -
extension GFController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        delegate?.didEnterRegion(region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        delegate?.didExitRegion(region)
    }
}
