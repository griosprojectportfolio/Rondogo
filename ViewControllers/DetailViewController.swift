//
//  DetailViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 17/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

//
//  TreasureHuntViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 04/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: BaseViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    var categoryImageView   : UIImageView!
    var collectionView      : UICollectionView!
    let flowLayout          : UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    var arrTempEnImages : NSArray!
    var arrTempHeImages : NSArray!
    var strNavigationTittle : String!
    
    var categoryId : NSInteger!
    
    // MARK: - View related methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = strNavigationTittle
        self.navigationController?.navigationBarHidden = false
        self.addRightAndLeftNavItemOnView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        self.applyDefaults()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation bar methods
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
    
    
    // MARK: - Page layout methods
    func applyDefaults(){
        
        if isiPhone5orLower {
            if isiPhone4s {
                self.categoryImageView = UIImageView(frame: CGRectMake(self.view.center.x - 60, 70, 120, 120))
            }else{
                self.categoryImageView = UIImageView(frame: CGRectMake(self.view.center.x - 70, 70, 150, 150))
            }
        }else if isiPhone6 {
            self.categoryImageView = UIImageView(frame: CGRectMake(self.view.center.x - 90, 70, 180, 180))
        }else if isiPhone6plus {
            self.categoryImageView = UIImageView(frame: CGRectMake(self.view.center.x - 90, 70, 200, 200))
        }else if isiPadAir2 {
            self.categoryImageView = UIImageView(frame: CGRectMake(self.view.center.x - 110,64, 200, 200))
        }else{
            self.categoryImageView = UIImageView(frame: CGRectMake(self.view.center.x - 110, 64, 200, 200))
        }
        
        self.categoryImageView.image = UIImage(named: (self.selectedLanguage == hebrew ? arrTempHeImages.objectAtIndex(0) as! NSString : arrTempEnImages.objectAtIndex(0) as! NSString) as String)
        self.view.addSubview(self.categoryImageView)
        
        collectionView = UICollectionView(frame: CGRectMake(self.view.frame.origin.x + 20, categoryImageView.frame.height + 100, self.view.frame.size.width - 40, self.view.frame.size.height - (categoryImageView.frame.height + 150)), collectionViewLayout: flowLayout)
        collectionView?.registerClass(CollectionCell.self, forCellWithReuseIdentifier: "subCategoryCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.clearColor()
        self.view.addSubview(collectionView!)
    }
    
    
    // MARK: - Collection view Delegate method
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width / 3.5, height: self.collectionView.frame.size.width / 3.5)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("subCategoryCell", forIndexPath: indexPath) as! CollectionCell
        let imgName : String = self.selectedLanguage == hebrew ? arrTempHeImages.objectAtIndex(indexPath.row + 1) as! String : arrTempEnImages.objectAtIndex(indexPath.row + 1) as! String
        cell.applyDefaults(cell.frame, strImgName: imgName)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShowMedia") as! ShowMediaViewController
        destinationViewController.categoryId = categoryId
        destinationViewController.subCategoryId = indexPath.row + 1
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    
}