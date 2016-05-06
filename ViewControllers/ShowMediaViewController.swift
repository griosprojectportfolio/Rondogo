//
//  ShowMediaViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 30/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import MediaPlayer

class ShowMediaViewController: BaseViewController, showMediaCellDelegate, UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var tblView : UITableView!
    
    var arrShowData : NSArray = NSArray()
    var socialShareMedia : MediaObject!
    var categoryId : NSInteger!
    var subCategoryId : NSInteger!
    
    
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
    
    func rightNavCameraButtonTapped(){
        
        let optionMenu = UIAlertController(title: nil, message:NSLocalizedString("ALERT",comment:"Alert"), preferredStyle: .ActionSheet)
        
        let imageAction = UIAlertAction(title:NSLocalizedString("CAPTURE_IMAGE",comment:"Capture Image"), style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            self.openCameraToCaptureImage()
        })
        let videoAction = UIAlertAction(title: NSLocalizedString("CAPTURE_VIDEO",comment:"Capture Video"), style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            self.openCameraToCaptureVideo()
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL",comment:"Cancel"), style: .Cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        optionMenu.addAction(imageAction)
        optionMenu.addAction(videoAction)
        optionMenu.addAction(cancelAction)
        
        if let popoverController = optionMenu.popoverPresentationController {
        }
        self.presentViewController(optionMenu, animated: true, completion: nil)
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
            lblAlert.font = UIFont.boldSystemFontOfSize(18.0)
            lblAlert.textColor = UIColor.lightGrayColor()
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
        
        let objMedia : MediaObject = self.arrShowData[indexPath.row] as! MediaObject

        var cell : ShowMediaCell!
        if cell == nil {
            cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ShowMediaCell
            cell.backgroundColor = UIColor.clearColor()
        }
        cell.tag = indexPath.row
        cell.showMediaDelegate = self
        cell.selectionStyle = .None
        cell.configureShowMediaTableViewCell(cell, objMedia: objMedia)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        let objMedia : MediaObject = self.arrShowData[indexPath.row] as! MediaObject
        if self.api.isMediaFileExistInDocumentDirectory(objMedia){
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MediaPreview") as! MediaPreviewViewController
            destinationViewController.socialShareDict = objMedia
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        }else{
            self.showAlertMsg("Download required", message: "Please download to view selected media.")
        }
    }
    
    // MARK: - showMediaCellDelegate methods
    
    func cellDownloadButtonTapped(intIndex: Int) {
        
        let downloadAlert = UIAlertController(title:"Download", message:"Do you want to download this media?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL",comment:"Cancel"), style: .Cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        let videoAction = UIAlertAction(title: "Yes, Download", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            
            if let objMedia : MediaObject = self.arrShowData[intIndex] as? MediaObject {
                self.startLoadingIndicatorView("Downloading")
                if !self.api.isMediaFileExistInDocumentDirectory(objMedia) {
                    self.api.downloadMediaData(objMedia, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
                        dispatch_async(dispatch_get_main_queue(),{
                            self.tblView.reloadData()
                            self.stopLoadingIndicatorView()
                        })
                        },
                        failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
                            self.stopLoadingIndicatorView()
                    })
                }
            }
            
        })
        downloadAlert.addAction(videoAction)
        downloadAlert.addAction(cancelAction)
        self.presentViewController(downloadAlert, animated: true, completion: nil)
    }
    

    // MARK: - UIImagePickerController setup and Delegate methods

    func openCameraToCaptureImage(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            let captureImage = UIImagePickerController()
            captureImage.delegate = self
            captureImage.sourceType = UIImagePickerControllerSourceType.Camera
            captureImage.mediaTypes = [String(kUTTypeImage)]
            captureImage.allowsEditing = false
            self.presentViewController(captureImage, animated: true, completion: nil)
        }else{
            self.showAlertMsg(NSLocalizedString("ALERT",comment:"Alert"), message:NSLocalizedString("CAMERA_NOT_AVAILABLE",comment:"Camera Not Available in Device"))
        }
    }
    
    func openCameraToCaptureVideo(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            let captureVideo = UIImagePickerController()
            captureVideo.delegate = self
            captureVideo.sourceType = UIImagePickerControllerSourceType.Camera
            captureVideo.mediaTypes = [String(kUTTypeMovie)]
            captureVideo.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Video
            self.presentViewController(captureVideo, animated: false ) { () -> Void in  }
            
        }else{
            self.showAlertMsg(NSLocalizedString("ALERT",comment:"Alert"), message:NSLocalizedString("CAMERA_NOT_AVAILABLE",comment:"Camera Not Available in Device"))
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        var chosenImage : UIImage!
        var videoPath : NSURL!
        var isMediaTypeImage : Bool = false
        
        if mediaType.isEqualToString(kUTTypeImage as String) {
            /* Media is an image */
            isMediaTypeImage = true
            chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);
        } else if mediaType.isEqualToString(kUTTypeMovie as String) {
            /* Media is a video */
            //let url: AnyObject? = info[UIImagePickerControllerMediaURL]
            isMediaTypeImage = false
            videoPath = info[UIImagePickerControllerMediaURL] as! NSURL
            UISaveVideoAtPathToSavedPhotosAlbum("\(videoPath)",nil,nil,nil);
        }
        dismissViewControllerAnimated(true, completion:{
            if isMediaTypeImage {
                self.shareMediaOnSocials(chosenImage, videoURL: NSURL(), isImage: true)
            }else {
                self.shareMediaOnSocials(UIImage(), videoURL: videoPath, isImage: false)
            }
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
