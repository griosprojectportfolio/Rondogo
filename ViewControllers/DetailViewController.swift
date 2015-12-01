//
//  DetailViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 17/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

//
//  TreasureHuntViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 04/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: BaseViewController  {
    
    var treasureHuntImageView : UIImageView!
    var firstBtn    : UIButton!
    var secondBtn   : UIButton!
    var thirdBtn    : UIButton!
    var fourthBtn   : UIButton!
    var fifthBtn    : UIButton!
    var sixthBtn    : UIButton!
    
    var btnLink1    : UIButton!
    var btnLink2    : UIButton!
    var btnLink3    : UIButton!
    
    var arrTempEnImages : NSArray!
    var arrTempHeImages : NSArray!
    var strNavigationTittle : String!
    
    var categoryId : NSInteger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = strNavigationTittle
        self.navigationController?.navigationBarHidden = false
        self.addRightAndLeftNavItemOnView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
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
        
        if isiPhone5orLower{

            if isiPhone4s{
                self.treasureHuntImageView = UIImageView(frame: CGRectMake(self.view.center.x - 60, 70, 120, 120))
                self.firstBtn = UIButton(frame: CGRectMake(20, 210, 80, 80))
                self.secondBtn = UIButton(frame: CGRectMake(120, 210, 80, 80))
                self.thirdBtn = UIButton(frame: CGRectMake(220, 210, 80, 80))
                self.fourthBtn = UIButton(frame: CGRectMake(20, 300, 80, 80))
                self.fifthBtn = UIButton(frame: CGRectMake(120, 300, 80, 80))
                self.sixthBtn = UIButton(frame: CGRectMake(220, 300, 80, 80))
                self.btnLink1 = UIButton(frame: CGRectMake(20, 390, 80, 80))
                self.btnLink2 = UIButton(frame: CGRectMake(120, 390, 80, 80))
                self.btnLink3 = UIButton(frame: CGRectMake(220, 390, 80, 80))
            }else{
                
                self.treasureHuntImageView = UIImageView(frame: CGRectMake(self.view.center.x - 70, 70, 150, 150))
                self.firstBtn = UIButton(frame: CGRectMake(20, 220 + 30, 80, 80))
                self.secondBtn = UIButton(frame: CGRectMake(120, 220 + 30, 80, 80))
                self.thirdBtn = UIButton(frame: CGRectMake(220, 220 + 30, 80, 80))
                self.fourthBtn = UIButton(frame: CGRectMake(20, 320 + 30, 80, 80))
                self.fifthBtn = UIButton(frame: CGRectMake(120, 320 + 30, 80, 80))
                self.sixthBtn = UIButton(frame: CGRectMake(220, 320 + 30, 80, 80))
                self.btnLink1 = UIButton(frame: CGRectMake(20, 420 + 30, 80, 80))
                self.btnLink2 = UIButton(frame: CGRectMake(120, 420 + 30, 80, 80))
                self.btnLink3 = UIButton(frame: CGRectMake(220, 420 + 30, 80, 80))
            }
            
        }else if isiPhone6{
            
            self.treasureHuntImageView = UIImageView(frame: CGRectMake(self.view.center.x - 90, 70, 180, 180))
            self.firstBtn = UIButton(frame: CGRectMake(20, 240 + 50, 100, 100))
            self.secondBtn = UIButton(frame: CGRectMake(140, 240 + 50, 100, 100))
            self.thirdBtn = UIButton(frame: CGRectMake(260, 240 + 50, 100, 100))
            self.fourthBtn = UIButton(frame: CGRectMake(20, 380 + 40, 100, 100))
            self.fifthBtn = UIButton(frame: CGRectMake(140, 380 + 40, 100, 100))
            self.sixthBtn = UIButton(frame: CGRectMake(260, 380 + 40, 100, 100))
            self.btnLink1 = UIButton(frame: CGRectMake(20, 520 + 30, 100, 100))
            self.btnLink2 = UIButton(frame: CGRectMake(140, 520 + 30, 100, 100))
            self.btnLink3 = UIButton(frame: CGRectMake(260, 520 + 30, 100, 100))
            
        }else if isiPhone6plus{
            
            self.treasureHuntImageView = UIImageView(frame: CGRectMake(self.view.center.x - 90, 70, 200, 200))
            self.firstBtn = UIButton(frame: CGRectMake(20, 280 + 30, 110, 110))
            self.secondBtn = UIButton(frame: CGRectMake(150, 280 + 30, 110, 110))
            self.thirdBtn = UIButton(frame: CGRectMake(280, 280 + 30, 110, 110))
            self.fourthBtn = UIButton(frame: CGRectMake(20, 430 + 30, 110, 110))
            self.fifthBtn = UIButton(frame: CGRectMake(150, 430 + 30, 110, 110))
            self.sixthBtn = UIButton(frame: CGRectMake(280, 430 + 30, 110, 110))
            self.btnLink1 = UIButton(frame: CGRectMake(20, 580 + 30, 100, 100))
            self.btnLink2 = UIButton(frame: CGRectMake(150, 580 + 30, 100, 100))
            self.btnLink3 = UIButton(frame: CGRectMake(280, 580 + 30, 100, 100))
       
        }else if isiPadAir2 {
        self.treasureHuntImageView = UIImageView(frame: CGRectMake(self.view.center.x - 110,64, 200, 200))
        self.firstBtn = UIButton(frame: CGRectMake(20 + 170, 280, 110, 110))
        self.secondBtn = UIButton(frame: CGRectMake(150 + 170, 280, 110, 110))
        self.thirdBtn = UIButton(frame: CGRectMake(280 + 170, 280, 110, 110))
        self.fourthBtn = UIButton(frame: CGRectMake(20+170, 430, 110, 110))
        self.fifthBtn = UIButton(frame: CGRectMake(150+170, 430, 110, 110))
        self.sixthBtn = UIButton(frame: CGRectMake(280+170, 430, 110, 110))
        self.btnLink1 = UIButton(frame: CGRectMake(20+170, 580, 100, 100))
        self.btnLink2 = UIButton(frame: CGRectMake(150+170, 580, 100, 100))
        self.btnLink3 = UIButton(frame: CGRectMake(280+170, 580, 100, 100))
        
      }else{
        self.treasureHuntImageView = UIImageView(frame: CGRectMake(self.view.center.x - 110, 64, 200, 200))
        self.firstBtn = UIButton(frame: CGRectMake(20 + 170, 280, 110, 110))
        self.secondBtn = UIButton(frame: CGRectMake(150 + 170, 280, 110, 110))
        self.thirdBtn = UIButton(frame: CGRectMake(280 + 170, 280, 110, 110))
        self.fourthBtn = UIButton(frame: CGRectMake(20+170, 430, 110, 110))
        self.fifthBtn = UIButton(frame: CGRectMake(150+170, 430, 110, 110))
        self.sixthBtn = UIButton(frame: CGRectMake(280+170, 430, 110, 110))
        self.btnLink1 = UIButton(frame: CGRectMake(20+170, 580, 100, 100))
        self.btnLink2 = UIButton(frame: CGRectMake(150+170, 580, 100, 100))
        self.btnLink3 = UIButton(frame: CGRectMake(280+170, 580, 100, 100))
        
      }

      
      
        self.treasureHuntImageView.image = UIImage(named: (self.selectedLanguage == hebrew ? arrTempHeImages.objectAtIndex(0) as! NSString : arrTempEnImages.objectAtIndex(0) as! NSString) as String)
        self.view.addSubview(self.treasureHuntImageView)
        
        if arrTempEnImages.count > 1 &&  arrTempHeImages.count > 1 {
            
            let imgTreasureHunt = UIImage(named: (self.selectedLanguage == hebrew ? arrTempHeImages.objectAtIndex(1) as! NSString : arrTempEnImages.objectAtIndex(1) as! NSString) as String) as UIImage?
            self.firstBtn.setImage(imgTreasureHunt, forState: .Normal)
            self.firstBtn.tag = 0
            self.firstBtn.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
            self.view.addSubview(self.firstBtn)
            
            let imgNightStar = UIImage(named: (self.selectedLanguage == hebrew ? arrTempHeImages.objectAtIndex(2) as! NSString : arrTempEnImages.objectAtIndex(2) as! NSString) as String) as UIImage?
            self.secondBtn.setImage(imgNightStar, forState: .Normal)
            self.secondBtn.tag = 1
            self.secondBtn.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
            self.view.addSubview(self.secondBtn)
            
            let imgMissionPossible = UIImage(named: (self.selectedLanguage == hebrew ? arrTempHeImages.objectAtIndex(3) as! NSString : arrTempEnImages.objectAtIndex(3) as! NSString) as String) as UIImage?
            self.thirdBtn.setImage(imgMissionPossible, forState: .Normal)
            self.thirdBtn.tag = 2
            self.thirdBtn.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
            self.view.addSubview(self.thirdBtn)
            
            let imgCopsAndRobbers = UIImage(named: (self.selectedLanguage == hebrew ? arrTempHeImages.objectAtIndex(4) as! NSString : arrTempEnImages.objectAtIndex(4) as! NSString) as String) as UIImage?
            self.fourthBtn.setImage(imgCopsAndRobbers, forState: .Normal)
            self.fourthBtn.tag = 3
            self.fourthBtn.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
            self.view.addSubview(self.fourthBtn)
            
            let imgYourRace = UIImage(named: (self.selectedLanguage == hebrew ? arrTempHeImages.objectAtIndex(5) as! NSString : arrTempEnImages.objectAtIndex(5) as! NSString) as String) as UIImage?
            self.fifthBtn.setImage(imgYourRace, forState: .Normal)
            self.fifthBtn.tag = 4
            self.fifthBtn.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
            self.view.addSubview(self.fifthBtn)
            
            let imgTimeLessRopes = UIImage(named: (self.selectedLanguage == hebrew ? (arrTempHeImages.objectAtIndex(6) as! NSString) as NSString : (arrTempEnImages.objectAtIndex(6) as! NSString) as NSString) as String) as UIImage?
            self.sixthBtn.setImage(imgTimeLessRopes, forState: .Normal)
            self.sixthBtn.tag = 5
            self.sixthBtn.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
            self.view.addSubview(self.sixthBtn)
            
            let imgbtnLink1 = UIImage(named: (self.selectedLanguage as String == hebrew ? (arrTempHeImages.objectAtIndex(7) as! NSString) as NSString : (arrTempEnImages.objectAtIndex(7) as! NSString) as NSString) as String) as UIImage?
            self.btnLink1.setImage(imgbtnLink1, forState: .Normal)
            self.btnLink1.tag = 6
            self.btnLink1.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
            self.view.addSubview(self.btnLink1)
            
            let imgbtnLink2 = UIImage(named: (self.selectedLanguage == hebrew ? (arrTempHeImages.objectAtIndex(8) as! NSString) as NSString : (arrTempEnImages.objectAtIndex(8) as! NSString) as NSString) as String) as UIImage?
            self.btnLink2.setImage(imgbtnLink2, forState: .Normal)
            self.btnLink2.tag = 7
            self.btnLink2.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
            self.view.addSubview(self.btnLink2)
            
            let imgbtnLink3 = UIImage(named: (self.selectedLanguage == hebrew ? arrTempHeImages.objectAtIndex(9) as! NSString : arrTempEnImages.objectAtIndex(9) as! NSString) as String) as UIImage?
            self.btnLink3.setImage(imgbtnLink3, forState: .Normal)
            self.btnLink3.tag = 8
            self.btnLink3.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
            self.view.addSubview(self.btnLink3)

        }
    }
    
    func btnTouched(sender: AnyObject){
        
        let btnSender = sender as! UIButton
        
        switch btnSender.tag
        {
        case 0 :
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShowMedia") as! ShowMediaViewController
            destinationViewController.categoryId = categoryId
            destinationViewController.subCategoryId = 1
            self.navigationController?.pushViewController(destinationViewController, animated: true)
            
        case 1 :
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShowMedia") as! ShowMediaViewController
            destinationViewController.categoryId = categoryId
            destinationViewController.subCategoryId = 2
            self.navigationController?.pushViewController(destinationViewController, animated: true)

        case 2 :
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShowMedia") as! ShowMediaViewController
            destinationViewController.categoryId = categoryId
            destinationViewController.subCategoryId = 3
            self.navigationController?.pushViewController(destinationViewController, animated: true)

        case 3 :
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShowMedia") as! ShowMediaViewController
            destinationViewController.categoryId = categoryId
            destinationViewController.subCategoryId = 4
            self.navigationController?.pushViewController(destinationViewController, animated: true)
            
        case 4 :
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShowMedia") as! ShowMediaViewController
            destinationViewController.categoryId = categoryId
            destinationViewController.subCategoryId = 5
            self.navigationController?.pushViewController(destinationViewController, animated: true)
            
        case 5 :
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShowMedia") as! ShowMediaViewController
            destinationViewController.categoryId = categoryId
            destinationViewController.subCategoryId = 6
            self.navigationController?.pushViewController(destinationViewController, animated: true)
            
        case 6 :
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShowMedia") as! ShowMediaViewController
            destinationViewController.categoryId = categoryId
            destinationViewController.subCategoryId = 7
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        
        case 7 :
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShowMedia") as! ShowMediaViewController
            destinationViewController.categoryId = categoryId
            destinationViewController.subCategoryId = 8
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        
        case 8 :
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShowMedia") as! ShowMediaViewController
            destinationViewController.categoryId = categoryId
            destinationViewController.subCategoryId = 9
            self.navigationController?.pushViewController(destinationViewController, animated: true)

        default:
            print("Other link Button tapped")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}