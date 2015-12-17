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
    let isiPadAir2 = UIScreen.mainScreen().bounds.size.width == 768.0
  
    let hebrew : String     =   "he"
    let selectedLanguage : NSString = NSLocale.preferredLanguages()[0] as NSString
    
    let api : AppApi = AppApi()
    var activityIndicator : ActivityIndicatorView!
    
    
    let arrEnTreasureHunt : NSArray = [ "En_TreasureHunt.png","En_TreasureBtn1.png","En_TreasureBtn2.png","En_TreasureBtn3.png",
        "En_TreasureBtn4.png","En_TreasureBtn5.png","En_TreasureBtn6.png","En_TreasureBtn7.png","En_TreasureBtn8.png","En_TreasureBtn9.png"]
    let arrHeTreasureHunt : NSArray = [ "He_TreasureHunt.png","He_TreasureBtn1.png","He_TreasureBtn2.png","He_TreasureBtn3.png",
        "He_TreasureBtn4.png","He_TreasureBtn5.png","He_TreasureBtn6.png","He_TreasureBtn7.png","He_TreasureBtn8.png","He_TreasureBtn9.png"]
    
    let arrEnNightStar : NSArray =    [ "En_NightStar.png","En_NightStarBtn1.png","En_NightStarBtn2.png","En_NightStarBtn3.png",
                                        "En_NightStarBtn4.png","En_NightStarBtn5.png","En_NightStarBtn6.png","En_NightStarBtn7.png",
                                        "En_NightStarBtn8.png","En_NightStarBtn9.png"]
    let arrHeNightStar : NSArray = [ "He_NightStar.png","He_NightStarBtn1.png","He_NightStarBtn2.png","He_NightStarBtn3.png",
                                    "He_NightStarBtn4.png","He_NightStarBtn5.png","He_NightStarBtn6.png","He_NightStarBtn7.png",
                                    "He_NightStarBtn8.png","He_NightStarBtn9.png"]

    
    let arrEnMissionPossible : NSArray = [ "En_MissionnPossible.png","En_MissionnPossibleBtn1.png","En_MissionnPossibleBtn2.png",
                        "En_MissionnPossibleBtn3.png","En_MissionnPossibleBtn4.png","En_MissionnPossibleBtn5.png","En_MissionnPossibleBtn6.png",
                        "En_MissionnPossibleBtn7.png","En_MissionnPossibleBtn8.png","En_MissionnPossibleBtn9.png"]
    let arrHeMissionPossible : NSArray = [ "He_MissionnPossible.png","He_MissionnPossibleBtn1.png","He_MissionnPossibleBtn2.png",
                        "He_MissionnPossibleBtn3.png","He_MissionnPossibleBtn4.png","He_MissionnPossibleBtn5.png","He_MissionnPossibleBtn6.png",
                        "He_MissionnPossibleBtn7.png","He_MissionnPossibleBtn8.png","He_MissionnPossibleBtn9.png"]
    
    let arrEnCopsAndRobbers : NSArray = [ "En_Cops&Robbers.png"]
    let arrHeCopsAndRobbers : NSArray = [ "He_Cops&Robbers.png"]
    
    let arrEnYourRace : NSArray = [ "En_YourRace.png","En_YourRaceBtn1.png","En_YourRaceBtn2.png","En_YourRaceBtn3.png","En_YourRaceBtn4.png",
                                    "En_YourRaceBtn5.png","En_YourRaceBtn6.png","En_YourRaceBtn7.png","En_YourRaceBtn8.png","En_YourRaceBtn9.png"]
    let arrHeYourRace : NSArray = [ "He_YourRace.png","He_YourRaceBtn1.png","He_YourRaceBtn2.png","He_YourRaceBtn3.png","He_YourRaceBtn4.png",
        "He_YourRaceBtn5.png","He_YourRaceBtn6.png","He_YourRaceBtn7.png","He_YourRaceBtn8.png","He_YourRaceBtn9.png"]
    
    let arrEnTimeLessRopes : NSArray = [ "En_TimeLessRopes.png"]
    let arrHeTimeLessRopes : NSArray = [ "He_TimeLessRopes.png"]
    
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInitialization()
    }
    
    func commonInitialization(){
        AppApi.sharedClient()
    }
    
    func showAlertMsg(title:String!,message:String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Share media on Facebook

    func shareMediaOnFacebook(aParams: NSDictionary) {
        
        let mediaType : Int = aParams["type"] as! Int
        
        switch (mediaType){
            
        case 1 :
            let shareImage : UIImage = self.api.getImageFromDocumentDirectoryFileURL(aParams as [NSObject : AnyObject])
            let objectsToShare : NSArray = [shareImage]
            let activityVC = UIActivityViewController(activityItems: objectsToShare as [AnyObject], applicationActivities: nil)
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
                UIActivityTypePostToTencentWeibo
            ]
            self.presentViewController(activityVC, animated: true, completion: nil)
         
         case 3 :
            
            let objectsToShare : NSArray = [aParams["url"] as! String]
            let activityVC = UIActivityViewController(activityItems: objectsToShare as [AnyObject], applicationActivities: nil)
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
                UIActivityTypePostToTencentWeibo
            ]
            self.presentViewController(activityVC, animated: true, completion: nil)
            
        default:
            print("Other link Button tapped")
        }
        
    }
    
}