//
//  SelectAppLanguageViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 12/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit
import Foundation

class SelectAppLanguageViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tblView : UITableView!
    var items: [String] = ["English","עברית"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor().appBackgroundColor()
        self.title = NSLocalizedString("CHOOSE_LANGUAGE",comment:"Choose Language")
        self.addRightAndLeftNavItemOnView()
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
        self.tblView = UITableView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.width, 185))
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
        return items.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell! = self.tblView.dequeueReusableCellWithIdentifier("cell")
        cell.textLabel!.text = items[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch (indexPath.row){
        
        case 0 :
            NSUserDefaults.standardUserDefaults().setObject(["en"], forKey:"AppleLanguages")
            NSUserDefaults.standardUserDefaults().synchronize()
            appTerminatePopUp()
            
        case 1 :
            NSUserDefaults.standardUserDefaults().setObject(["he"], forKey:"AppleLanguages")
            NSUserDefaults.standardUserDefaults().synchronize()
            appTerminatePopUp()

        default:
            print("Other link Button tapped")
            
            self.tblView.deselectRowAtIndexPath(indexPath, animated: true)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func appTerminatePopUp(){
        
        let alert = UIAlertController(title: "Alert!",
            message:"App needs to be exit within 5 seconds",
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK",comment:"Ok"), style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: {
        
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                exit(0)
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
