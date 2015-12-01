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
    var activityIndicator : ActivityIndicatorView!
    var alertController: UIAlertController!
    
    func startSyncMethodCall(viewController:UIViewController, success:((responseObject: AnyObject? ) -> Void)?, failure:((error: NSError? ) -> Void)? ){
        
        /* Fetch last Synced date from Time Stamp Table */
        let parameters : NSMutableDictionary = NSMutableDictionary()
        let arrFetchedData : NSArray = TimeStamp.MR_findAll()
        
        if arrFetchedData.count != 0 {
            let timeStampObject : TimeStamp = arrFetchedData.objectAtIndex(0) as! TimeStamp
            parameters["object_info[time]"] = timeStampObject.last_sync_date
        }else{
            parameters["object_info[time]"] = ""
        }
        
        // To show Activity Indicator on view
        showActivityIndicatory(viewController)
        
        // To get All object of Object Table during sync Sync
        api.getAllObjects( parameters as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject?) in
            if let success = success {
                print(responseObject)
                success(responseObject: responseObject)
                self.stopActivityIndicator(viewController)
            }
            },
            failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
                if let failure = failure {
                    print(error)
                    failure(error: error)
                    self.stopActivityIndicator(viewController)
                }
        })
    }
    
    
    /* Methods to add UIActivityIndicator */
    
    func showActivityIndicatory(viewController : UIViewController) {
        
        /* Method to Add Custom UIActivityIndicatorView in current screen */
        activityIndicator = ActivityIndicatorView(frame: viewController.view.frame)
        activityIndicator.startActivityIndicator(viewController)

        /*
        alertController = UIAlertController(title: "App Synchronizing", message:
            "Please wait...", preferredStyle: UIAlertControllerStyle.Alert)
        
        viewController.presentViewController(alertController, animated: true, completion: {
            
            var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.alertController.dismissViewControllerAnimated(true, completion: nil)
            })
        })
        */
    }
    
    func stopActivityIndicator(viewController : UIViewController){
        self.activityIndicator.stopActivityIndicator(viewController)
        //alertController.dismissViewControllerAnimated(true, completion: nil)
    }
}