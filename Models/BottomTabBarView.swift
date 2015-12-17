//
//  BottomTabBarView.swift
//  Rondogo
//
//  Created by GrepRuby3 on 18/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import CoreLocation

protocol BottomTabBarDelegate{
    func sendTappedButtonTag(sender: AnyObject)
}

class BottomTabBarView: UIView,CLLocationManagerDelegate, UIDocumentInteractionControllerDelegate {
    
    var btnWhatsApp   : UIButton!
    var btnViber : UIButton!
    var btnDropBox : UIButton!
    var btnWaze : UIButton!
    
    var restClient : DBRestClient = DBRestClient(session: DBSession.sharedSession())
    
    var locationManager = CLLocationManager()
    var latitude : Double!
    var longitude : Double!
    
    var bottomBarDelegate : BottomTabBarDelegate! = nil
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.applyDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyDefaults(){
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    
    /* CLLocationManager Delegate Methods */
    
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        locationManager.stopUpdatingLocation()
//        if ((error) != nil) {
//            print(error, terminator: "")
//        }
//    }
  
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
          locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        latitude = coord.latitude
        longitude = coord.longitude
    }
    
    /*  Add Bottom bar Method */
    
    func addBottomViewWithShareOptions(){
        
        var x : CGFloat = 0.0
        let width : CGFloat = self.frame.size.width / 4
        
        self.btnWhatsApp = UIButton(frame: CGRectMake(x, self.frame.size.height - 49 , width , 50))
        self.btnWhatsApp.tag = 0
        let imgWhatsApp = UIImage(named:"icon_whatsApp.png") as UIImage?
        self.btnWhatsApp.setImage(imgWhatsApp, forState: .Normal)
        self.btnWhatsApp.addTarget(self, action: "bottomTabBarButtonTapped:", forControlEvents:.TouchUpInside)
        self.addSubview(btnWhatsApp)
        
        x = x + width
        
        self.btnViber = UIButton(frame: CGRectMake(x, self.frame.size.height - 49 , width , 50))
        self.btnViber.tag = 1
        let imgViber = UIImage(named:"icon_facebook.png") as UIImage?
        self.btnViber.setImage(imgViber, forState: .Normal)
        self.btnViber.addTarget(self, action: "bottomTabBarButtonTapped:", forControlEvents:.TouchUpInside)
        self.addSubview(btnViber)

        x = x + width
        
        self.btnDropBox = UIButton(frame: CGRectMake(x, self.frame.size.height - 49 , width , 50))
        self.btnDropBox.tag = 2
        let imgDropBox = UIImage(named:"icon_dropBox.png") as UIImage?
        self.btnDropBox.setImage(imgDropBox, forState: .Normal)
        self.btnDropBox.addTarget(self, action: "bottomTabBarButtonTapped:", forControlEvents:.TouchUpInside)
        self.addSubview(btnDropBox)
        
        x = x + width
        
        self.btnWaze = UIButton(frame: CGRectMake(x, self.frame.size.height - 49 , width , 50))
        self.btnWaze.tag = 3
        let imgWaze = UIImage(named:"icon_waze.png") as UIImage?
        self.btnWaze.setImage(imgWaze, forState: .Normal)
        self.btnWaze.addTarget(self, action: "bottomTabBarButtonTapped:", forControlEvents:.TouchUpInside)
        self.addSubview(btnWaze)
    }
    
    
    /* What App Button Tapped Method */
    
    func btnWhatsAppTapped(aParams: NSDictionary){
        
        // Reference Url : (https://www.whatsapp.com/faq/iphone/23559013)
        
        let controller = UIDocumentInteractionController()
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)
        let documentDir:NSString! = path[0]
        
        let mediaType : Int = aParams["type"] as! Int

        switch (mediaType){
            
        case 1 :
            
            //let imgPath = documentDir.stringByAppendingPathComponent(aParams["fileName"] as! String)
            let imgPath = documentDir.stringByAppendingString(aParams["fileName"] as! String)
            let imageURL = NSURL.fileURLWithPath(imgPath)
            print("Image path :\(imageURL)")
            
            controller.delegate = self
            controller.UTI = "net.whatsapp.image"
            controller.URL = imageURL
            controller.presentOpenInMenuFromRect(CGRectZero, inView:self, animated: true)

        case 3 :
            
            //let imgPath = documentDir.stringByAppendingPathComponent(aParams["fileName"] as! String)
            let imgPath = documentDir.stringByAppendingString(aParams["fileName"] as! String)
            let imageURL = NSURL.fileURLWithPath(imgPath)
            print("Image path :\(imageURL)")
            
            controller.delegate = self
            controller.UTI = "net.whatsapp.video"
            controller.URL = imageURL
            controller.presentOpenInMenuFromRect(CGRectZero, inView:self, animated: true)

        default:
            print("Other link Button tapped")
            
        }
    }
    
    
    /* Viber App Button Tapped Method */
    
    func btnViberTapped(aParams: NSDictionary){
        
    }
    
    /* Dropbox Button Tapped Method */
    
    func btnDropBoxTapped(aParams: NSDictionary, viewController: UIViewController){
        
        //DBAccountManager.sharedManager().linkFromController(self)
        
        print(aParams)
        
        if !DBSession.sharedSession().isLinked(){
            DBSession.sharedSession().linkFromController(viewController)
            
        } else {
            
            let file : NSString = aParams["fileName"] as! NSString
            
            if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) {
                let dir = dirs[0] //documents directory
                let path = dir.stringByAppendingString(file as String);
                
                let destDir : NSString = "/"
                self.restClient.uploadFile(file as String, toPath: destDir as String, withParentRev:nil ,fromPath: path)
            }
        }
    }
    
    
    /* Waze Button Tapped Method */
    
    func btnWazeTapped(sender: AnyObject){
        
        let urlString = NSString(format:"waze://?ll=%f,%f&navigate=yes", latitude, longitude) as String
        
        if UIApplication.sharedApplication().openURL(NSURL(string: urlString)!) {
            // Waze is installed. Launch Waze and start navigation
        }else {
            // Waze is not installed. Launch AppStore to install Waze app
            UIApplication.sharedApplication().openURL(NSURL(string: "http://itunes.apple.com/us/app/id323229106")!)
        }
    }
    
    
    func bottomTabBarButtonTapped(sender: AnyObject){
        //let btnSender = sender as! UIButton
        bottomBarDelegate.sendTappedButtonTag(sender)
    }
    
    
}