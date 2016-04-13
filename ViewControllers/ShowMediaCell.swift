//
//  ShowMediaCell.swift
//  Rondogo
//
//  Created by GrepRuby3 on 30/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

protocol showMediaCellDelegate {
    func cellDownloadButtonTapped(intIndex: Int)
}

class ShowMediaCell: UITableViewCell {
    
    let api : AppApi = AppApi()
    var noImage : UIImageView = UIImageView()
    var btnDownload : UIButton = UIButton()
    var imagePreView : UIImageView = UIImageView()
    var videoPreView : UIImageView = UIImageView()
    var pdfPreView : UIWebView = UIWebView()
    var lblDesc : UILabel = UILabel()
    var showMediaDelegate: showMediaCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellSeparatorInsectProperty() {
        self.separatorInset = UIEdgeInsetsMake(0, 0, self.frame.size.width, 0)
        if self.respondsToSelector("preservesSuperviewLayoutMargins") {
            self.layoutMargins = UIEdgeInsetsZero
            self.preservesSuperviewLayoutMargins = false
        }
    }
    
    func resetAllViewObjects(cell:ShowMediaCell) {
        cell.lblDesc.text = ""
        cell.imagePreView.image = nil
        cell.videoPreView.image = nil
        cell.pdfPreView.removeFromSuperview()
        self.setCellSeparatorInsectProperty()
    }
    
    func downloadButtonTapped() {
        showMediaDelegate?.cellDownloadButtonTapped(self.tag)
    }

    func configureShowMediaTableViewCell(cell:ShowMediaCell, objMedia: MediaObject) {
    
        let mediaName : NSString = objMedia.object_name
        let mediaType : Int = objMedia.object_type as Int
        var isDownloaded : Bool = false
        
        self.resetAllViewObjects(cell)
        
        let y : CGFloat = 10
        
        switch mediaType {
            
        case 1 :
            if self.api.getDocumentDirectoryFileURL(objMedia) != nil{
                imagePreView.frame = CGRectMake(self.frame.origin.x + 20, y, self.frame.size.width - 40, 150)
                imagePreView.contentMode = .ScaleAspectFit
                if(self.api.isMediaFileExistInDocumentDirectory(objMedia)){
                    isDownloaded = true
                    imagePreView.image = UIImage(data: NSData(contentsOfURL: self.api.getDocumentDirectoryFileURL(objMedia))!)
                }
                cell.contentView.addSubview(imagePreView)
            }
            lblDesc = UILabel(frame : CGRectMake(self.frame.origin.x + 20, y + 153, self.frame.size.width - 40, 20))
            lblDesc.text = mediaName as String
            lblDesc.textColor = UIColor.darkGrayColor()
            lblDesc.textAlignment = NSTextAlignment.Center
            lblDesc.font = UIFont.boldSystemFontOfSize(15.0)
            cell.contentView.addSubview(lblDesc)
            
        case 2 :
            if self.api.getDocumentDirectoryFileURL(objMedia) != nil{
                pdfPreView.frame = CGRectMake(self.frame.origin.x + 20, y, self.frame.size.width - 40, 150)
                pdfPreView.opaque = false
                pdfPreView.backgroundColor = UIColor.clearColor()
                pdfPreView.userInteractionEnabled = false
                if(self.api.isMediaFileExistInDocumentDirectory(objMedia)){
                    isDownloaded = true
                    let urlRequest : NSURLRequest = NSURLRequest(URL: self.api.getDocumentDirectoryFileURL(objMedia))
                    pdfPreView.loadRequest(urlRequest)
                }
                cell.contentView.addSubview(pdfPreView)
            }
            lblDesc = UILabel(frame : CGRectMake(self.frame.origin.x + 20, y + 153, self.frame.size.width - 40, 20))
            lblDesc.text = mediaName as String
            lblDesc.textColor = UIColor.darkGrayColor()
            lblDesc.textAlignment = NSTextAlignment.Center
            cell.contentView.addSubview(lblDesc)
            
        case 3 :
            if self.api.getDocumentDirectoryFileURL(objMedia) != nil {
                videoPreView.frame = CGRectMake(self.frame.origin.x + 20, y, self.frame.size.width - 40, 150)
                videoPreView.contentMode = .ScaleAspectFit
                if(self.api.isMediaFileExistInDocumentDirectory(objMedia)){
                    isDownloaded = true
                    videoPreView.image = self.api.generateThumbImage(objMedia)
                }
                cell.contentView.addSubview(videoPreView)
            }
            lblDesc = UILabel(frame : CGRectMake(self.frame.origin.x + 20, y + 153, self.frame.size.width - 40, 20))
            lblDesc.text = mediaName as String
            lblDesc.textColor = UIColor.darkGrayColor()
            lblDesc.textAlignment = NSTextAlignment.Center
            cell.contentView.addSubview(lblDesc)
            
        default :
            print("Default button Tapped")
        }

        if (!isDownloaded) {
            self.noImage.frame = CGRectMake(self.frame.origin.x + 20, y, self.frame.size.width - 40, 150)
            self.noImage.backgroundColor = UIColor.whiteColor()
            self.noImage.layer.cornerRadius = 10
            self.noImage.userInteractionEnabled = true
            self.noImage.image = UIImage( named: "icon_no_image")
            self.noImage.contentMode = .ScaleAspectFit
            
            self.btnDownload.frame = CGRectMake(self.noImage.frame.size.width - 48, 0, 48, 48)
            self.btnDownload.addTarget(self, action: "downloadButtonTapped", forControlEvents:.TouchUpInside)
            self.btnDownload.setImage(UIImage( named: "icon_download"), forState: .Normal)
            self.noImage.addSubview(self.btnDownload)
            
            cell.contentView.addSubview(self.noImage)
        }else {
            self.noImage.removeFromSuperview()
        }

    }
    
    
}