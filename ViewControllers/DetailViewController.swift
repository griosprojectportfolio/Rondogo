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
    var cellImageCache = [String:UIImage]()

    // MARK: - View related methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = strNavigationTittle
        self.navigationController?.navigationBarHidden = false
        self.addRightAndLeftNavItemOnView()
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
        
        cell.imageView.image = nil
        // If this image is already cached, don't re-download
        if let img = self.cellImageCache[urlString] {
            cell.imageView?.image = img
        }
        else {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                if let url = NSURL(string: urlString) {
                    if let data = NSData(contentsOfURL: url){
                        // Convert the downloaded data in to a UIImage object
                        let image = UIImage(data: data)
                        // Store the image in to our cache
                        self.cellImageCache[urlString] = image
                        // Update the cell
                        dispatch_async(dispatch_get_main_queue(), {
                            if let cellToUpdate : CollectionCell = self.collectionView!.cellForItemAtIndexPath(indexPath) as? CollectionCell {
                                cellToUpdate.imageView.contentMode = UIViewContentMode.ScaleAspectFit
                                cellToUpdate.imageView.image = image
                            }
                        })
                    }
                }
            })
        }
        
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
        
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            let subCategoryFilter : NSPredicate = NSPredicate(format: "cat_id = %d AND is_deleted = 0",self.categoryId)
            self.arrSubCategories = SubCategories.MR_findAllSortedBy("subCat_sequence", ascending: true, withPredicate: subCategoryFilter)
            self.collectionView.reloadData()
            self.stopLoadingIndicatorView()
        })
    }
}