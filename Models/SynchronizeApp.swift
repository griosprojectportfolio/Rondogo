//
//  SynchronizeApp.swift
//  Rondogo
//
//  Created by GrepRuby3 on 19/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

class SynchronizeApp: NSObject {
    
    var api : AppApi = AppApi.sharedClient()
    
    // MARK: - Start sync method call
    
    func startSyncMethodCall(viewController:UIViewController, success:((responseObject: AnyObject? ) -> Void)?, failure:((error: NSError? ) -> Void)? ){
        
        /* Fetch last Synced date from Time Stamp Table */
        let parameters : NSMutableDictionary = NSMutableDictionary()
        let arrFetchedData : NSArray = TimeStamp.MR_findAll()
        
        if arrFetchedData.count != 0 {
            let timeStampObject : TimeStamp = arrFetchedData.objectAtIndex(0) as! TimeStamp
            parameters["time"] = timeStampObject.last_sync_date
        }else{
            parameters["time"] = ""
        }
        
        // To get All object of Object Table during sync Sync
        api.getAllObjects( parameters as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject?) in
            if let success = success {
                print(responseObject)
                success(responseObject: responseObject)
            }
            },
            failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
                if let failure = failure {
                    print(error)
                    failure(error: error)
                }
        })
        
        self.syncAllCategoriesFromServer()
        self.syncAllSubCategoriesFromServer()
    }
    
    // MARK: - Start sync of all categories
    func syncAllCategoriesFromServer() {
        let parameters : NSMutableDictionary = NSMutableDictionary()
        self.api.getAllCategories( parameters as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject?) in
                print(responseObject)
            },
            failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
                print(error)
        })
    }
    
    // MARK: - Start sync of all sub_categories
    func syncAllSubCategoriesFromServer() {
        let parameters : NSMutableDictionary = NSMutableDictionary()
        self.api.getAllSubCategories( parameters as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject?) in
                print(responseObject)
            },
            failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
                print(error)
        })
    }
    
}