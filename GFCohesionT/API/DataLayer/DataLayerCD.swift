//
//  DataLayerCD.swift
//  GFCohesionT
//
//  Created by Ruslan Ponomarenko on 12/30/21.
//

import Foundation
import CoreData
import UIKit


/// Create the DataLayer for our CoreData based on the DataLayerPT
class DataLayerCD: DataLayerPT {
    
    private var context: NSManagedObjectContext

    init (context: NSManagedObjectContext) {
        self.context = context
    }
    
    ///submiting user status for office
    func submitStatus(userID: String,
                      status: GFuserStatus,
                      regionID: String,
                      completion: @escaping (Result<Bool,Error>) -> ()) {
        var officeVolume: OfficeVolumeDT!
        DispatchQueue.global().async {
        let fetchOffice: NSFetchRequest<OfficeVolumeDT> = OfficeVolumeDT.fetchRequest()
        fetchOffice.predicate = NSPredicate(format: "officeID = %@ && userID = %@", regionID as String, userID as String)

        let results = try? self.context.fetch(fetchOffice)

        if results?.count == 0 {
           //inserting
            officeVolume = OfficeVolumeDT(context: self.context)
            officeVolume.userID = userID
            officeVolume.officeID = regionID
            officeVolume.status = Int16(status.rawValue)
            officeVolume.statusChanged = Date()
        } else {
           //updating
            officeVolume = results?.first
            officeVolume.status = Int16(status.rawValue)
            officeVolume.statusChanged = Date()
        }

            do {
             try self.context.save()
            DispatchQueue.main.async {
                completion(Result.success(true))
                print ("status submited to DB")
            }
            }
            catch {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                    print ("status submited to DB")
                }
            }
        }
    }
    
    // This is the fake functions which is not required for this test task
    // but just demonstrate what we need to handle
    func getUser(with userID: String,
                 result: @escaping (User?) -> ()) {
        let user = User.init(userID: "ASD-DDD",
                             userName: "TestUser")
        result(user)
    }
    
    func getOffice(with officeID: String,
                   result: @escaping (Office?) -> ()) {
        let office = Office.init(officeID: "ASD-AAA", officeLatitude: 48.464263916015625, officeLongitude: 34.984382638655745, officeName: "Office 1")
        result(office)
        
    }
    
    
    
    
}
