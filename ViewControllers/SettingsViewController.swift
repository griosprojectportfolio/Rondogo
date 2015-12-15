//
//  SettingsViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 10/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit
import Foundation

class SettingsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tblView : UITableView!
    var Items: [String] = [NSLocalizedString("APPLICATION_LANGUAGES",comment: "Application Languages") ,
                                NSLocalizedString("SYNC_APP",comment: "Sync App") ,
                                NSLocalizedString("UPDATE_PROFILE",comment: "Update Profile"),
                                NSLocalizedString("SIGN_OUT",comment: "Sign Out")]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.view.backgroundColor = UIColor().appBackgroundColor()
        self.title = NSLocalizedString("SETTINGS",comment:"Settings")
        self.addRightAndLeftNavItemOnView()
        self.applyDefaults()
        tblView.tableFooterView = UIView(frame:CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
      
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
        self.tblView = UITableView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 64, self.view.frame.width,300 + 5))
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tblView.backgroundColor = UIColor.clearColor()
        self.tblView.separatorColor = UIColor.whiteColor()
        self.view.addSubview(self.tblView)
    }
    
    /* TableView Delegate and Data Source Method */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Items.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
         return 60.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
        let cell : UITableViewCell! = self.tblView.dequeueReusableCellWithIdentifier("cell")
          self.tblView.separatorInset = UIEdgeInsetsZero
        cell.textLabel!.text = Items[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
        switch indexPath.row {
        case 2,3:
            if self.auth_token[0] == "" {
              cell.textLabel!.textColor = UIColor.lightGrayColor()
            }
            break
        default:
            break
        }
        return cell
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch (indexPath.row){
            
        case 0 :
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SelectAppLanguage") as! SelectAppLanguageViewController
            self.navigationController?.pushViewController(destinationViewController, animated: true)
            self.tblView.deselectRowAtIndexPath(indexPath, animated: true)
            
        case 1 :
            let objSyncApp : SynchronizeApp = SynchronizeApp()
            objSyncApp.startSyncMethodCall(self, success: { (responseObject: AnyObject?) in
                
                }, failure: { (responseObject: AnyObject?) in
                    
            })
            self.tblView.deselectRowAtIndexPath(indexPath, animated: true)
            
        case 2 :
            if self.auth_token[0] == "" {
                self.showAlertMsg("", message:NSLocalizedString("user_not_login", comment: "Please login first"))
            }else{
            let arrFetchedData : NSArray = User.MR_findAll()
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignUp") as! SignUpViewController
            destinationViewController.arrUserObject = arrFetchedData
            self.navigationController?.pushViewController(destinationViewController, animated: true)
            self.tblView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            
        case 3 :
            if self.auth_token[0] == "" {
                self.showAlertMsg("", message:NSLocalizedString("user_not_login", comment: "Please login first"))
            }else{
            self.tblView.deselectRowAtIndexPath(indexPath, animated: true)

            let parameters : NSDictionary = ["auth_token" : self.auth_token[0]]

            /* Method to Add Custom UIActivityIndicatorView in current screen */
            activityIndicator = ActivityIndicatorView(frame: self.view.frame)
            activityIndicator.startActivityIndicator(self)
            
            self.api.signOutUser(parameters as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
                print(responseObject)
                self.auth_token = [""]
                self.is_Admin = [false]
                self.activityIndicator.stopActivityIndicator(self)
                self.showSuccessAlertToUser("You are successfully loged out")
                },
                failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
                    print(error)
                    self.activityIndicator.stopActivityIndicator(self)
                    self.showSuccessAlertToUser("Log out have some error")
            })
            }
            
        default:
            print("Other link Button tapped")
        }
    }
    
    /* Show pop up on success */
    
    func showSuccessAlertToUser(strMessage : NSString){
        
        let alert = UIAlertController(title: "Alert", message: strMessage as String, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomePage") as! HomePageViewController
                self.navigationController?.pushViewController(destinationViewController, animated: true)
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
    }
    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
