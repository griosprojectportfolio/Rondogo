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
  
    // MARK: - View related methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.view.backgroundColor = UIColor().appBackgroundColor()
        self.title = NSLocalizedString("SETTINGS",comment:"Settings")
        self.addLeftNavigationBarButtonItemOnView()
        self.applyDefaults()
        tblView.tableFooterView = UIView(frame:CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - View layout setup methods
    
    func applyDefaults(){
        self.tblView = UITableView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y , self.view.frame.width,300 + 5))
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tblView.backgroundColor = UIColor.clearColor()
        self.tblView.separatorColor = UIColor.whiteColor()
        self.view.addSubview(self.tblView)
    }
    
    
    // MARK: - TableView Delegate and Data Source Method
    
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
                    self.stopLoadingIndicatorView()
                }, failure: { (responseObject: AnyObject?) in
                    self.stopLoadingIndicatorView()
            })
            self.startLoadingIndicatorView("Syncing...")
            self.tblView.deselectRowAtIndexPath(indexPath, animated: true)
            
        case 2 :
            if self.auth_token[0] == "" {
                self.showAlertMsg("Login required !", message:"Please login to unlock this feature.")
            }else {
                let arrFetchedData : NSArray = User.MR_findAll()
                let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignUp") as! SignUpViewController
                destinationViewController.arrUserObject = arrFetchedData
                self.navigationController?.pushViewController(destinationViewController, animated: true)
                self.tblView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            
        case 3 :
            if self.auth_token[0] == "" {
                self.showAlertMsg("Login required !", message:"Please login to unlock this feature.")
            }else{
                self.tblView.deselectRowAtIndexPath(indexPath, animated: true)
                self.signOutButtonTapped()
            }
            
        default:
            print("Other link Button tapped")
        }
        
        self.tblView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - Sign out Api call method
    
    func signOutButtonTapped(){
    
        let parameters : NSDictionary = ["auth_token" : self.auth_token[0]]
        self.startLoadingIndicatorView("Logout...")
        
        self.api.signOutUser(parameters as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
            print(responseObject)
            self.auth_token = [""]
            self.is_Admin = [false]
            self.stopLoadingIndicatorView()
            self.showSuccessAlertToUser("You are successfully logged out.")
            },
            failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
                print(error)
                self.stopLoadingIndicatorView()
                self.showAlertMsg("Logout !", message: "Logout have some error, please try again later.")
        })
        
    }
    
    
    // MARK: - Common methods
    
    func showSuccessAlertToUser(strMessage : NSString){
        
        let alert = UIAlertController(title: "Rondogo", message: strMessage as String, preferredStyle: UIAlertControllerStyle.Alert)
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
    

}
