//
//  ShowMediaViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 30/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import MediaPlayer

class ShowMediaViewController: BaseViewController, UIScrollViewDelegate, BottomTabBarDelegate,UITableViewDelegate, UITableViewDataSource{
    
    var tblView : UITableView!
    var bottomTabBar : BottomTabBarView!
    
    let arrShowData : NSMutableArray = NSMutableArray()
    var socialShareDict : NSDictionary = NSDictionary()
    
    var categoryId : NSInteger!
    var subCategoryId : NSInteger!
    
    var singleTapGesture : UITapGestureRecognizer!
    var leftSwipeGesture : UISwipeGestureRecognizer!
    var selectedIndexPath : NSIndexPath = NSIndexPath( forRow: 0, inSection: 0)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = NSLocalizedString("ALL_MEDIA",comment: "All Media")
        self.navigationController?.navigationBarHidden = false
        self.view.backgroundColor = UIColor().appBackgroundColor()
        self.addRightAndLeftNavItemOnView()
        self.refreshData()
        self.applyDefaults()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
    // MARK: -  Nanigation bar button and there methods
    
    func addRightAndLeftNavItemOnView()
    {
        let buttonBack: UIButton = UIButton(type: UIButtonType.Custom)
        buttonBack.frame = CGRectMake(0, 0, 40, 40)
        buttonBack.setImage(UIImage(named:"icon_back.png"), forState: UIControlState.Normal)
        buttonBack.addTarget(self, action: "leftNavBackButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        let leftBarButtonItemback: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItemback, animated: false)
        
        if self.is_Admin[0] {
            let buttonShare: UIButton = UIButton(type: UIButtonType.Custom)
            buttonShare.frame = CGRectMake(0, 0, 35, 35)
            buttonShare.setImage(UIImage(named:"icon_admin.png"), forState: UIControlState.Normal)
            buttonShare.addTarget(self, action: "rightNavShareButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
            let rightBarButtonItemShare: UIBarButtonItem = UIBarButtonItem(customView: buttonShare)
            self.navigationItem.setRightBarButtonItem(rightBarButtonItemShare, animated: false)
        }
    }
    
    func leftNavBackButtonTapped(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func rightNavShareButtonTapped(){
        let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AdminPanel") as! AdminPanelViewController
        destinationViewController.categoryId = categoryId
        destinationViewController.subCategoryId = subCategoryId
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    
    
    // MARK: -  Fetching Data from core Data stack methods
    
    func refreshData(){
        
        let categoryFilter : NSPredicate = NSPredicate(format: "category_id = %d AND sub_category_id = %d AND is_deleted = 0",categoryId,subCategoryId)
        let arrFetchedData : NSArray = MediaObject.MR_findAllWithPredicate(categoryFilter)
        
        if self.selectedLanguage == hebrew {
            
            for (index, element) in arrFetchedData.enumerate() {
                
                let objeMedia : MediaObject = element as! MediaObject
                
                if objeMedia.object_name_hebrew != "" && objeMedia.object_server_url_hebrew != "" {
                    let localDict : NSDictionary = ["fileName": objeMedia.object_name_hebrew, "url": objeMedia.object_server_url_hebrew, "type" :objeMedia.object_type]
                    arrShowData.addObject(localDict)
                }
            }
            
        }else{
            for (index, element) in arrFetchedData.enumerate() {
                
                let objeMedia : MediaObject = element as! MediaObject
                
                if objeMedia.object_name_english != "" && objeMedia.object_server_url_english != nil {
                    let localDict : NSDictionary = ["fileName": objeMedia.object_name_english, "url": objeMedia.object_server_url_english, "type" :objeMedia.object_type]
                    arrShowData.addObject(localDict)
                }
            }
        }
        print(arrShowData)
    }
    
    
    func applyDefaults(){
      
      if arrShowData.count == 0 {
        
        let lblAlert:UILabel = UILabel(frame: CGRectMake((self.view.frame.width-250)/2,(self.view.frame.height-40)/2,250,40))
        lblAlert.textAlignment = NSTextAlignment.Center
        lblAlert.font = UIFont.systemFontOfSize(20.0)
        lblAlert.textColor = UIColor.darkGrayColor()
        self.view.addSubview(lblAlert)
        self.view.bringSubviewToFront(lblAlert)
        
        if self.selectedLanguage == hebrew {
          lblAlert.text = NSLocalizedString("There_is_no_data_for_Hebrew",comment: "There is no data")
        }else{
          lblAlert.text = NSLocalizedString("There_is_no_data_for_english",comment: "There is no data")
        }
        
      }
      
        
        self.tblView = UITableView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, self.view.frame.size.width, self.view.frame.size.height-114))
         tblView.tableFooterView = UIView(frame:CGRectZero)
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.registerClass(ShowMediaCell.self,forCellReuseIdentifier:"Cell")
        self.tblView.backgroundColor = UIColor.clearColor()
        self.tblView.separatorColor = UIColor.whiteColor()
        self.view.addSubview(self.tblView)

        /* Method to Add Custom UIActivityIndicatorView in current screen */
        activityIndicator = ActivityIndicatorView(frame: self.view.frame)
        activityIndicator.startActivityIndicator(self)
        
        downlaodAllMediaDataInDocumentDirectory(arrShowData ,success: { (responseObject: AnyObject?) in
            self.tblView.reloadData()
            self.activityIndicator.stopActivityIndicator(self)
            },failure: { (responseObject: AnyObject?) in
                self.activityIndicator.stopActivityIndicator(self)
        })
        
        
        bottomTabBar = BottomTabBarView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.size.height - 50, self.view.frame.size.width ,50))
        bottomTabBar.bottomBarDelegate = self
        bottomTabBar.addBottomViewWithShareOptions()
        self.view.addSubview(bottomTabBar)
    }
    
    
    // MARK: -  Custom Methods to Download Data methods
    
    func downlaodAllMediaDataInDocumentDirectory(list:NSMutableArray, success:((responseObject: AnyObject? ) -> Void)?, failure:((error: NSError? ) -> Void)? ){
        
        for (index, element) in list.enumerate() {
            
            if !self.api.isMediaFileExistInDocumentDirectory(list.objectAtIndex(index)as! [NSObject : AnyObject]){
              
                self.api.downloadMediaData(list.objectAtIndex(index) as! [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
                    
                    if index == list.count - 1 {
                        if let success = success {
                            success(responseObject: responseObject)
                        }
                    }
                    },
                    failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
                        print(error)
                })
            }
            else{
                if index == list.count - 1 {
                    if let success = success {
                        success(responseObject: nil)
                    }
                }
            }
        }
        
        if list.count == 0{
            if let failure = failure{
                failure(error: nil)
            }
        }
    }
    
    
    
    // MARK: - TableView Delegate and Data Source Method
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrShowData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 190.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : ShowMediaCell!
        if cell == nil {
            cell  = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ShowMediaCell
            cell.lblDesc.text = ""
        }
        
        leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: "swipeGestureHandler:")
        leftSwipeGesture.direction = .Left
        cell.addGestureRecognizer(leftSwipeGesture)

        singleTapGesture = UITapGestureRecognizer(target: self, action: "singleTapHandler:")
        singleTapGesture.numberOfTapsRequired = 1
        cell.addGestureRecognizer(singleTapGesture)
        
        cell.tag = indexPath.row
        cell.configureShowMediaTableViewCell(cell, dictTemp: arrShowData.objectAtIndex(indexPath.row) as! NSDictionary)
        return cell
    }
    
    
    // MARK: - Cell Tap Gesture and Swipe Gesture methods
    
    func swipeGestureHandler(sender: UISwipeGestureRecognizer) {
        
        let cell : ShowMediaCell = sender.view as! ShowMediaCell
        let tapIndex : Int = cell.tag
        
        let tappedObjectDict : NSDictionary = arrShowData.objectAtIndex(tapIndex) as! NSDictionary
        socialShareDict = tappedObjectDict
        let mediaType : Int = tappedObjectDict.objectForKey("type") as! Int
        
        switch mediaType {
            
        case 1 :
            if self.api.isMediaFileExistInDocumentDirectory(arrShowData.objectAtIndex(tapIndex) as! [NSObject : AnyObject]){
                let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MediaPreview") as! MediaPreviewViewController
                destinationViewController.selectedImage = self.api.getImageFromDocumentDirectoryFileURL(tappedObjectDict as [NSObject : AnyObject])
                destinationViewController.selectedVideoUrl = nil
                destinationViewController.isMediaTypeImage = 1
                destinationViewController.socialShareDict = tappedObjectDict
                self.navigationController?.pushViewController(destinationViewController, animated: true)
            }else{
                let alert:UIAlertView! = UIAlertView(title:nil, message:"File not downloaded yet. ", delegate:nil, cancelButtonTitle:"OK")
                alert.show()
            }
            
        case 2 :
            if self.api.isMediaFileExistInDocumentDirectory(arrShowData.objectAtIndex(tapIndex) as! [NSObject : AnyObject]){
                let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MediaPreview") as! MediaPreviewViewController
                destinationViewController.selectedImage = nil
                destinationViewController.selectedVideoUrl = self.api.getDocumentDirectoryFileURL(tappedObjectDict as [NSObject : AnyObject])
                destinationViewController.isMediaTypeImage = 2
                destinationViewController.socialShareDict = tappedObjectDict
                self.navigationController?.pushViewController(destinationViewController, animated: true)
            }else{
                let alert:UIAlertView! = UIAlertView(title:nil, message:"File not downloaded yet. ", delegate:nil, cancelButtonTitle:"OK")
                alert.show()
            }
            
        case 3 :
            if self.api.isMediaFileExistInDocumentDirectory(arrShowData.objectAtIndex(tapIndex) as! [NSObject : AnyObject]){
                let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MediaPreview") as! MediaPreviewViewController
                destinationViewController.selectedImage = nil
                destinationViewController.selectedVideoUrl = self.api.getDocumentDirectoryFileURL(tappedObjectDict as [NSObject : AnyObject])
                destinationViewController.isMediaTypeImage = 3
                destinationViewController.socialShareDict = tappedObjectDict
                self.navigationController?.pushViewController(destinationViewController, animated: true)
            }else{
                let alert:UIAlertView! = UIAlertView(title:nil, message:"File not downloaded yet. ", delegate:nil, cancelButtonTitle:"OK")
                alert.show()
            }
            
        default :
            print("Default button Tapped")
        }
        
    }
    
    func singleTapHandler(sender: UITapGestureRecognizer) {
        
        let preSelectedCell : ShowMediaCell = self.tblView.cellForRowAtIndexPath(selectedIndexPath) as! ShowMediaCell
        preSelectedCell.setSelected(false, animated: true)
        
        let selectedCell : ShowMediaCell = sender.view as! ShowMediaCell
        selectedIndexPath = NSIndexPath(forRow: selectedCell.tag, inSection: selectedIndexPath.section)
        
        let tappedObjectDict : NSDictionary = arrShowData.objectAtIndex(selectedCell.tag) as! NSDictionary
        socialShareDict = tappedObjectDict
        selectedCell.setSelected(true, animated: true)
    }
    
    
    // MARK: - BottomTabBarDelegate Delegate Method
    
    func sendTappedButtonTag(sender: AnyObject){
        
        if self.auth_token[0] != "" {
            
            let btnSender = sender as! UIButton
            
            switch btnSender.tag {
                
            case 0 :
                if self.socialShareDict.count != 0 {
                    self.bottomTabBar.btnWhatsAppTapped(self.socialShareDict)
                    self.showSuccessAlertToUser("Successfully shared on Whats app", strMessage: "" )
                }else{
                    self.showSuccessAlertToUser("You didn't selected any media", strMessage: "Please choose any file to share." )
                }
                
            case 1 : //self.bottomTabBar.btnViberTapped(sender as! NSDictionary)
            if self.socialShareDict.count != 0 {
                self.bottomTabBar.btnViberTapped(self.socialShareDict)
                self.showSuccessAlertToUser("Successfully shared on Facebook app", strMessage: "" )
            }else{
                self.showSuccessAlertToUser("You didn't selected any media", strMessage: "Please choose any file to share." )
                }
                
            case 2 :
                if self.socialShareDict.count != 0 {
                    self.bottomTabBar.btnDropBoxTapped(self.socialShareDict , viewController: self)
                    self.showSuccessAlertToUser("Successfully shared on Dropbox", strMessage: "" )
                }else{
                    self.showSuccessAlertToUser("You didn't selected any media", strMessage: "Please choose any file to share." )
                }
                
            case 3 : bottomTabBar.btnWazeTapped(sender)
                
            default: print("Other Button Tapped")
                
            }
        }else {
            let alert:UIAlertView! = UIAlertView(title:"Login!", message:"Please login to share media.", delegate:nil, cancelButtonTitle:"OK")
            alert.show()
        }
    }
    
    
    
     // MARK: - Current page common methods
    
    func showSuccessAlertToUser(strTittle : NSString ,strMessage : NSString){
        
        let alertController = UIAlertController(title: strTittle as String, message:
            strMessage as String, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alertController, animated: true, completion: {
            
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                alertController.dismissViewControllerAnimated(true, completion: nil)
            })
        })
    }
    
    
    

}
