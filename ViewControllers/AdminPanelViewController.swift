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

    // MARK: - View related methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ADMIN_PANEL",comment: "Admin Panel")
        self.view.backgroundColor = UIColor().appBackgroundColor()
        self.navigationController?.navigationBarHidden = false
        self.addLeftNavigationBarButtonItemOnView()
        self.applyDefaults()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - View layout setup methods
    
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
        self.btnUploadVideo.titleLabel?.font = UIFont.boldSystemFontOfSize(17.0)
        self.btnUploadVideo.setBackgroundImage(imgButtonBGImage, forState: .Normal)
        self.btnUploadVideo.addTarget(self, action: "uploadVideoButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnUploadVideo)
        
        self.btnUploadImages.setTitle(NSLocalizedString("UPLOAD_IMAGE",comment:"Upload Image"), forState: .Normal)
        self.btnUploadImages.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.btnUploadImages.titleLabel?.font = UIFont.boldSystemFontOfSize(17.0)
        self.btnUploadImages.setBackgroundImage(imgButtonBGImage, forState: .Normal)
        self.btnUploadImages.addTarget(self, action: "uploadImageButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnUploadImages)

        self.btnCaptureVideo.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.btnCaptureVideo.setTitle(NSLocalizedString("CAPTURE_VIDEO",comment:"Capture Video"), forState: .Normal)
        self.btnCaptureVideo.setBackgroundImage(imgButtonBGImage, forState: .Normal)
        self.btnCaptureVideo.titleLabel?.font = UIFont.boldSystemFontOfSize(17.0)
        self.btnCaptureVideo.addTarget(self, action: "captureVideoButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnCaptureVideo)

        self.btnCaptureImage.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.btnCaptureImage.setTitle(NSLocalizedString("CAPTURE_IMAGE",comment:"Capture Image"), forState: .Normal)
        self.btnCaptureImage.setBackgroundImage(imgButtonBGImage, forState: .Normal)
        self.btnCaptureImage.titleLabel?.font = UIFont.boldSystemFontOfSize(17.0)
        self.btnCaptureImage.addTarget(self, action: "captureImageButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnCaptureImage)

    }
    
    // MARK: - Button Tapped methods
    
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
        self.showAlertMsg("PDF", message:NSLocalizedString("UPLOAD_PDF",comment:"Upload Pdf"))
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
            self.showAlertMsg(NSLocalizedString("ALERT",comment:"Alert"), message:NSLocalizedString("CAMERA_NOT_AVAILABLE",comment:"Camera Not Available in Device"))
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
            self.showAlertMsg(NSLocalizedString("ALERT",comment:"Alert"), message:NSLocalizedString("CAMERA_NOT_AVAILABLE",comment:"Camera Not Available in Device"))
        }
    }
    
    
    // MARK: - UIImagePickerController Delegate methods
    
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

}
