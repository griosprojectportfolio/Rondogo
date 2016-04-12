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

    var strNavigationTittle : String!
    var categoryId : NSInteger!
    var categoryImage : UIImage!
    
    var arrSubCategories     : NSArray = NSArray()

    // MARK: - View related methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = strNavigationTittle
        self.navigationController?.navigationBarHidden = false
        self.addLeftNavigationBarButtonItemOnView()
        self.applyDefaults()
        self.getAllSubCategoriesDataFromLocalDB()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Page layout methods
    func applyDefaults(){
        
        if isiPhone5orLower {
            self.categoryImageView = UIImageView(frame: CGRectMake(self.view.center.x - 70, 70, 150, 150))
        }else if isiPhone6 {
            self.categoryImageView = UIImageView(frame: CGRectMake(self.view.center.x - 90, 70, 180, 180))
        }else if isiPhone6plus {
            self.categoryImageView = UIImageView(frame: CGRectMake(self.view.center.x - 90, 70, 200, 200))
        }else if isiPadAir2 {
            self.categoryImageView = UIImageView(frame: CGRectMake(self.view.center.x - 110,64, 200, 200))
        }else{
            self.categoryImageView = UIImageView(frame: CGRectMake(self.view.center.x - 110, 64, 200, 200))
        }
        
        self.categoryImageView.image = self.categoryImage
        self.view.addSubview(self.categoryImageView)
        
        collectionView = UICollectionView(frame: CGRectMake(self.view.frame.origin.x + 20, categoryImageView.frame.height + 90, self.view.frame.size.width - 40, self.view.frame.size.height - (categoryImageView.frame.height + 110)), collectionViewLayout: flowLayout)
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
        return self.arrSubCategories.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width / 3.5, height: self.collectionView.frame.size.width / 3.5)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let objSubCategory : SubCategories = self.arrSubCategories[indexPath.row] as! SubCategories
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("subCategoryCell", forIndexPath: indexPath) as! CollectionCell
        cell.configureCellLayout(cell.frame)
        let urlString : String = objSubCategory.subCat_imageUrl
        
        //cell.imageView.image = nil
        cell.imageView.sd_setImageWithURL(NSURL(string: urlString), placeholderImage: nil , completed:{(image: UIImage?, error: NSError?, cacheType: SDImageCacheType!, imageURL: NSURL?) in
            if self.arrSubCategories.count == indexPath.row + 1 {
                self.stopLoadingIndicatorView()
            }
        })
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let objSubCategory : SubCategories = self.arrSubCategories[indexPath.row] as! SubCategories
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShowMedia") as! ShowMediaViewController
        destinationViewController.categoryId = categoryId
        destinationViewController.subCategoryId = objSubCategory.subCat_id as NSInteger
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    // MARK: - Some common methods
    func getAllSubCategoriesDataFromLocalDB() {
        self.startLoadingIndicatorView("Loading...")
        let subCategoryFilter : NSPredicate = NSPredicate(format: "cat_id = %d AND is_deleted = 0",self.categoryId)
        self.arrSubCategories = SubCategories.MR_findAllSortedBy("subCat_sequence", ascending: true, withPredicate: subCategoryFilter)
        if self.arrSubCategories.count != 0 {
            self.collectionView.reloadData()
        }else {
            self.stopLoadingIndicatorView()
        }
    }
}