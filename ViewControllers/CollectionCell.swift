//
//  CollectionCell.swift
//  Rondogo
//
//  Created by GrepRuby3 on 18/12/15.
//  Copyright © 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

class CollectionCell : UICollectionViewCell {
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyDefaults(frame: CGRect , strImgName : String ){
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        imageView.image = UIImage(named: strImgName)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        
    }
    
    func configureCellAtIndexPath(frame: CGRect , indexPath : NSIndexPath, strCurrLang : String ){
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        
        switch indexPath.row {
            case 0 : imageView.image = UIImage(named: strCurrLang == "he" ? "He_TreasureHunt.png" : "En_TreasureHunt.png") as UIImage?
            case 1 : imageView.image = UIImage(named: strCurrLang == "he" ? "He_NightStar.png" : "En_NightStar.png") as UIImage?
            case 2 : imageView.image = UIImage(named: strCurrLang == "he" ? "He_MissionnPossible.png" : "En_MissionnPossible.png") as UIImage?
            case 3 : imageView.image = UIImage(named: strCurrLang == "he" ? "He_Cops&Robbers.png" : "En_Cops&Robbers.png") as UIImage?
            case 4 : imageView.image = UIImage(named: strCurrLang == "he" ? "He_YourRace.png" : "En_YourRace.png") as UIImage?
            case 5 : imageView.image = UIImage(named: strCurrLang == "he" ? "He_TimeLessRopes.png" : "En_TimeLessRopes.png") as UIImage?
            default : print("No matches")
        }
        
    }
    
}