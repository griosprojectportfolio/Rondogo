//
//  HomePageViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 04/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit
import Foundation

class HomePageViewController: BaseViewController, facebookDataDelegate, homePageCellDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var logoImageView       : UIImageView!
    var collectionView      : UICollectionView!
    let flowLayout          : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var btnLogin            : UIButton!
    var btnFbLogin          : UIButton!
    var btnSettings         : UIButton!
    var arrCategories       : NSArray = NSArray()

    // MARK: - Current view related methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyDefaults()
        self.navigationController?.navigationBarHidden = true
        self.social.fbDelegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        self.loadMediaDataFromServer()
        self.showAndHideLoginAndSettingsButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        // let value = UIInterfaceOrientation.Portrait.rawValue
        // UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }


    // MARK: - Page layout methods
    func applyDefaults(){

        if isiPhone5orLower{

            self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 125, 20, 250, 150))
            self.btnLogin = UIButton(frame: CGRectMake(self.view.frame.origin.x + 20, self.view.frame.size.height - 85, 80, 80))
            self.btnFbLogin = UIButton(frame: CGRectMake(self.view.center.x - 40, self.view.frame.size.height - 85, 80, 80))
            self.btnSettings = UIButton(frame: CGRectMake(self.view.frame.size.width - 100, self.view.frame.size.height - 85, 80, 80))

        }else if isiPhone6{

            self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 140, 20, 280, 180))
            self.btnLogin = UIButton(frame: CGRectMake(self.view.frame.origin.x + 20, self.view.frame.size.height - 105, 100, 100))
            self.btnFbLogin = UIButton(frame: CGRectMake(self.view.center.x - 50, self.view.frame.size.height - 105, 100, 100))
            self.btnSettings = UIButton(frame: CGRectMake(self.view.frame.size.width - 120, self.view.frame.size.height - 105, 100, 100))

        }else if isiPhone6plus{

            self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 150, 20, 300, 200))
            self.btnLogin = UIButton(frame: CGRectMake(self.view.frame.origin.x + 20, self.view.frame.size.height - 105, 100, 100))
            self.btnFbLogin = UIButton(frame: CGRectMake(self.view.center.x - 50, self.view.frame.size.height - 105, 100, 100))
            self.btnSettings = UIButton(frame: CGRectMake(self.view.frame.size.width - 120, self.view.frame.size.height - 105, 100, 100))

        }else {

            self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 165, 20, 300, 200))
            self.btnLogin = UIButton(frame: CGRectMake(self.view.frame.origin.x + 20, self.view.frame.size.height - 105, 100, 100))
            self.btnFbLogin = UIButton(frame: CGRectMake(self.view.center.x - 50, self.view.frame.size.height - 105, 100, 100))
            self.btnSettings = UIButton(frame: CGRectMake(self.view.frame.size.width - 120, self.view.frame.size.height - 105, 100, 100))
        }

        self.logoImageView.image = UIImage (named: "HomePageLogo.png")
        self.view.addSubview(self.logoImageView)

        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionView = UICollectionView(frame: CGRectMake(self.view.frame.origin.x + 20, self.logoImageView.frame.size.height + 20, self.view.frame.size.width - 40, self.view.frame.size.height - (self.logoImageView.frame.size.height + 50 + self.btnLogin.frame.size.height)), collectionViewLayout: flowLayout)
        collectionView?.registerClass(CollectionCell.self, forCellWithReuseIdentifier: "categoryCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView.scrollEnabled = true
        collectionView?.backgroundColor = UIColor.clearColor()
        self.view.addSubview(collectionView!)

        let imgLogin = UIImage(named:  "icon_login.png") as UIImage?
        self.btnLogin.setImage(imgLogin, forState: .Normal)
        self.btnLogin.addTarget(self, action: "btnLink1ButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnLogin)

        if selectedLanguage.isEqualToString(hebrew) {
            let imgSetings = UIImage(named:  "icon_settings_hebrew") as UIImage?
            self.btnSettings.setImage(imgSetings, forState: .Normal)
            let imgLogin = UIImage(named:  "hebrew_login_icon") as UIImage?
            self.btnLogin.setImage(imgLogin, forState: .Normal)
        }else{
            let imgSetings = UIImage(named:  "icon_settings_english") as UIImage?
            self.btnSettings.setImage(imgSetings, forState: .Normal)
            let imgLogin = UIImage(named:  "icon_login.png") as UIImage?
            self.btnLogin.setImage(imgLogin, forState: .Normal)
        }
        //let imgSetings = UIImage(named:  "icon_settings.png") as UIImage?
        
        self.btnFbLogin.addTarget(self, action: "loginViaFacebookButtonTapped:", forControlEvents:.TouchUpInside)
        self.btnFbLogin.setBackgroundImage(UIImage(named: "icon_fb_login") as UIImage?, forState: .Normal)
        self.view.addSubview(self.btnFbLogin)
        
        self.btnSettings.addTarget(self, action: "btnLink3ButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnSettings)

    }

    func btnLink1ButtonTapped(){
        if self.auth_token[0] == "" {
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }

    func btnLink3ButtonTapped(){
        let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsView") as! SettingsViewController
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }

    
    // MARK: -  Social Integration Methods
    @IBAction func loginViaFacebookButtonTapped(sender: UIButton) {
        self.startLoadingIndicatorView("Registering..")
        self.social.getFacebookUsersBasicInformation()
    }

    // MARK: - Collection view Delegate method
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCategories.count
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width / 2.1, height: self.collectionView.frame.size.width / 2.1);
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let objCategory : Categories = self.arrCategories[indexPath.row] as! Categories

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCell", forIndexPath: indexPath) as! CollectionCell
        cell.tag = objCategory.cat_id as NSInteger
        cell.homePageDelegate = self
        cell.configureCellLayout(cell.frame)
        
        let urlString : String = objCategory.cat_imageUrl
        cell.imageView.sd_setImageWithURL(NSURL(string: urlString), placeholderImage: nil , completed:{(image: UIImage?, error: NSError?, cacheType: SDImageCacheType!, imageURL: NSURL?) in
            self.stopLoadingIndicatorView()
        })
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        /*
        let objCategory : Categories = self.arrCategories[indexPath.row] as! Categories
        let cellSelected : CollectionCell = self.collectionView!.cellForItemAtIndexPath(indexPath) as! CollectionCell
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: false)

        let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailView") as! DetailViewController
        destinationViewController.strNavigationTittle = objCategory.cat_name
        destinationViewController.categoryId = objCategory.cat_id as NSInteger
        destinationViewController.categoryImage = cellSelected.imageView.image
        self.navigationController?.pushViewController(destinationViewController, animated: true)
        */
    }

     // MARK: - homePageCellDelegate Methods
    
    func selectedPickerOption(objSubCategory : SubCategories) {
        let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShowMedia") as! ShowMediaViewController
        destinationViewController.categoryId = objSubCategory.cat_id as NSInteger
        destinationViewController.subCategoryId = objSubCategory.subCat_id as NSInteger
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    // MARK: - facebookDataDelegate Methods
    
    func currentFacebookUserData(dictResponse: NSDictionary) {
        
        let parameters : NSMutableDictionary = self.getFilteredParamsForLoginViaFacebook(dictResponse)
        
        self.api.signViaFacebook(parameters as [NSObject : AnyObject], success: { ( operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
            
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                let token : NSString = (dictResponse.objectForKey("data") as! NSDictionary).objectForKey("auth_token") as! NSString
                self.auth_token = [token]
                self.stopLoadingIndicatorView()
                self.showAndHideLoginAndSettingsButton()
                self.showAlertMsg("Facebook !", message: "Your are successfully logged in.")
            },
            failure: { ( operation: AFHTTPRequestOperation?, error: NSError? ) in
                print(error)
                self.stopLoadingIndicatorView()
                do {
                    let dictUser : AnyObject = try NSJSONSerialization.JSONObjectWithData(operation!.responseData, options: NSJSONReadingOptions.MutableLeaves)
                    self.showAlertMsg("Facebook !", message: dictUser["info"] as! String)
                }catch {
                    self.showAlertMsg("Facebook !", message: "Signup via facebook have some error, please try again later.")
                }
        })
    }
    
    func failedToGetFacebookUserData(errorMessage:String) {
        self.stopLoadingIndicatorView()
        self.showAlertMsg("Facebook !", message: errorMessage)
    }
    
    func getFilteredParamsForLoginViaFacebook(dictProfile: NSDictionary) -> NSMutableDictionary {
        
        let dictParams : NSMutableDictionary = ["user[first_name]": "", "user[last_name]": "", "user[email]": "", "user[password]": "", "user[confirm_password]": ""]
        
        if let facebook_id : String = dictProfile["id"] as? String {
            dictParams["user[facebook_id]"] = facebook_id
            dictParams["user[password]"] = facebook_id
            dictParams["user[confirm_password]"] = facebook_id
        }
        if let first_name : String = dictProfile["first_name"] as? String {
            dictParams["user[first_name]"] = first_name
        }
        if let last_name : String = dictProfile["last_name"] as? String {
            dictParams["user[last_name]"] = last_name
        }
        if let email : String = dictProfile["email"] as? String {
            dictParams["user[email]"] = email
        }else {
            dictParams["user[email]"] = "\(dictProfile["id"] as! String)@rondogo.com"
        }
        return dictParams
    }

    // MARK: - Some common methods
    
    func loadMediaDataFromServer(){

        let objSyncApp : SynchronizeApp = SynchronizeApp()

        objSyncApp.startSyncMethodCall(self, success: { (responseObject: AnyObject?) in

            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.getAllCategoriesDataFromLocalDB()
            })
            }, failure: { (responseObject: AnyObject?) in
                self.stopLoadingIndicatorView()
        })
        self.startLoadingIndicatorView("Loading...")
    }

    func showAndHideLoginAndSettingsButton() {
        if self.auth_token[0] == "" {
            self.btnLogin.hidden = false
            self.btnFbLogin.hidden = false
        }else {
            self.btnLogin.hidden = true
            self.btnFbLogin.hidden = true
        }
    }

    func getAllCategoriesDataFromLocalDB() {

        var strLanguage : String = String()
        if self.selectedLanguage == hebrew {
            strLanguage = "Hebrew"
        }else {
            strLanguage = "English"
        }
        let categoryFilter : NSPredicate = NSPredicate(format: "cat_language = %@ AND is_deleted = 0",strLanguage)
        self.arrCategories = Categories.MR_findAllSortedBy("cat_sequence", ascending: true, withPredicate: categoryFilter)
        self.collectionView.reloadData()
        self.stopLoadingIndicatorView()
    }

}
