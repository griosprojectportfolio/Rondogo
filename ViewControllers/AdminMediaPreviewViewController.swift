//
//  AdminMediaPreviewViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 27/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer

class AdminMediaPreviewViewController: BaseViewController, UITextFieldDelegate {
    
    var mediaNameTxt         : TextField!
    var imagePreview         : UIImageView!
    var isMediaType          : Int!
    var selectedImage        : UIImage!
    var selectedVideoUrl     : NSURL!
    
    var moviePlayer          : MPMoviePlayerController!
    var tempWebView          : UIWebView!
    
    var categoryId : NSInteger!
    var subCategoryId : NSInteger!
    
    let buttonBack: UIButton = UIButton(type: UIButtonType.Custom)
    let buttonShare: UIButton = UIButton(type: UIButtonType.Custom)
    
    
    // MARK: - View related methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor().appBackgroundColor()
        self.title =  NSLocalizedString("PREVIEW",comment:"Preview")
        self.addRightAndLeftNavItemOnView()
        self.applyDefaults()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Navigation bar and their action methods
    
    func addRightAndLeftNavItemOnView()
    {
        buttonBack.frame = CGRectMake(0, 0, 40, 40)
        buttonBack.setImage(UIImage(named:"icon_back.png"), forState: UIControlState.Normal)
        buttonBack.addTarget(self, action: "leftNavBackButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        let leftBarButtonItemback: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItemback, animated: false)
        
        buttonShare.frame = CGRectMake(0, 0, 40, 40)
        buttonShare.setImage(UIImage(named:"icon_share.png"), forState: UIControlState.Normal)
        buttonShare.addTarget(self, action: "rightNavShareButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarButtonItemShare: UIBarButtonItem = UIBarButtonItem(customView: buttonShare)
        self.navigationItem.setRightBarButtonItem(rightBarButtonItemShare, animated: false)
    }
    
    func leftNavBackButtonTapped(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func rightNavShareButtonTapped(){
        
        if !self.mediaNameTxt.text!.isEmpty {
            
            let optionMenu = UIAlertController(title: nil, message:NSLocalizedString("ALERT",comment:"Alert"), preferredStyle: .ActionSheet)
            
            let whatsappAction = UIAlertAction(title: NSLocalizedString("UPLOAD_ON_SERVER",comment:"Upload To Server"), style: .Default, handler: {
                (alert: UIAlertAction) -> Void in
                
                self.startLoadingIndicatorView("Uploading..")
                
                self.creayeMediaDataDict(self, success: { (responseObject: AnyObject?) in
                    self.uploadMediaOnServerCalled(responseObject as! NSDictionary)
                    }, failure: { (responseObject: AnyObject?) in
                        self.stopLoadingIndicatorView()
                })
            })
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL",comment:"Cancel"), style: .Cancel, handler: {
                (alert: UIAlertAction) -> Void in
                print("Cancel")
            })
            
            optionMenu.addAction(whatsappAction)
            optionMenu.addAction(cancelAction)
            
            if let popoverController = optionMenu.popoverPresentationController {
                popoverController.sourceView = self.buttonShare
                popoverController.sourceRect = self.buttonShare.bounds
            }
            self.presentViewController(optionMenu, animated: true, completion: nil)
            
        }else {
            self.showAlertMsg("Uploading !", message: "Please enter valid media name.")
        }
    }
    
    // MARK: - View layout setup methods
    
    func applyDefaults(){
        
        self.mediaNameTxt = TextField(frame: CGRectMake(10, 80 , self.view.frame.size.width - 20, 50))
        let userNamePlaceholder = NSAttributedString(string: "Media name", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.mediaNameTxt.attributedPlaceholder = userNamePlaceholder
        self.mediaNameTxt.autocapitalizationType = UITextAutocapitalizationType.None
        self.mediaNameTxt.keyboardType = UIKeyboardType.EmailAddress
        self.mediaNameTxt.delegate = self
        self.mediaNameTxt.layer.cornerRadius = 3
        self.mediaNameTxt.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(self.mediaNameTxt)
        
        if isMediaType == 1 {
            
            self.imagePreview = UIImageView(frame: CGRectMake(self.view.frame.origin.x + 10, self.mediaNameTxt.frame.size.height + 100, self.view.frame.size.width - 20, self.view.frame.size.height - (self.mediaNameTxt.frame.size.height + 130)))
            self.imagePreview.contentMode = .ScaleAspectFit
            self.imagePreview.image = selectedImage
            self.view.addSubview(self.imagePreview)
            
        }else if isMediaType == 3 {
            
            let url : NSURL = selectedVideoUrl
            moviePlayer = MPMoviePlayerController(contentURL: url)
            moviePlayer.view.frame = CGRect(x: self.view.frame.origin.x + 10, y: self.mediaNameTxt.frame.size.height + 100, width: self.view.frame.size.width - 20, height: self.view.frame.size.height - (self.mediaNameTxt.frame.size.height + 130))
            self.view.addSubview(moviePlayer.view)
            moviePlayer.fullscreen = true
            moviePlayer.controlStyle = MPMovieControlStyle.Embedded
            moviePlayer.shouldAutoplay = false
            
        }else if isMediaType == 2{
            
            let url : NSURL = selectedVideoUrl
            tempWebView = UIWebView(frame: CGRectMake(self.view.frame.origin.x + 10, self.mediaNameTxt.frame.size.height + 100, self.view.frame.size.width - 20, self.view.frame.size.height - (self.mediaNameTxt.frame.size.height + 130)))
            let urlRequest : NSURLRequest = NSURLRequest(URL: url)
            tempWebView.loadRequest(urlRequest)
            self.view.addSubview(tempWebView)
        }
        
    }
    
    
    // MARK: - Upload media Api call method
    
    func uploadMediaOnServerCalled(parameters : NSDictionary){
        
        self.api.uploadMediaWithBase64String( parameters as [NSObject : AnyObject], success: { ( operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
            let dictResponse : NSDictionary = responseObject as! NSDictionary
            self.stopLoadingIndicatorView()
            self.showSuccessAlertToUser(dictResponse.objectForKey("info") as! NSString)
            },
            failure: { ( operation: AFHTTPRequestOperation?, error: NSError? ) in
                self.stopLoadingIndicatorView()
                self.showAlertMsg("Uploading !", message: "Uploading media have some error, please try again later.")
        })
    }
    
    func creayeMediaDataDict(viewController:UIViewController, success:((responseObject: AnyObject? ) -> Void)?, failure:((error: NSError? ) -> Void)? ){
        
        let currentTime : Int64 = self.currentTimeMillis()
        let parameters : NSMutableDictionary = NSMutableDictionary()
        parameters["object_info[sub_category_id]"] = subCategoryId
        parameters["object_info[object_name]"] = self.mediaNameTxt.text
        parameters["object_info[sequence_no]"] = ""
        
        switch isMediaType {
            
        case 1 :
            let imageData = UIImagePNGRepresentation(selectedImage)
            let base64String = imageData!.base64EncodedStringWithOptions([])
            parameters["object_info[object_data]"] = base64String
            parameters["object_info[object_type]"] = 1
            parameters["file_name"] = "ios_upload_\(currentTime).png"
            
        case 3 :
            let url : NSURL = selectedVideoUrl
            let videoData = NSData(contentsOfURL: url)
            let base64String = videoData?.base64EncodedStringWithOptions([])
            parameters["object_info[object_data]"] = base64String
            parameters["object_info[object_type]"] = 3
            parameters["file_name"] = "ios_upload_\(currentTime).mp4"
            
        default :
            print("Default called")
        }
        
        if let success = success {
            success(responseObject: parameters)
        }
    }
    
    
    // MARK: - Text Field Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    // MARK: - Common methods
    
    func showSuccessAlertToUser(strMessage : NSString){
        
        let alert = UIAlertController(title: "Rondogo", message: strMessage as String, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomePage") as! HomePageViewController
                self.navigationController?.pushViewController(destinationViewController, animated: true)
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
    }
    
    func currentTimeMillis() -> Int64{
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    
}

