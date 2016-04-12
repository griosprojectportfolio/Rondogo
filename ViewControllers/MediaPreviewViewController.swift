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

class MediaPreviewViewController: BaseViewController {

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
    
}