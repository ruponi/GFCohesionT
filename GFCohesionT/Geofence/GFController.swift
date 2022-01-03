//
//  GFController.swift
//  GFCohesionT
//
//  Created by Ruslan Ponomarenko on 12/29/21.
//

import Foundation
import CoreLocation
import FirebaseAnalytics

//GFController Delegate protocol
protocol GFControllerDelegate {
    func didEnterRegion(_ regionID: String)
    func didExitRegion(_ regionID: String)
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
    public func registerGFRegion(region: CLCircularRegion) {
        
        // old regions with same regionID will be automathicaly updated
        locationManager.startMonitoring(for: region)
       // locationManager.requestState(for: region)
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
    
    ///clear all regions
    public func stopAllregions(){
        for region in locationManager.monitoredRegions {
        locationManager.stopMonitoring(for: region)
        }
    }
    
    //it should work without core location in parent classes
    ///New geofencing region registration
    @discardableResult public func registerNewRegion(latitude: Double,
                                  longitude: Double,
                                  radius: Double,
                                  regionID: String) -> CLCircularRegion {
        let centerCoordinate = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        let region = CLCircularRegion.init(center: centerCoordinate, radius: CLLocationDistance(radius), identifier: regionID)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        registerGFRegion(region: region)
        return region
    }
}


//MARK: - CLLocationManagerDelegate Implemetation
extension GFController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let regionID = region.identifier
        delegate?.didEnterRegion(regionID)
        
        //For Analytics we need to create custom class and implement all needed stuff inside of this class
        Analytics.logEvent(LOGEvents.enterRegion.rawValue , parameters: [
            "regionID": region.identifier as NSObject
        ])
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let regionID = region.identifier
        delegate?.didExitRegion(regionID)
        Analytics.logEvent(LOGEvents.exitRegion.rawValue , parameters: [
            "regionID": region.identifier as NSObject
        ])
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        let regionID = region.identifier
        if state == .inside {
            print("inside")
            Analytics.logEvent(LOGEvents.enterRegion.rawValue , parameters: [
                "regionID": region.identifier as NSObject
            ])
            delegate?.didEnterRegion(regionID)
        } else  if state == .outside {
            print("outside")
            Analytics.logEvent(LOGEvents.exitRegion.rawValue , parameters: [
                "regionID": region.identifier as NSObject
            ])
            delegate?.didExitRegion(regionID)
        }
     
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("START")
        
        Analytics.logEvent(LOGEvents.startMonitoring.rawValue , parameters: [
            "regionID": region.identifier as NSObject
        ])
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
