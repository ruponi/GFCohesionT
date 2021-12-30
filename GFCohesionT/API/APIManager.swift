//
//  APIManager.swift
//  GFCohesionT
//
//  Created by Ruslan Ponomarenko on 12/30/21.
//

import Foundation

///API manager for geofencing app
class APIManager {
    private var dataLayer: DataLayerPT
    
    ///init with ANY type of datalayer which based on protocol DataLayerPT
    init ( with dataLayer: DataLayerPT) {
        self.dataLayer = dataLayer
    }
    
    ///submiting user status for office
    public func submitStatus(for userID: String,
                             status: GFuserStatus,
                             regionID: String,
                             result: @escaping (Bool)->() ) {
        
        self.dataLayer.submitStatus(userID: userID, status: status, regionID: regionID){ results  in
             result(results)
             
        }
       
        
    }
    
    public func getUser(result: @escaping (User?)->() ) {
        dataLayer.getUser(with: "1") { user in
            result(user)
        }
    }
    
    public func getOffice(result: @escaping (Office?)->() ) {
        dataLayer.getOffice(with: "1") { office in
            result(office)
        }
    }
}
