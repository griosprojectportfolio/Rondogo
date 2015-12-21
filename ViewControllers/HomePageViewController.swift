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
    
    
    // MARK: - Page layout methods
    func applyDefaults(){
        
        if isiPhone5orLower{
            
            if isiPhone4s{
                self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 70, 40, 150, 150))
                self.btnLogin = UIButton(frame: CGRectMake(20, 390 , 80, 80))
                self.btnSettings = UIButton(frame: CGRectMake(220, 390 , 80, 80))
            }else{
                self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 70, 40, 150, 150))
                self.btnLogin = UIButton(frame: CGRectMake(20, 420 + 20, 80, 80))
                self.btnSettings = UIButton(frame: CGRectMake(220, 420 + 20, 80, 80))
            }
            
        }else if isiPhone6{
            
            self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 90, 40, 180, 180))
            self.btnLogin = UIButton(frame: CGRectMake(20, 520, 100, 100))
            self.btnSettings = UIButton(frame: CGRectMake(260, 520, 100, 100))
            
        }else if isiPhone6plus{
            
            self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 90, 40, 200, 200))
            self.btnLogin = UIButton(frame: CGRectMake(20, 580, 100, 100))
            self.btnSettings = UIButton(frame: CGRectMake(280, 580, 100, 100))
            
        }else if isiPadAir2 {
            
            self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 110, 40, 200, 200))
            self.btnLogin = UIButton(frame: CGRectMake(20+170, 580, 100, 100))
            self.btnSettings = UIButton(frame: CGRectMake(280+170, 580, 100, 100))
        }else{
            self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 110, 40, 200, 200))
            self.btnLogin = UIButton(frame: CGRectMake(20+170, 580, 100, 100))
            self.btnSettings = UIButton(frame: CGRectMake(280+170, 580, 100, 100))
        }
        
        self.logoImageView.image = UIImage (named: "HomePageLogo.png")
        self.view.addSubview(self.logoImageView)
        
        collectionView = UICollectionView(frame: CGRectMake(self.view.frame.origin.x + 20, self.logoImageView.frame.size.height + 80, self.view.frame.size.width - 40, 250), collectionViewLayout: flowLayout)
        collectionView?.registerClass(CollectionCell.self, forCellWithReuseIdentifier: "categoryCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.clearColor()
        self.view.addSubview(collectionView!)
        
        let imgLogin = UIImage(named:  "icon_login.png") as UIImage?
        self.btnLogin.setImage(imgLogin, forState: .Normal)
        self.btnLogin.addTarget(self, action: "btnLink1ButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnLogin)
        
        let imgSetings = UIImage(named:  "icon_settings.png") as UIImage?
        self.btnSettings.setImage(imgSetings, forState: .Normal)
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
        return 6 //self.arrCategories.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width / 3.5, height: self.collectionView.frame.size.width / 3.5);
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCell", forIndexPath: indexPath) as! CollectionCell
        cell.configureCellAtIndexPath(cell.frame, indexPath: indexPath, strCurrLang: self.selectedLanguage as String)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
         
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        
        switch indexPath.row
        {
        case 0 :
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailView") as! DetailViewController
            destinationViewController.arrTempEnImages = self.arrEnTreasureHunt
            destinationViewController.arrTempHeImages = self.arrHeTreasureHunt
            destinationViewController.strNavigationTittle = NSLocalizedString("TREASURE_HUNT",comment:"Treasure Hunt")
            destinationViewController.categoryId = 1
            self.navigationController?.pushViewController(destinationViewController, animated: true)
            
        case 1 :
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailView") as! DetailViewController
            destinationViewController.arrTempEnImages = self.arrEnNightStar
            destinationViewController.arrTempHeImages = self.arrHeNightStar
            destinationViewController.strNavigationTittle = NSLocalizedString("NIGHT_STAR",comment:"Night Star")
            destinationViewController.categoryId = 2
            self.navigationController?.pushViewController(destinationViewController, animated: true)
            
        case 2 :
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailView") as! DetailViewController
            destinationViewController.arrTempEnImages = self.arrEnMissionPossible
            destinationViewController.arrTempHeImages = self.arrHeMissionPossible
            destinationViewController.strNavigationTittle = NSLocalizedString("MISSIONN_POSSIBLE",comment:"Missionn Possible")
            destinationViewController.categoryId = 3
            self.navigationController?.pushViewController(destinationViewController, animated: true)
            
        case 3 :
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailView") as! DetailViewController
            destinationViewController.arrTempEnImages = self.arrEnCopsAndRobbers
            destinationViewController.arrTempHeImages = self.arrHeCopsAndRobbers
            destinationViewController.strNavigationTittle = NSLocalizedString("COPS_AND_ROBBERS",comment:"Cops And Robbers")
            destinationViewController.categoryId = 4
            self.navigationController?.pushViewController(destinationViewController, animated: true)
            
        case 4 :
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailView") as! DetailViewController
            destinationViewController.arrTempEnImages = self.arrEnYourRace
            destinationViewController.arrTempHeImages = self.arrHeYourRace
            destinationViewController.strNavigationTittle = NSLocalizedString("YOUR_RACE",comment:"Your Race")
            destinationViewController.categoryId = 5
            self.navigationController?.pushViewController(destinationViewController, animated: true)
            
        case 5 :
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailView") as! DetailViewController
            destinationViewController.arrTempEnImages = self.arrEnTimeLessRopes
            destinationViewController.arrTempHeImages = self.arrHeTimeLessRopes
            destinationViewController.strNavigationTittle = NSLocalizedString("TIMELESS_ROPES",comment:"TimeLess Ropes")
            destinationViewController.categoryId = 6
            self.navigationController?.pushViewController(destinationViewController, animated: true)
            
        default:
            print("Other link Button tapped")
        }
        
    }
    
    
    // MARK: - Some common methods
    func loadMediaDataFromServer(){
        
        let objSyncApp : SynchronizeApp = SynchronizeApp()
        objSyncApp.startSyncMethodCall(self, success: { (responseObject: AnyObject?) in
                self.getAllCategoriesDataFromLocalDB()
            }, failure: { (responseObject: AnyObject?) in
                
        })
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
        let categoryFilter : NSPredicate = NSPredicate(format: "category_language = %d AND is_deleted = 0",strLanguage)
        arrCategories = Categories.MR_findAllSortedBy("cat_sequence_no", ascending: true, withPredicate: categoryFilter)
        
    }
    
}
