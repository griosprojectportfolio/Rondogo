//
//  ShowMediaViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 30/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import MediaPlayer

class ShowMediaViewController: BaseViewController, UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource{
    
    var tblView : UITableView!
    
    var arrShowData : NSArray = NSArray()
    var socialShareMedia : MediaObject!
    var categoryId : NSInteger!
    var subCategoryId : NSInteger!
    
    var singleTapGesture : UITapGestureRecognizer!
    var doubleTapGesture : UITapGestureRecognizer!
    var leftSwipeGesture : UISwipeGestureRecognizer!
    var selectedIndexPath : NSIndexPath = NSIndexPath( forRow: 0, inSection: 0)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = NSLocalizedString("ALL_MEDIA",comment: "All Media")
        self.navigationController?.navigationBarHidden = false
        self.view.backgroundColor = UIColor().appBackgroundColor()
        self.addLeftNavigationBarButtonItemOnView()
        self.addRightNavigationBarButtonItemOnView()
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
    
    func addRightNavigationBarButtonItemOnView() {
        
        if self.is_Admin[0] {
            
            let btnAdmin: UIButton = UIButton(type: UIButtonType.Custom)
            btnAdmin.frame = CGRectMake(0, 0, 35, 35)
            btnAdmin.setImage(UIImage(named:"icon_admin.png"), forState: UIControlState.Normal)
            btnAdmin.addTarget(self, action: "rightNavAdminButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
            let rightBarAdmin: UIBarButtonItem = UIBarButtonItem(customView: btnAdmin)
            
            let btnCamera: UIButton = UIButton(type: UIButtonType.Custom)
            btnCamera.frame = CGRectMake(0, 0, 35, 35)
            btnCamera.setImage(UIImage(named:"icon_camera.png"), forState: UIControlState.Normal)
            btnCamera.addTarget(self, action: "rightNavCameraButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
            let rightBarCamera: UIBarButtonItem = UIBarButtonItem(customView: btnCamera)
            
            self.navigationItem.setRightBarButtonItems([rightBarAdmin, rightBarCamera], animated: false)
            
        }else {
            
            let btnCamera: UIButton = UIButton(type: UIButtonType.Custom)
            btnCamera.frame = CGRectMake(0, 0, 35, 35)
            btnCamera.setImage(UIImage(named:"icon_camera.png"), forState: UIControlState.Normal)
            btnCamera.addTarget(self, action: "rightNavCameraButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
            let rightBarCamera: UIBarButtonItem = UIBarButtonItem(customView: btnCamera)
            self.navigationItem.setRightBarButtonItem(rightBarCamera, animated: false)
        }
    }
    
    func rightNavAdminButtonTapped(){
        let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AdminPanel") as! AdminPanelViewController
        destinationViewController.categoryId = categoryId
        destinationViewController.subCategoryId = subCategoryId
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    
    
    // MARK: -  Fetching Data from core Data stack methods
    
    func refreshData(){
        let categoryFilter : NSPredicate = NSPredicate(format: "subCategory_id = %d AND is_deleted = 0",subCategoryId)
        self.arrShowData = MediaObject.MR_findAllSortedBy("object_sequence", ascending: true, withPredicate: categoryFilter)
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
        
        self.tblView = UITableView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height))
        tblView.tableFooterView = UIView(frame:CGRectZero)
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.registerClass(ShowMediaCell.self,forCellReuseIdentifier:"Cell")
        self.tblView.backgroundColor = UIColor.clearColor()
        self.tblView.separatorColor = UIColor.whiteColor()
        self.view.addSubview(self.tblView)
        
        downlaodAllMediaDataInDocumentDirectory(self.arrShowData ,success: { (responseObject: AnyObject?) in
                self.tblView.reloadData()
            },failure: { (responseObject: AnyObject?) in
        })
    }
    
    
    // MARK: -  Custom Methods to Download Data methods
    
    func downlaodAllMediaDataInDocumentDirectory(list: NSArray, success:((responseObject: AnyObject? ) -> Void)?, failure:((error: NSError? ) -> Void)? ){
        
        for (index, _) in list.enumerate() {
            
            let objMedia : MediaObject = list[index] as! MediaObject
            
            if !self.api.isMediaFileExistInDocumentDirectory(objMedia){
              
                self.api.downloadMediaData(objMedia, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
                    
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
            cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ShowMediaCell
        }
        
        let objMedia : MediaObject = self.arrShowData[indexPath.row] as! MediaObject

        doubleTapGesture = UITapGestureRecognizer(target: self, action: "doubleTapHandler:")
        doubleTapGesture.numberOfTapsRequired = 2
        cell.addGestureRecognizer(doubleTapGesture)

        singleTapGesture = UITapGestureRecognizer(target: self, action: "singleTapHandler:")
        singleTapGesture.numberOfTapsRequired = 1
        cell.addGestureRecognizer(singleTapGesture)
        
        cell.tag = indexPath.row
        cell.configureShowMediaTableViewCell(cell, objMedia: objMedia)
        return cell
    }
    
    
    // MARK: - Cell Tap Gesture and Swipe Gesture methods
    
    func doubleTapHandler(sender: UITapGestureRecognizer) {
        
        let cell : ShowMediaCell = sender.view as! ShowMediaCell
        let objMedia : MediaObject = self.arrShowData[cell.tag] as! MediaObject
        
        if self.api.isMediaFileExistInDocumentDirectory(objMedia){
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MediaPreview") as! MediaPreviewViewController
            destinationViewController.socialShareDict = objMedia
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        }else{
            self.showAlertMsg("Downloading..", message: "Media downloading is in progress.")
        }
    }
    
    func singleTapHandler(sender: UITapGestureRecognizer) {
        
        if let preSelectedCell : ShowMediaCell = self.tblView.cellForRowAtIndexPath(selectedIndexPath) as? ShowMediaCell {
            preSelectedCell.setSelected(false, animated: true)
        }
        
        let selectedCell : ShowMediaCell = sender.view as! ShowMediaCell
        let tapIndex : Int = selectedCell.tag
        selectedIndexPath = NSIndexPath(forRow: selectedCell.tag, inSection: selectedIndexPath.section)
        
        let objMedia : MediaObject = self.arrShowData[tapIndex] as! MediaObject
        
        if self.api.isMediaFileExistInDocumentDirectory(objMedia){
            self.socialShareMedia = objMedia
            selectedCell.setSelected(true, animated: true)
        }else{
            self.showAlertMsg("Downloading..", message: "Media downloading is in progress.")
        }
    }
    
}
