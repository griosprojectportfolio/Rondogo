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
    var lblDesc : UILabel = UILabel()
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configureShowMediaTableViewCell(cell:ShowMediaCell, objMedia: MediaObject) {
    
        let mediaName : NSString = objMedia.object_name
        let mediaType : Int = objMedia.object_type as Int
        
        let y : CGFloat = 10
        
        switch mediaType {
            
        case 1 :
            if self.api.getDocumentDirectoryFileURL(objMedia) != nil{
                var tempImageView : UIImageView!
                tempImageView = UIImageView(frame: CGRectMake(self.frame.origin.x + 20, y, self.frame.size.width - 40, 150))
                tempImageView.contentMode = .ScaleAspectFit
                if(self.api.isMediaFileExistInDocumentDirectory(objMedia)){
                    tempImageView.image = UIImage(data: NSData(contentsOfURL: self.api.getDocumentDirectoryFileURL(objMedia))!)
                }
                self.contentView.addSubview(tempImageView)
            }
            lblDesc = UILabel(frame : CGRectMake(self.frame.origin.x + 20, y + 153, self.frame.size.width - 40, 20))
            lblDesc.text = mediaName as String
            lblDesc.textColor = UIColor.darkGrayColor()
            lblDesc.textAlignment = NSTextAlignment.Center
            self.contentView.addSubview(lblDesc)
            
        case 2 :
            if self.api.getDocumentDirectoryFileURL(objMedia) != nil{
                var tempWebView : UIWebView!
                tempWebView = UIWebView(frame: CGRectMake(self.frame.origin.x + 20, y, self.frame.size.width - 40, 150))
                tempWebView.userInteractionEnabled = false
                if(self.api.isMediaFileExistInDocumentDirectory(objMedia)){
                    let urlRequest : NSURLRequest = NSURLRequest(URL: self.api.getDocumentDirectoryFileURL(objMedia))
                    tempWebView.loadRequest(urlRequest)
                }
                self.contentView.addSubview(tempWebView)
            }
            lblDesc = UILabel(frame : CGRectMake(self.frame.origin.x + 20, y + 153, self.frame.size.width - 40, 20))
            lblDesc.text = mediaName as String
            lblDesc.textColor = UIColor.darkGrayColor()
            lblDesc.textAlignment = NSTextAlignment.Center
            self.contentView.addSubview(lblDesc)
            
        case 3 :
            if self.api.generateThumbImage(objMedia) != nil{
                var tempImageView : UIImageView!
                tempImageView = UIImageView(frame: CGRectMake(self.frame.origin.x + 20, y, self.frame.size.width - 40, 150))
                tempImageView.contentMode = .ScaleAspectFit
                tempImageView.image = self.api.generateThumbImage(objMedia)
                self.contentView.addSubview(tempImageView)
            }
            lblDesc = UILabel(frame : CGRectMake(self.frame.origin.x + 20, y + 153, self.frame.size.width - 40, 20))
            lblDesc.text = mediaName as String
            lblDesc.textColor = UIColor.darkGrayColor()
            lblDesc.textAlignment = NSTextAlignment.Center
            self.contentView.addSubview(lblDesc)
            
        default :
            print("Default button Tapped")
        }

    }
}