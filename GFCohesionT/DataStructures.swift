//
//  DataStructures.swift
//  GFCohesionT
//
//  Created by Ruslan Ponomarenko on 12/30/21.
//

import Foundation

public struct User {
    var userID: String
    var userName: String
}

public struct Office {
    var officeID: String
    var officeLatitude: Double
    var officeLongitude: Double
    var officeName: String
}

enum GFuserStatus: Int {
    case enter, exit
}
