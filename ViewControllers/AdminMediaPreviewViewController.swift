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

class AdminMediaPreviewViewController: BaseViewController {
    
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
    }
    
    // MARK: - View layout setup methods
    
    func applyDefaults(){
        
        if isMediaType == 1 {
            
            self.imagePreview = UIImageView(frame: CGRectMake(self.view.frame.origin.x + 10,70, self.view.frame.size.width - 20, self.view.frame.size.height - 130))
            self.imagePreview.contentMode = .ScaleAspectFit
            self.imagePreview.image = selectedImage
            self.view.addSubview(self.imagePreview)
            
        }else if isMediaType == 3 {
            
            let url : NSURL = selectedVideoUrl
            moviePlayer = MPMoviePlayerController(contentURL: url)
            moviePlayer.view.frame = CGRect(x: self.view.frame.origin.x + 10, y: 70, width: self.view.frame.size.width - 20, height: self.view.frame.size.height - 130)
            self.view.addSubview(moviePlayer.view)
            moviePlayer.fullscreen = true
            moviePlayer.controlStyle = MPMovieControlStyle.Embedded
            moviePlayer.shouldAutoplay = false
            
        }else if isMediaType == 2{
            
            let url : NSURL = selectedVideoUrl
            tempWebView = UIWebView(frame: CGRectMake(self.view.frame.origin.x + 10, 70, self.view.frame.size.width - 20, self.view.frame.size.height - 130))
            let urlRequest : NSURLRequest = NSURLRequest(URL: url)
            tempWebView.loadRequest(urlRequest)
            self.view.addSubview(tempWebView)
        }
        
    }
    
    
    // MARK: - Upload media Api call method
    
    func uploadMediaOnServerCalled(parameters : NSDictionary){
        
        self.api.uploadMediaWithBase64String( parameters as [NSObject : AnyObject], success: { ( operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
                print(responseObject)
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                self.stopLoadingIndicatorView()
                self.showSuccessAlertToUser(dictResponse.objectForKey("info") as! NSString)
            },
            failure: { ( operation: AFHTTPRequestOperation?, error: NSError? ) in
                print(error)
                self.stopLoadingIndicatorView()
                self.showAlertMsg("Uploading !", message: "Uploading media have some error, please try again later.")
        })
    }
    
    func creayeMediaDataDict(viewController:UIViewController, success:((responseObject: AnyObject? ) -> Void)?, failure:((error: NSError? ) -> Void)? ){
        
        let parameters : NSMutableDictionary = NSMutableDictionary()
        parameters["object_info[sub_category_id]"] = subCategoryId
        parameters["object_info[object_name]"] = "testUpload"
        parameters["object_info[sequence_no]"] = ""

        switch isMediaType {
            
        case 1 :
            let imageData = UIImagePNGRepresentation(selectedImage)
            let base64String = imageData!.base64EncodedStringWithOptions([])
            parameters["object_info[object_data]"] = base64String
            parameters["object_info[object_type]"] = 1
            parameters["object_info[file_name]"] = "abc.png"
            
        case 3 :
            let url : NSURL = selectedVideoUrl
            let videoData = NSData(contentsOfURL: url)
            let base64String = videoData?.base64EncodedStringWithOptions([])
            parameters["object_info[object_data]"] = base64String
            parameters["object_info[object_type]"] = 3
            parameters["object_info[file_name]"] = "abc.mp4"
            
        default :
            print("Default called")
        }
        
        if let success = success {
            success(responseObject: parameters)
        }
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
    
    
}

