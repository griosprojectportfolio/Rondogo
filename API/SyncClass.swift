//
//  SyncClass.swift
//  Rondogo
//
//  Created by GrepRuby3 on 19/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit
import Foundation

let kAppAPIBaseURLString : NSString = "http://echo.jsontest.com/title/ipsum/content/blah"

class SyncClass: AFHTTPRequestOperationManager{
    
    let parameters = NSDictionary(object: "Hello",forKey: "Hello")
    
    func sharedClient() -> SyncClass {
        return self
    }
    
    func sharedAuthorizedClient() -> SyncClass {
        return self
    }

    func initWithBaseUrl( url : NSURL) ->AnyObject{
     return self
    }
    
    func loginUser(parameters: AnyObject?,
        success: ((responseObject: AnyObject? ) -> Void)?,
        failure: ((error: NSError? ) -> Void)?) -> AFHTTPRequestOperation?
    {
        return self.GET(kAppAPIBaseURLString as String, parameters: parameters,
            success: { ( operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
                if let success = success {
                    success(responseObject: responseObject)
                }
            },
            failure: { ( operation: AFHTTPRequestOperation?, error: NSError? ) in
                if let failure = failure {
                    failure(error: error )
                }
        })
    }
}
