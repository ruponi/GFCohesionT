//
//  GFCohesionTTests.swift
//  GFCohesionTTests
//
//  Created by Ruslan Ponomarenko on 12/29/21.
//

import XCTest
import CoreData
@testable import GFCohesionT

class GFCohesionTTests: XCTestCase {
    private var context: NSManagedObjectContext?

       override func setUp() {
           self.context = NSManagedObjectContext.contextForTests()!
       }
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGFControllerInit() throws {
        let controller = GFController.init()
        XCTAssertNotNil(controller)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAPIManager() throws {
        guard let context = context else {
            return
        }
        let expectation = expectation(description: "APIManager does stuff and runs the callback closure")

        let dataLayer = DataLayerCD(context: context)
        let api = APIManager.init(with: dataLayer)
        let userID = "AAA"
        let officeID = "BBB"
        api.submitStatus(for: userID, status: .exit, regionID: officeID) { status in
            XCTAssertTrue(status)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
              XCTFail("wait timeout error: \(error)")
            }
          }
        
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
extension NSManagedObjectContext {
    
    class func contextForTests() -> NSManagedObjectContext? {
        // Get the model
       // let model = NSManagedObjectModel.mergedModel(from: Bundle.allBundles)!
     guard  let url = Bundle.main.url(forResource: "GFCohesionT", withExtension: "momd") ,
            let model = NSManagedObjectModel.init(contentsOf: url) else {
                return nil
            }
        // Create and configure the coordinator
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        // Setup the context
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }
    
}
