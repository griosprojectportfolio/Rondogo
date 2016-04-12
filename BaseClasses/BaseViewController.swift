//
//  BaseViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 13/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    let isiPhone4s          =   UIScreen.mainScreen().bounds.size.height == 480
    let isiPhone5orLower    =   UIScreen.mainScreen().bounds.size.width == 320
    let isiPhone6           =   UIScreen.mainScreen().bounds.size.width == 375
    let isiPhone6plus       =   UIScreen.mainScreen().bounds.size.width == 414
    let isiPadAir2          =   UIScreen.mainScreen().bounds.size.width == 768.0
  
    let hebrew : String     =   "he"
    let selectedLanguage : NSString = NSLocale.preferredLanguages()[0] as NSString
    
    let social : RondogoSocials = RondogoSocials()
    let api : AppApi = AppApi()
    
    
    // MARK: - Access Token and Admin object
    
    var auth_token : [NSString] {
        get {
            var returnValue: [NSString]? = NSUserDefaults.standardUserDefaults().objectForKey("auth_token") as? [NSString]
            if returnValue == nil //Check for first run of app
            {
                returnValue = [""] //Default value
            }
            return returnValue!
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "auth_token")
            //NSUserDefaults.standardUserDefaults().setObject(newValue as [NSString], forKey: "auth_token")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var is_Admin : [Bool] {
        get {
            var returnValue: [Bool]? = NSUserDefaults.standardUserDefaults().objectForKey("is_Admin") as? [Bool]
            if returnValue == nil //Check for first run of app
            {
                returnValue = [false] //Default value
            }
            return returnValue!
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "is_Admin")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    // MARK: - View related methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInitialization()
    }
    
    // MARK: - Common methods
    
    func commonInitialization(){
        AppApi.sharedClient()
    }
    
    func animateCurrentViewUpAndDownSide(up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }

    
    // MARK: - Navigation bar and their action methods
    
    func addLeftNavigationBarButtonItemOnView() {
        let buttonBack: UIButton = UIButton(type: UIButtonType.Custom)
        buttonBack.frame = CGRectMake(0, 0, 40, 40)
        buttonBack.setImage(UIImage(named:"icon_back.png"), forState: UIControlState.Normal)
        buttonBack.addTarget(self, action: "leftNavBackBtnTapped", forControlEvents: UIControlEvents.TouchUpInside)
        let leftBarButtonItemback: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItemback, animated: false)
    }
    
    func leftNavBackBtnTapped(){
        self.navigationController?.popViewControllerAnimated(true)
    }

    func rightNavCameraButtonTapped(){
        
    }

    
    // MARK: - Show common alert method
    
    func showAlertMsg(title:String!,message:String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK",comment:"Ok"), style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Loading View Add/Remove method
    
    func startLoadingIndicatorView(loadMsg: String){
        dispatch_async(dispatch_get_main_queue(),{
            QistLoadingOverlay.shared.showOverlay(self.view, lblText: loadMsg)
        })
    }
    
    func stopLoadingIndicatorView(){
        dispatch_async(dispatch_get_main_queue(),{
            QistLoadingOverlay.shared.hideOverlayView()
        })
    }
    
    
    // MARK: - Share media on Facebook

    func shareMediaOnFacebook(objMedia: MediaObject) {
        
        var activityVC : UIActivityViewController!
        let mediaType : Int = objMedia.object_type as Int
        
        if mediaType == 1 {
            let shareImage : UIImage = self.api.getImageFromDocumentDirectoryFileURL(objMedia)
            let objectsToShare : NSArray = [shareImage]
            activityVC = UIActivityViewController(activityItems: objectsToShare as [AnyObject], applicationActivities: nil)
        }else {
            let videoURL = self.api.getDocumentDirectoryFileURL(objMedia)
            let objectsToShare : NSArray = [videoURL]
            activityVC = UIActivityViewController(activityItems: objectsToShare as [AnyObject], applicationActivities: nil)
        }
        
        activityVC.excludedActivityTypes =  [
            UIActivityTypePostToTwitter,
            UIActivityTypePostToWeibo,
            UIActivityTypeMessage,
            UIActivityTypeMail,
            UIActivityTypePrint,
            UIActivityTypeCopyToPasteboard,
            UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo,
            UIActivityTypeAirDrop
        ]
        self.presentViewController(activityVC, animated: true, completion: nil)
        
    }
    
    func openDefaultFacebookPage() {
        if let url : NSURL = NSURL(string: "https://www.facebook.com/groups/mysterious.figure/")! {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
}