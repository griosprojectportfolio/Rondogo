//
//  UploadMediaViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 04/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class UploadMediaViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    var btnUploadVideo  : UIButton!
    var btnUploadImages : UIButton!
    var btnUploadPdf    : UIButton!
    
    var btnCaptureImage : UIButton!
    var btnCaptureVideo : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ADMIN_PANEL",comment: "Admin Panel")
        self.view.backgroundColor = UIColor().appBackgroundColor()
        self.navigationController?.navigationBarHidden = false
        self.addRightAndLeftNavItemOnView()
        self.applyDefaults()
    }
    
    func addRightAndLeftNavItemOnView()
    {
        let buttonBack: UIButton = UIButton(type: UIButtonType.Custom)
        buttonBack.frame = CGRectMake(0, 0, 40, 40)
        buttonBack.setImage(UIImage(named:"icon_back.png"), forState: UIControlState.Normal)
        buttonBack.addTarget(self, action: "leftNavBackButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        let leftBarButtonItemback: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItemback, animated: false)
    }
    
    func leftNavBackButtonTapped(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func applyDefaults(){
        
        self.btnUploadVideo     = UIButton(frame: CGRectMake(20, 100, self.view.frame.size.width - 40, 40))
        self.btnUploadImages    = UIButton(frame: CGRectMake(20, 160, self.view.frame.size.width - 40, 40))
        self.btnUploadPdf       = UIButton(frame: CGRectMake(20, 220, self.view.frame.size.width - 40, 40))
        self.btnCaptureImage    = UIButton(frame: CGRectMake(20, 280, self.view.frame.size.width - 40, 40))
        self.btnCaptureVideo    = UIButton(frame: CGRectMake(20, 340, self.view.frame.size.width - 40, 40))
        
        self.btnUploadVideo.setTitle(NSLocalizedString("UPLOAD_VIDEO",comment:"Upload Video"), forState: .Normal)
        self.btnUploadVideo.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.btnUploadVideo.backgroundColor = UIColor.yellowColor()
        self.btnUploadVideo.layer.borderWidth = 0.5
        self.btnUploadVideo.layer.cornerRadius = 5
        self.btnUploadVideo.layer.borderColor = UIColor.redColor().CGColor
        self.btnUploadVideo.addTarget(self, action: "uploadVideoButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnUploadVideo)
        
        self.btnUploadImages.setTitle(NSLocalizedString("UPLOAD_IMAGE",comment:"Upload Image"), forState: .Normal)
        self.btnUploadImages.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.btnUploadImages.backgroundColor = UIColor.yellowColor()
        self.btnUploadImages.layer.borderWidth = 0.5
        self.btnUploadImages.layer.cornerRadius = 5
        self.btnUploadImages.layer.borderColor = UIColor.redColor().CGColor
        self.btnUploadImages.addTarget(self, action: "uploadImageButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnUploadImages)
        
        self.btnUploadPdf.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.btnUploadPdf.setTitle(NSLocalizedString("UPLOAD_PDF",comment:"Upload Pdf"), forState: .Normal)
        self.btnUploadPdf.backgroundColor = UIColor.yellowColor()
        self.btnUploadPdf.layer.borderWidth = 0.5
        self.btnUploadPdf.layer.cornerRadius = 5
        self.btnUploadPdf.layer.borderColor = UIColor.redColor().CGColor
        self.btnUploadPdf.addTarget(self, action: "uploadPdfButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnUploadPdf)
        
        self.btnCaptureImage.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.btnCaptureImage.setTitle(NSLocalizedString("CAPTURE_IMAGE",comment:"Capture Image"), forState: .Normal)
        self.btnCaptureImage.backgroundColor = UIColor.yellowColor()
        self.btnCaptureImage.layer.borderWidth = 0.5
        self.btnCaptureImage.layer.cornerRadius = 5
        self.btnCaptureImage.layer.borderColor = UIColor.redColor().CGColor
        self.btnCaptureImage.addTarget(self, action: "captureImageButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnCaptureImage)
        
        self.btnCaptureVideo.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.btnCaptureVideo.setTitle(NSLocalizedString("CAPTURE_VIDEO",comment:"Capture Video"), forState: .Normal)
        self.btnCaptureVideo.backgroundColor = UIColor.yellowColor()
        self.btnCaptureVideo.layer.borderWidth = 0.5
        self.btnCaptureVideo.layer.cornerRadius = 5
        self.btnCaptureVideo.layer.borderColor = UIColor.redColor().CGColor
        self.btnCaptureVideo.addTarget(self, action: "captureVideoButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnCaptureVideo)
    }
    
    func uploadVideoButtonTapped(){
        let savedVideoPicker = UIImagePickerController()
        savedVideoPicker.delegate = self
        savedVideoPicker.allowsEditing = false
        savedVideoPicker.sourceType = .SavedPhotosAlbum
        savedVideoPicker.mediaTypes = [String(kUTTypeMovie)]
        presentViewController(savedVideoPicker, animated: true, completion: nil)
    }
    
    func uploadImageButtonTapped(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func uploadPdfButtonTapped(){
        let alert = UIAlertController(  title: "PDF",
                                        message:NSLocalizedString("UPLOAD_PDF",comment:"Upload Pdf"),
                                        preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK",comment:"Ok"), style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func captureImageButtonTapped(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            let captureImage = UIImagePickerController()
            captureImage.delegate = self
            captureImage.sourceType = UIImagePickerControllerSourceType.Camera
            captureImage.mediaTypes = [String(kUTTypeImage)]
            captureImage.allowsEditing = false
            self.presentViewController(captureImage, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(  title: NSLocalizedString("ALERT",comment:"Alert"),
                                            message: NSLocalizedString("CAMERA_NOT_AVAILABLE",comment:"Camera Not Available in Device"),
                                            preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK",comment:"Ok"), style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func captureVideoButtonTapped(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            let captureVideo = UIImagePickerController()
            captureVideo.delegate = self
            captureVideo.sourceType = UIImagePickerControllerSourceType.Camera
            captureVideo.mediaTypes = [String(kUTTypeMovie)]
            captureVideo.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Video
            self.presentViewController(captureVideo, animated: false ) { () -> Void in  }
            
        }else{
            let alert = UIAlertController(  title: NSLocalizedString("ALERT",comment:"Alert"),
                message: NSLocalizedString("CAMERA_NOT_AVAILABLE",comment:"Camera Not Available in Device"),
                preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK",comment:"Ok"), style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /* MARK: UIImagePickerController Delegates */
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        var chosenImage : UIImage!
        var isMediaTypeImage : Int!
        var url : NSURL!
        
        if mediaType.isEqualToString(kUTTypeImage as String) {
            /* Media is an image */
            chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            isMediaTypeImage = 0
        } else if mediaType.isEqualToString(kUTTypeMovie as String) {
            /* Media is a video */
            //let url: AnyObject? = info[UIImagePickerControllerMediaURL]

            url = info[UIImagePickerControllerMediaURL] as! NSURL
            isMediaTypeImage = 2
            print(url)
        }
        dismissViewControllerAnimated(true, completion: {
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MediaPreview") as! MediaPreviewViewController
            destinationViewController.selectedImage = chosenImage
            destinationViewController.selectedVideoUrl = url
            destinationViewController.isMediaTypeImage = isMediaTypeImage
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
