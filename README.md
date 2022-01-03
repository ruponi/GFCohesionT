# GFCohesionT
Test From Cohesion

## The Task:
Create application with Geofence features. 

The file "iOS-code challange_.pdf" contains Full Requirements.

## Solution:

The application "GFCohesionT" was created. 

###The Main Parts:

 - GFController : Controller which handles the Geofence feature 
      The "delegate" methods handle "ExitRegion" and "EnterRegion":
      func didEnterRegion(_ regionID: String)
      func didExitRegion(_ regionID: String) 
 - APIManager : External Common Layer for API
 - DataLayerCD : Internal Layer of the API is connected to the Core Data
 - DataStructures : Contains stuctures for Internal app Entities
 
 ### Testing:
 For test purposes the GPX file "Locations" which contains two points "Office" and "Out of Office" was added. During testing we can simulate location with this waypoints and check logs.
 
 - Additionaly the "Firebase/Crashlytics" SDK was implemented via Package Dependencies.
     Custom Logs:
    -- userID
    -- start Monitoring
    -- exit from region
    -- enter to the region
