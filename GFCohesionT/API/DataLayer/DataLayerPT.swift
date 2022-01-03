//
//  DataLayerPT.swift
//  GFCohesionT
//
//  Created by Ruslan Ponomarenko on 12/31/21.
//

import Foundation

/// Common protocol for all types of the datalayers
protocol DataLayerPT{
    func submitStatus(userID: String, status: GFuserStatus, regionID: String, completion: @escaping (Result<Bool,Error>) -> ())
    //mockup  functions
    func getUser(with userID: String, result: @escaping (User?)->() )
    func getOffice(with officeID: String,result: @escaping (Office?)->() )
    
}
