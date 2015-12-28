//
//  ShowMediaCell.swift
//  Rondogo
//
//  Created by GrepRuby3 on 30/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

class ShowMediaCell: UITableViewCell {
    
    let api : AppApi = AppApi()
    var imagePreView : UIImageView = UIImageView()
    var videoPreView : UIImageView = UIImageView()
    var pdfPreView : UIWebView = UIWebView()
    var lblDesc : UILabel = UILabel()
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func resetAllViewObjects(cell:ShowMediaCell) {
        cell.lblDesc.text = ""
        cell.imagePreView.image = nil
        cell.videoPreView.image = nil
        cell.pdfPreView.removeFromSuperview()
    }
    
    
    func configureShowMediaTableViewCell(cell:ShowMediaCell, objMedia: MediaObject) {
    
        let mediaName : NSString = objMedia.object_name
        let mediaType : Int = objMedia.object_type as Int
        
        self.resetAllViewObjects(cell)
        
        let y : CGFloat = 10
        
        switch mediaType {
            
        case 1 :
            if self.api.getDocumentDirectoryFileURL(objMedia) != nil{
                imagePreView.frame = CGRectMake(self.frame.origin.x + 20, y, self.frame.size.width - 40, 150)
                imagePreView.contentMode = .ScaleAspectFit
                if(self.api.isMediaFileExistInDocumentDirectory(objMedia)){
                    imagePreView.image = UIImage(data: NSData(contentsOfURL: self.api.getDocumentDirectoryFileURL(objMedia))!)
                }
                cell.contentView.addSubview(imagePreView)
            }
            lblDesc = UILabel(frame : CGRectMake(self.frame.origin.x + 20, y + 153, self.frame.size.width - 40, 20))
            lblDesc.text = mediaName as String
            lblDesc.textColor = UIColor.darkGrayColor()
            lblDesc.textAlignment = NSTextAlignment.Center
            cell.contentView.addSubview(lblDesc)
            
        case 2 :
            if self.api.getDocumentDirectoryFileURL(objMedia) != nil{
                pdfPreView.frame = CGRectMake(self.frame.origin.x + 20, y, self.frame.size.width - 40, 150)
                pdfPreView.userInteractionEnabled = false
                if(self.api.isMediaFileExistInDocumentDirectory(objMedia)){
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
            if self.api.generateThumbImage(objMedia) != nil{
                videoPreView.frame = CGRectMake(self.frame.origin.x + 20, y, self.frame.size.width - 40, 150)
                videoPreView.contentMode = .ScaleAspectFit
                videoPreView.image = self.api.generateThumbImage(objMedia)
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

    }
}