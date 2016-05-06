//
//  MediaPreviewViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 10/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer

class MediaPreviewViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePreview         : UIImageView!
    var moviePlayer          : MPMoviePlayerController!
    var tempWebView          : UIWebView!
    var socialShareDict      : MediaObject!


    // MARK: - View related methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor().appBackgroundColor()
        self.title =  NSLocalizedString("PREVIEW",comment:"Preview")
        self.addLeftNavigationBarButtonItemOnView()
        self.addRightNavigationBarButtonItemOnView()
        self.applyDefaults()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: -  Nanigation bar button and there methods
    
    func addRightNavigationBarButtonItemOnView() {
        
        let btnCamera: UIButton = UIButton(type: UIButtonType.Custom)
        btnCamera.frame = CGRectMake(0, 0, 35, 35)
        btnCamera.setImage(UIImage(named:"icon_camera.png"), forState: UIControlState.Normal)
        btnCamera.addTarget(self, action: "rightNavCameraButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarCamera: UIBarButtonItem = UIBarButtonItem(customView: btnCamera)
        self.navigationItem.setRightBarButtonItem(rightBarCamera, animated: false)
    }
    
    func rightNavCameraButtonTapped(){
        
        let optionMenu = UIAlertController(title: nil, message:NSLocalizedString("ALERT",comment:"Alert"), preferredStyle: .ActionSheet)
        
        let imageAction = UIAlertAction(title:NSLocalizedString("CAPTURE_IMAGE",comment:"Capture Image"), style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            self.openCameraToCaptureImage()
        })
        let videoAction = UIAlertAction(title: NSLocalizedString("CAPTURE_VIDEO",comment:"Capture Video"), style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            self.openCameraToCaptureVideo()
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL",comment:"Cancel"), style: .Cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        optionMenu.addAction(imageAction)
        optionMenu.addAction(videoAction)
        optionMenu.addAction(cancelAction)
        
        if let popoverController = optionMenu.popoverPresentationController {
        }
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    // MARK: - View layout setup methods

    func applyDefaults(){

        let mediaType : Int = self.socialShareDict.object_type as Int

        if mediaType == 1 {

            self.imagePreview = UIImageView(frame: CGRectMake(self.view.frame.origin.x + 10,70, self.view.frame.size.width - 20, self.view.frame.size.height - 130))
            self.imagePreview.contentMode = .ScaleAspectFit
            self.imagePreview.image = self.api.getImageFromDocumentDirectoryFileURL(self.socialShareDict)
            self.view.addSubview(self.imagePreview)

        }else if mediaType == 3 {

            let url : NSURL = self.api.getDocumentDirectoryFileURL(self.socialShareDict)
            moviePlayer = MPMoviePlayerController(contentURL: url)
            moviePlayer.view.frame = CGRect(x: self.view.frame.origin.x + 10, y: 70, width: self.view.frame.size.width - 20, height: 400)
            self.view.addSubview(moviePlayer.view)
            moviePlayer.fullscreen = true
            moviePlayer.play()
            moviePlayer.controlStyle = MPMovieControlStyle.Embedded
            moviePlayer.shouldAutoplay = false
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayerWillEnterFullScreen:" , name: MPMoviePlayerWillEnterFullscreenNotification, object: moviePlayer)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayerWillExitFullScreen:" , name: MPMoviePlayerWillExitFullscreenNotification, object: moviePlayer)

        }else if mediaType == 2{

            let url : NSURL = self.api.getDocumentDirectoryFileURL(self.socialShareDict)
            tempWebView = UIWebView(frame: CGRectMake(self.view.frame.origin.x + 10, 70, self.view.frame.size.width - 20, self.view.frame.size.height - 130))
            let urlRequest : NSURLRequest = NSURLRequest(URL: url)
            tempWebView.loadRequest(urlRequest)
            self.view.addSubview(tempWebView)

        }
    }


    func moviePlayerWillEnterFullScreen(notification: NSNotification) {
        print("Full screen enter")
        let applicationDel = UIApplication.sharedApplication().delegate as! AppDelegate
        applicationDel.restricRotation = false
    }

    func moviePlayerWillExitFullScreen(notification: NSNotification) {
        print("Full screen exist")
        let applicationDel = UIApplication.sharedApplication().delegate as! AppDelegate
        applicationDel.restricRotation = true
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - UIImagePickerController setup and Delegate methods
    
    func openCameraToCaptureImage(){
        
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
    
    func openCameraToCaptureVideo(){
        
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        var chosenImage : UIImage!
        var videoPath : NSURL!
        var isMediaTypeImage : Bool = false
        
        if mediaType.isEqualToString(kUTTypeImage as String) {
            /* Media is an image */
            isMediaTypeImage = true
            chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);
        } else if mediaType.isEqualToString(kUTTypeMovie as String) {
            /* Media is a video */
            //let url: AnyObject? = info[UIImagePickerControllerMediaURL]
            isMediaTypeImage = false
            videoPath = info[UIImagePickerControllerMediaURL] as! NSURL
            UISaveVideoAtPathToSavedPhotosAlbum("\(videoPath)",nil,nil,nil);
        }
        dismissViewControllerAnimated(true, completion:{
            if isMediaTypeImage {
                self.shareMediaOnSocials(chosenImage, videoURL: NSURL(), isImage: true)
            }else {
                self.shareMediaOnSocials(UIImage(), videoURL: videoPath, isImage: false)
            }
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}