//
//  AppDelegate.swift
//  GFCohesionT
//
//  Created by Ruslan Ponomarenko on 12/29/21.
//

import UIKit
import CoreData
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var gfController: GFController?
    var apiManager: APIManager?
    
    var currentUser: User?
    var ourOffice: Office?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initialization()
        // Override point for customization after application launch.
        return true
    }

    private func initialization(){
        FirebaseApp.configure()
        gfController = GFController()
        gfController?.delegate = self
        gfController?.stopAllregions()
        apiManager = APIManager.init(with: DataLayerCD(context: self.persistentContainer.viewContext))
        
        //getting data from our API for user and Office location
        let queue = DispatchQueue(label: "com.co.queue", attributes: .concurrent)
        let group = DispatchGroup()
        
        queue.async(group: group) {
            self.apiManager?.getUser(result: { user in
                self.currentUser = user
             
            })
        }
        
        queue.async(group: group) {
            self.apiManager?.getOffice(result: { office in
                self.ourOffice = office
            })
        }
        
        // if all data here then  start monitoring
        group.notify(queue: queue){
            guard let office = self.ourOffice, let user = self.currentUser else {
                return
            }
            print("all data here")
            Crashlytics.crashlytics().setUserID(user.userID)
            self.gfController?.registerNewRegion(latitude: office.officeLatitude, longitude: office.officeLongitude, radius: 200, regionID: office.officeID)
        }
     //   let numbers = [0]
     //   let _ = numbers[1]
        
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "GFCohesionT")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

//MARK: GFControllerDelegate
extension AppDelegate: GFControllerDelegate {
    func didEnterRegion(_ regionID: String) {
        guard let user = self.currentUser else {
            return
        }
        apiManager?.submitStatus(for: user.userID, status: .enter, regionID: regionID) { result in
            print("user entered to region")
        }
        
    }
    
    func didExitRegion(_ regionID: String) {
        guard let user = self.currentUser else {
            return
        }
        
        apiManager?.submitStatus(for: user.userID, status: .exit, regionID: regionID) { result in
            print("user exit from region" )
        }
       
    }
    
    
}
