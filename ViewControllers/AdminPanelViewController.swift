//
//  AdminPanelViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 23/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import MobileCoreServices

class AdminPanelViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    var btnUploadVideo  : UIButton!
    var btnUploadImages : UIButton!
    var btnUploadPdf    : UIButton!
    
    var btnCaptureImage : UIButton!
    var btnCaptureVideo : UIButton!
    
    var categoryId : NSInteger!
    var subCategoryId : NSInteger!

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
    
        let vertiCalSepImage : UIImageView = UIImageView(frame: CGRectMake(self.view.center.x , self.view.center.y, 1, self.view.frame.size.height))
        vertiCalSepImage.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(vertiCalSepImage)
        
        let horizonatalSepImage : UIImageView = UIImageView(frame: CGRectMake(self.view.frame.origin.x , self.view.center.y, self.view.frame.size.width,1))
        horizonatalSepImage.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(horizonatalSepImage)

        let horizonatalSepImage1 : UIImageView = UIImageView(frame: CGRectMake(self.view.frame.origin.x , self.view.center.y + self.view.frame.size.height / 4, self.view.frame.size.width,1))
        horizonatalSepImage1.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(horizonatalSepImage1)
        
        /* Setting Buttons  */
        let width : CGFloat =  (self.view.frame.size.width - 1) / 2
        let height : CGFloat =  (self.view.frame.size.height - 1) / 4

        self.btnUploadVideo     = UIButton(frame: CGRectMake(self.view.frame.origin.x, self.view.center.y, width, height))
        self.btnUploadImages    = UIButton(frame: CGRectMake(self.view.frame.origin.x + width + 1, self.view.center.y, width, height))
        self.btnCaptureVideo     = UIButton(frame: CGRectMake(self.view.frame.origin.x, self.view.center.y + height + 1 , width, height))
        self.btnCaptureImage    = UIButton(frame: CGRectMake(self.view.frame.origin.x + width + 1, self.view.center.y + height + 1 , width, height))

        let imgButtonBGImage = UIImage(named:  "icon_adminPanel.png") as UIImage?
        
        self.btnUploadVideo.setTitle(NSLocalizedString("UPLOAD_VIDEO",comment:"Upload Video"), forState: .Normal)
        self.btnUploadVideo.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.btnUploadVideo.setBackgroundImage(imgButtonBGImage, forState: .Normal)
        self.btnUploadVideo.addTarget(self, action: "uploadVideoButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnUploadVideo)
        
        self.btnUploadImages.setTitle(NSLocalizedString("UPLOAD_IMAGE",comment:"Upload Image"), forState: .Normal)
        self.btnUploadImages.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.btnUploadImages.setBackgroundImage(imgButtonBGImage, forState: .Normal)
        self.btnUploadImages.addTarget(self, action: "uploadImageButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnUploadImages)

        self.btnCaptureVideo.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.btnCaptureVideo.setTitle(NSLocalizedString("CAPTURE_VIDEO",comment:"Capture Video"), forState: .Normal)
        self.btnCaptureVideo.setBackgroundImage(imgButtonBGImage, forState: .Normal)
        self.btnCaptureVideo.addTarget(self, action: "captureVideoButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnCaptureVideo)

        self.btnCaptureImage.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.btnCaptureImage.setTitle(NSLocalizedString("CAPTURE_IMAGE",comment:"Capture Image"), forState: .Normal)
        self.btnCaptureImage.setBackgroundImage(imgButtonBGImage, forState: .Normal)
        self.btnCaptureImage.addTarget(self, action: "captureImageButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnCaptureImage)

    }
    
    /* ============= Button Tapped method Start ===================== */
    
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
    
    /* ============= Button Tapped method End  ===================== */
    
    /*=================== MARK: UIImagePickerController Delegates start =============*/
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        var chosenImage : UIImage!
        var intMediaType : Int!
        var url : NSURL!
        
        if mediaType.isEqualToString(kUTTypeImage as String) {
            /* Media is an image */
            chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            intMediaType = 1
        } else if mediaType.isEqualToString(kUTTypeMovie as String) {
            /* Media is a video */
            //let url: AnyObject? = info[UIImagePickerControllerMediaURL]
            
            url = info[UIImagePickerControllerMediaURL] as! NSURL
            intMediaType = 3
            print(url)
        }
        dismissViewControllerAnimated(true, completion: {
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AdminMediaPreview") as! AdminMediaPreviewViewController
            destinationViewController.selectedImage = chosenImage
            destinationViewController.selectedVideoUrl = url
            destinationViewController.isMediaType = intMediaType
            destinationViewController.categoryId = self.categoryId
            destinationViewController.subCategoryId = self.subCategoryId
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*=================== MARK: UIImagePickerController Delegates End =============*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
