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
    
    /// Location manager
    private var locationManager: CLLocationManager
    /// Delegate of the GFController
    public var delegate: GFControllerDelegate?
     
    override init() {
        self.locationManager = CLLocationManager.init()
        super.init()
        self.enableLocationServices()
    }
    
    ///Enable location service  for geofensing. Request Permission
    private func enableLocationServices()
    {
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
    
    // TODO: As Apple allow to monitor just 20 different regions then we create feature for dinamicaly uploaded neareds regions with significant location
    ///Register New Region for Monitoring.
    public func registerGFRegion(with regionID: String,
                                 region: CLCircularRegion) {
        // old regions with same regionID will be automathicaly updated
        locationManager.startMonitoring(for: region)
        locationManager.requestState(for: region)
    }
    
    ///Remove region with ID
    public func removeGFRegion(with regionID: String) {
        guard let region  = (locationManager.monitoredRegions.first(where: { region in
            return region.identifier == regionID
        })) else {
            return
        }
        locationManager.stopMonitoring(for: region)
    }
    
}


//MARK: - CLLocationManagerDelegate Implemetation
extension GFController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        delegate?.didEnterRegion(region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        delegate?.didExitRegion(region)
    }
}
//MARK: -

extension CLLocationManager {
    func containsGFRegion(with regionID: String) -> Bool {
      return self.monitoredRegions.contains { region in
          return  region.identifier == regionID
        }
    }
}
