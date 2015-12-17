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
    var isMediaTypeImage     : Int!
    var selectedImage        : UIImage!
    var selectedVideoUrl     : NSURL!
    
    var bottomTabBar         : BottomTabBarView!
    var moviePlayer          : MPMoviePlayerController!
    var tempWebView          : UIWebView!
    var socialShareDict      : NSDictionary = NSDictionary()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor().appBackgroundColor()
        self.title =  NSLocalizedString("PREVIEW",comment:"Preview")
        self.addRightAndLeftNavItemOnView()
        //print(selectedVideoUrl, terminator: "")
        self.applyDefaults()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        
        if isMediaTypeImage == 1 {
            self.imagePreview = UIImageView(frame: CGRectMake(self.view.frame.origin.x + 10,70, self.view.frame.size.width - 20, 400))
            self.imagePreview.contentMode = .ScaleAspectFit
            self.imagePreview.image = selectedImage
            self.view.addSubview(self.imagePreview)
        }else if isMediaTypeImage == 3 {
            
            var url : NSURL = selectedVideoUrl
            moviePlayer = MPMoviePlayerController(contentURL: selectedVideoUrl)
            moviePlayer.view.frame = CGRect(x: self.view.frame.origin.x + 10, y: 70, width: self.view.frame.size.width - 20, height: 400)
            self.view.addSubview(moviePlayer.view)
            moviePlayer.fullscreen = true
            //moviePlayer.play()
            //moviePlayer.controlStyle = MPMovieControlStyle.Embedded
            moviePlayer.shouldAutoplay = false
        }else if isMediaTypeImage == 2{
            
            let url : NSURL = selectedVideoUrl
            tempWebView = UIWebView(frame: CGRectMake(self.view.frame.origin.x + 10, 70, self.view.frame.size.width - 20, 400))
            let urlRequest : NSURLRequest = NSURLRequest(URL: url)
            tempWebView.loadRequest(urlRequest)
            self.view.addSubview(tempWebView)

        }
        
        bottomTabBar = BottomTabBarView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.size.height - 50, self.view.frame.size.width ,50))
        bottomTabBar.bottomBarDelegate = self
        bottomTabBar.addBottomViewWithShareOptions()
        self.view.addSubview(bottomTabBar)

    }
    
    /* BottomTabBarDelegate Delegate Method */
    
    func sendTappedButtonTag(sender: AnyObject){
        
        if self.auth_token[0] != "" {
            
            let btnSender = sender as! UIButton
            
            switch btnSender.tag {
                
            case 0 : bottomTabBar.btnWhatsAppTapped(self.socialShareDict)
                
            case 1 : self.shareMediaOnFacebook(self.socialShareDict)
                
            case 2 : bottomTabBar.btnDropBoxTapped(self.socialShareDict, viewController: self)
                
            case 3 : bottomTabBar.btnWazeTapped(sender)
                
            default:
                print("Other Button Tapped")
            }
        }else {
            let alert:UIAlertView! = UIAlertView(title:"Login!", message:"Please login to share media. ", delegate:nil, cancelButtonTitle:"OK")
            alert.show()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}