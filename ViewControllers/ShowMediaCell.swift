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
    
    
    func configureShowMediaTableViewCell(cell:ShowMediaCell,dictTemp : NSDictionary) {
    
        let mediaName : NSString = dictTemp.objectForKey("fileName") as! NSString
        let mediaType : Int = dictTemp.objectForKey("type") as! Int
        
        let y : CGFloat = 10
        
        switch mediaType {
            
        case 1 :
            if self.api.getDocumentDirectoryFileURL(dictTemp as [NSObject : AnyObject]) != nil{
                var tempImageView : UIImageView!
                tempImageView = UIImageView(frame: CGRectMake(self.frame.origin.x + 20, y, self.frame.size.width - 40, 150))
                if(self.api.isMediaFileExistInDocumentDirectory(dictTemp as [NSObject : AnyObject])){
                    tempImageView.image = UIImage(data: NSData(contentsOfURL: self.api.getDocumentDirectoryFileURL(dictTemp as [NSObject : AnyObject]))!)
                }
                self.contentView.addSubview(tempImageView)
            }
            lblDesc = UILabel(frame : CGRectMake(self.frame.origin.x + 20, y + 150, self.frame.size.width - 40, 20))
            lblDesc.text = mediaName as String
            lblDesc.textColor = UIColor.darkGrayColor()
            lblDesc.textAlignment = NSTextAlignment.Center
            self.contentView.addSubview(lblDesc)
            
        case 2 :
            if self.api.getDocumentDirectoryFileURL(dictTemp as [NSObject : AnyObject]) != nil{
                var tempWebView : UIWebView!
                tempWebView = UIWebView(frame: CGRectMake(self.frame.origin.x + 20, y, self.frame.size.width - 40, 150))
                tempWebView.userInteractionEnabled = false
                if(self.api.isMediaFileExistInDocumentDirectory(dictTemp as [NSObject : AnyObject])){
                    let urlRequest : NSURLRequest = NSURLRequest(URL: self.api.getDocumentDirectoryFileURL(dictTemp as [NSObject : AnyObject]))
                    tempWebView.loadRequest(urlRequest)
                }
                self.contentView.addSubview(tempWebView)
            }
            lblDesc = UILabel(frame : CGRectMake(self.frame.origin.x + 20, y + 150, self.frame.size.width - 40, 20))
            lblDesc.text = mediaName as String
            lblDesc.textColor = UIColor.darkGrayColor()
            lblDesc.textAlignment = NSTextAlignment.Center
            self.contentView.addSubview(lblDesc)
            
        case 3 :
            if self.api.generateThumbImage(dictTemp as [NSObject : AnyObject]) != nil{
                var tempImageView : UIImageView!
                tempImageView = UIImageView(frame: CGRectMake(self.frame.origin.x + 20, y, self.frame.size.width - 40, 150))
                tempImageView.image = self.api.generateThumbImage(dictTemp as [NSObject : AnyObject])
                self.contentView.addSubview(tempImageView)
            }
            lblDesc = UILabel(frame : CGRectMake(self.frame.origin.x + 20, y + 150, self.frame.size.width - 40, 20))
            lblDesc.text = mediaName as String
            lblDesc.textColor = UIColor.darkGrayColor()
            lblDesc.textAlignment = NSTextAlignment.Center
            self.contentView.addSubview(lblDesc)
            
        default :
            print("Default button Tapped")
        }

    }
}