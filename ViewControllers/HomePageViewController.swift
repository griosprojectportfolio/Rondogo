//
//  HomePageViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 04/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit
import Foundation

class HomePageViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var logoImageView       : UIImageView!
    var collectionView      : UICollectionView!
    let flowLayout          : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var btnLogin            : UIButton!
    var btnSettings         : UIButton!
    var arrCategories       : NSArray = NSArray()

    // MARK: - Current view related methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyDefaults()
        self.loadMediaDataFromServer()
        self.navigationController?.navigationBarHidden = true

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        self.showAndHideLoginAndSettingsButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
//        let value = UIInterfaceOrientation.Portrait.rawValue
//        UIDevice.currentDevice().setValue(value, forKey: "orientation")
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

            self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 125, 40, 250, 150))
            self.btnLogin = UIButton(frame: CGRectMake(self.view.frame.origin.x + 20, self.view.frame.size.height - 85, 80, 80))
            self.btnSettings = UIButton(frame: CGRectMake(self.view.frame.size.width - 100, self.view.frame.size.height - 85, 80, 80))

        }else if isiPhone6{

            self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 140, 40, 280, 180))
            self.btnLogin = UIButton(frame: CGRectMake(self.view.frame.origin.x + 20, self.view.frame.size.height - 105, 100, 100))
            self.btnSettings = UIButton(frame: CGRectMake(self.view.frame.size.width - 120, self.view.frame.size.height - 105, 100, 100))

        }else if isiPhone6plus{

            self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 150, 40, 300, 200))
            self.btnLogin = UIButton(frame: CGRectMake(self.view.frame.origin.x + 20, self.view.frame.size.height - 105, 100, 100))
            self.btnSettings = UIButton(frame: CGRectMake(self.view.frame.size.width - 120, self.view.frame.size.height - 105, 100, 100))

        }else {

            self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 165, 40, 300, 200))
            self.btnLogin = UIButton(frame: CGRectMake(self.view.frame.origin.x + 20, self.view.frame.size.height - 105, 100, 100))
            self.btnSettings = UIButton(frame: CGRectMake(self.view.frame.size.width - 120, self.view.frame.size.height - 105, 100, 100))
        }

        self.logoImageView.image = UIImage (named: "HomePageLogo.png")
        self.view.addSubview(self.logoImageView)

        collectionView = UICollectionView(frame: CGRectMake(self.view.frame.origin.x + 20, self.logoImageView.frame.size.height + 60, self.view.frame.size.width - 40, self.view.frame.size.height - (self.logoImageView.frame.size.height + 70 + self.btnLogin.frame.size.height)), collectionViewLayout: flowLayout)
        collectionView?.registerClass(CollectionCell.self, forCellWithReuseIdentifier: "categoryCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
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


    // MARK: - Collection view Delegate method
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCategories.count
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width / 3.5, height: self.collectionView.frame.size.width / 3.5);
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let objCategory : Categories = self.arrCategories[indexPath.row] as! Categories

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCell", forIndexPath: indexPath) as! CollectionCell
        cell.configureCellLayout(cell.frame)
        let urlString : String = objCategory.cat_imageUrl

        //cell.imageView.image = nil
        cell.imageView.sd_setImageWithURL(NSURL(string: urlString), placeholderImage: nil , completed:{(image: UIImage?, error: NSError?, cacheType: SDImageCacheType!, imageURL: NSURL?) in
            if self.arrCategories.count == indexPath.row + 1 {
                self.stopLoadingIndicatorView()
            }
            if self.isiPhone4s{
                self.stopLoadingIndicatorView()
            }
        })

        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let objCategory : Categories = self.arrCategories[indexPath.row] as! Categories
        let cellSelected : CollectionCell = self.collectionView!.cellForItemAtIndexPath(indexPath) as! CollectionCell
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: false)

        let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailView") as! DetailViewController
        destinationViewController.strNavigationTittle = objCategory.cat_name
        destinationViewController.categoryId = objCategory.cat_id as NSInteger
        destinationViewController.categoryImage = cellSelected.imageView.image
        self.navigationController?.pushViewController(destinationViewController, animated: true)
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
        }else {
            self.btnLogin.hidden = true
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
        if self.arrCategories.count != 0 {
            self.collectionView.reloadData()
        }else {
            self.stopLoadingIndicatorView()
        }
    }
    
}
