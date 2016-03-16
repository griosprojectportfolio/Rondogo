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

class MediaPreviewViewController: BaseViewController,BottomTabBarDelegate {

    var imagePreview         : UIImageView!
    var moviePlayer          : MPMoviePlayerController!
    var tempWebView          : UIWebView!
    var socialShareDict      : MediaObject!
    var bottomTabBar         : BottomTabBarView!


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

        bottomTabBar = BottomTabBarView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.size.height - 50, self.view.frame.size.width ,50))
        bottomTabBar.bottomBarDelegate = self
        bottomTabBar.addBottomViewWithShareOptions()
        self.view.addSubview(bottomTabBar)

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


    // MARK: - BottomTabBarDelegate Delegate Method

    func sendTappedButtonTag(sender: AnyObject){

        if self.auth_token[0] != "" {

            let btnSender = sender as! UIButton

            switch btnSender.tag {

            case 0 : bottomTabBar.btnWhatsAppTapped(self.socialShareDict)

            case 1 : self.openDefaultFacebookPage()

            case 2 : bottomTabBar.btnDropBoxTapped(self.socialShareDict, viewController: self)

            case 3 : bottomTabBar.btnWazeTapped(sender)

            default:
                print("Other Button Tapped")
            }
        }else {
            self.showAlertMsg("Login required !", message:"Please login to share media on socials.")
        }
    }
    
    
}