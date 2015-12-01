//
//  HomePageViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 04/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit
import Foundation

class HomePageViewController: BaseViewController {
    
    var logoImageView       : UIImageView!
    var btnTreasureHunt     : UIButton!
    var btnMissionPossible  : UIButton!
    var btnCopsAndRobbers   : UIButton!
    var btnNightStar        : UIButton!
    var btnTimeLessRopes    : UIButton!
    var btnYourRace         : UIButton!
    
    var btnLink1            : UIButton!
    var btnLink2            : UIButton!
    var btnLink3            : UIButton!
    
    
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
                self.btnTreasureHunt = UIButton(frame: CGRectMake(20, 210 , 80, 80))
                self.btnNightStar = UIButton(frame: CGRectMake(120, 210 , 80, 80))
                self.btnMissionPossible = UIButton(frame: CGRectMake(220, 210 , 80, 80))
                self.btnCopsAndRobbers = UIButton(frame: CGRectMake(20, 300 , 80, 80))
                self.btnYourRace = UIButton(frame: CGRectMake(120, 300 , 80, 80))
                self.btnTimeLessRopes = UIButton(frame: CGRectMake(220, 300 , 80, 80))
                self.btnLink1 = UIButton(frame: CGRectMake(20, 390 , 80, 80))
                self.btnLink2 = UIButton(frame: CGRectMake(120, 390 , 80, 80))
                self.btnLink3 = UIButton(frame: CGRectMake(220, 390 , 80, 80))
            }else{
                
                self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 70, 40, 150, 150))
                self.btnTreasureHunt = UIButton(frame: CGRectMake(20, 210 + 10, 80, 80))
                self.btnNightStar = UIButton(frame: CGRectMake(120, 210 + 10, 80, 80))
                self.btnMissionPossible = UIButton(frame: CGRectMake(220, 210 + 10, 80, 80))
                self.btnCopsAndRobbers = UIButton(frame: CGRectMake(20, 320 + 10, 80, 80))
                self.btnYourRace = UIButton(frame: CGRectMake(120, 320 + 10, 80, 80))
                self.btnTimeLessRopes = UIButton(frame: CGRectMake(220, 320 + 10, 80, 80))
                self.btnLink1 = UIButton(frame: CGRectMake(20, 420 + 20, 80, 80))
                self.btnLink2 = UIButton(frame: CGRectMake(120, 420 + 20, 80, 80))
                self.btnLink3 = UIButton(frame: CGRectMake(220, 420 + 20, 80, 80))
            }
            
        }else if isiPhone6{
            
            self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 90, 40, 180, 180))
            self.btnTreasureHunt = UIButton(frame: CGRectMake(20, 260, 100, 100))
            self.btnNightStar = UIButton(frame: CGRectMake(140, 260, 100, 100))
            self.btnMissionPossible = UIButton(frame: CGRectMake(260, 260, 100, 100))
            self.btnCopsAndRobbers = UIButton(frame: CGRectMake(20, 390, 100, 100))
            self.btnYourRace = UIButton(frame: CGRectMake(140, 390, 100, 100))
            self.btnTimeLessRopes = UIButton(frame: CGRectMake(260, 390, 100, 100))
            self.btnLink1 = UIButton(frame: CGRectMake(20, 520, 100, 100))
            self.btnLink2 = UIButton(frame: CGRectMake(140, 520, 100, 100))
            self.btnLink3 = UIButton(frame: CGRectMake(260, 520, 100, 100))
            
        }else if isiPhone6plus{
            
            self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 90, 40, 200, 200))
            self.btnTreasureHunt = UIButton(frame: CGRectMake(20, 280, 110, 110))
            self.btnNightStar = UIButton(frame: CGRectMake(150, 280, 110, 110))
            self.btnMissionPossible = UIButton(frame: CGRectMake(280, 280, 110, 110))
            self.btnCopsAndRobbers = UIButton(frame: CGRectMake(20, 430, 110, 110))
            self.btnYourRace = UIButton(frame: CGRectMake(150, 430, 110, 110))
            self.btnTimeLessRopes = UIButton(frame: CGRectMake(280, 430, 110, 110))
            self.btnLink1 = UIButton(frame: CGRectMake(20, 580, 100, 100))
            self.btnLink2 = UIButton(frame: CGRectMake(150, 580, 100, 100))
            self.btnLink3 = UIButton(frame: CGRectMake(280, 580, 100, 100))
       
        }else if isiPadAir2 {
          
          self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 110, 40, 200, 200))
          self.btnTreasureHunt = UIButton(frame: CGRectMake(20 + 170, 280, 110, 110))
          self.btnNightStar = UIButton(frame: CGRectMake(150 + 170, 280, 110, 110))
          self.btnMissionPossible = UIButton(frame: CGRectMake(280 + 170, 280, 110, 110))
          self.btnCopsAndRobbers = UIButton(frame: CGRectMake(20+170, 430, 110, 110))
          self.btnYourRace = UIButton(frame: CGRectMake(150+170, 430, 110, 110))
          self.btnTimeLessRopes = UIButton(frame: CGRectMake(280+170, 430, 110, 110))
          self.btnLink1 = UIButton(frame: CGRectMake(20+170, 580, 100, 100))
          self.btnLink2 = UIButton(frame: CGRectMake(150+170, 580, 100, 100))
          self.btnLink3 = UIButton(frame: CGRectMake(280+170, 580, 100, 100))
        
        }else{
          
          self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 110, 40, 200, 200))
          self.btnTreasureHunt = UIButton(frame: CGRectMake(20 + 170, 280, 110, 110))
          self.btnNightStar = UIButton(frame: CGRectMake(150 + 170, 280, 110, 110))
          self.btnMissionPossible = UIButton(frame: CGRectMake(280 + 170, 280, 110, 110))
          self.btnCopsAndRobbers = UIButton(frame: CGRectMake(20+170, 430, 110, 110))
          self.btnYourRace = UIButton(frame: CGRectMake(150+170, 430, 110, 110))
          self.btnTimeLessRopes = UIButton(frame: CGRectMake(280+170, 430, 110, 110))
          self.btnLink1 = UIButton(frame: CGRectMake(20+170, 580, 100, 100))
          self.btnLink2 = UIButton(frame: CGRectMake(150+170, 580, 100, 100))
          self.btnLink3 = UIButton(frame: CGRectMake(280+170, 580, 100, 100))
          
        }
        
        
        self.logoImageView.image = UIImage (named: "HomePageLogo.png")
        self.view.addSubview(self.logoImageView)
        
        let imgTreasureHunt = UIImage(named: self.selectedLanguage == hebrew ? "He_TreasureHunt.png" : "En_TreasureHunt.png") as UIImage?
        self.btnTreasureHunt.tag = 0
        self.btnTreasureHunt.setImage(imgTreasureHunt, forState: .Normal)
        self.btnTreasureHunt.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnTreasureHunt)
        
        let imgNightStar = UIImage(named: self.selectedLanguage == hebrew ? "He_NightStar.png" : "En_NightStar.png") as UIImage?
        self.btnNightStar.tag = 1
        self.btnNightStar.setImage(imgNightStar, forState: .Normal)
        self.btnNightStar.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnNightStar)
        
        let imgMissionPossible = UIImage(named: self.selectedLanguage == hebrew ? "He_MissionnPossible.png" : "En_MissionnPossible.png") as UIImage?
        self.btnMissionPossible.tag = 2
        self.btnMissionPossible.setImage(imgMissionPossible, forState: .Normal)
        self.btnMissionPossible.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnMissionPossible)
        
        let imgCopsAndRobbers = UIImage(named: self.selectedLanguage == hebrew ? "He_Cops&Robbers.png" : "En_Cops&Robbers.png") as UIImage?
        self.btnCopsAndRobbers.tag = 3
        self.btnCopsAndRobbers.setImage(imgCopsAndRobbers, forState: .Normal)
        self.btnCopsAndRobbers.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnCopsAndRobbers)
        
        let imgYourRace = UIImage(named: self.selectedLanguage == hebrew ? "He_YourRace.png" : "En_YourRace.png") as UIImage?
        self.btnYourRace.tag = 4
        self.btnYourRace.setImage(imgYourRace, forState: .Normal)
        self.btnYourRace.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnYourRace)
        
        let imgTimeLessRopes = UIImage(named: self.selectedLanguage == hebrew ? "He_TimeLessRopes.png" : "En_TimeLessRopes.png") as UIImage?
        self.btnTimeLessRopes.tag = 5
        self.btnTimeLessRopes.setImage(imgTimeLessRopes, forState: .Normal)
        self.btnTimeLessRopes.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnTimeLessRopes)
        
        let imgLogin = UIImage(named:  "icon_login.png") as UIImage?
        self.btnLink1.setImage(imgLogin, forState: .Normal)
        self.btnLink1.addTarget(self, action: "btnLink1ButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnLink1)
        
        let imgBooking = UIImage(named:  "icon_bookTicket.png") as UIImage?
        self.btnLink2.setImage(imgBooking, forState: .Normal)
        self.btnLink2.hidden = true
        self.btnLink2.addTarget(self, action: "btnLink2ButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnLink2)
        
        let imgSetings = UIImage(named:  "icon_settings.png") as UIImage?
        self.btnLink3.setImage(imgSetings, forState: .Normal)
        self.btnLink3.addTarget(self, action: "btnLink3ButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.btnLink3)
        
    }
    
    func btnTouched(sender: AnyObject){
        
        let btnSender = sender as! UIButton
        
        switch btnSender.tag
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
            
            }, failure: { (responseObject: AnyObject?) in
                
        })
    }
    
    // MARK: - Link Button Tapped methods
    func btnLink1ButtonTapped(){
        if self.auth_token[0] == "" {
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }

    func btnLink2ButtonTapped(){
        let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TicketBooking") as! TicketBookingViewController
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func btnLink3ButtonTapped(){
        if self.auth_token[0] != "" {
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsView") as! SettingsViewController
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        }else {
            let alert:UIAlertView! = UIAlertView(title:"Login!", message:"Please login to change settings. ", delegate:nil, cancelButtonTitle:"OK")
            alert.show()

        }
    }
    
}
