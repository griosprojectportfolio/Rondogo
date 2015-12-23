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
    
    let objWindow:UIWindow = UIApplication.sharedApplication().delegate!.window!!
    let overlayView = UIView()
    let grayBackgroundView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    let lblLoading = UILabel()
    
    // MARK: - Start sync method call
    
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
    
    
    // MARK: - Methods to add and remove UIActivityIndicator
    func showActivityIndicatory(viewController : UIViewController) {
        
        grayBackgroundView.frame = viewController.view.bounds
        grayBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        overlayView.frame = CGRectMake(0, 0, 100, 100)
        overlayView.center = viewController.view.center
        overlayView.backgroundColor = UIColor.whiteColor()
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 12
        
        activityIndicator.frame = CGRectMake(0, 0, 50, 50)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.color = UIColor.blackColor()
        activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, (overlayView.bounds.height - 20) / 2)
        
        lblLoading.frame = CGRectMake(0, 60, 100, 20)
        lblLoading.text = "Syncing.."
        lblLoading.font = UIFont.systemFontOfSize(15.0)
        lblLoading.textColor = UIColor.darkGrayColor()
        lblLoading.textAlignment = .Center
        overlayView.addSubview(lblLoading)
        
        overlayView.addSubview(activityIndicator)
        
        objWindow.addSubview(grayBackgroundView)
        objWindow.addSubview(overlayView)
        
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator(viewController : UIViewController){
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
        grayBackgroundView.removeFromSuperview()
    }
}