//
//  CollectionCell.swift
//  Rondogo
//
//  Created by GrepRuby3 on 18/12/15.
//  Copyright © 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

protocol homePageCellDelegate {
    func selectedPickerOption(objSubCategory : SubCategories)
}

class CollectionCell : UICollectionViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let objWindow:UIWindow = UIApplication.sharedApplication().delegate!.window!!
    var imageView: UIImageView!
    var txtSubCate: PickerTextField!
    var subCatPicker: UIPickerView!
    var toolBar: UIToolbar!
    var arrSubCategories : NSArray = NSArray()
    var homePageDelegate: homePageCellDelegate?
    
    
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
    
    func configureCellLayout(frame: CGRect){
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height-25))
        imageView.contentMode = UIViewContentMode.ScaleToFill
        imageView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        
        txtSubCate = PickerTextField(frame: CGRect(x: imageView.frame.origin.x, y: imageView.frame.size.height + 5, width: imageView.frame.size.width, height: 25))
        txtSubCate.attributedPlaceholder = NSAttributedString(string:"choose..", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        txtSubCate.delegate = self
        txtSubCate.background = UIImage(named: "subCat_dropdown")
        txtSubCate.textColor = UIColor.whiteColor()
        txtSubCate.font = UIFont.systemFontOfSize(14.0)
        contentView.addSubview(txtSubCate)
    }
    
    // MARK: - Get Sub Category data from Local Data base
    
    func getAllSubCategoriesDataFromLocalDB() {
        let subCategoryFilter : NSPredicate = NSPredicate(format: "cat_id = %d AND is_deleted = 0",self.tag)
        self.arrSubCategories = SubCategories.MR_findAllSortedBy("subCat_sequence", ascending: true, withPredicate: subCategoryFilter)
        self.setUpChooseCandidatePicker()
    }
    
    // MARK: -  Sub Category Picker and their delegate methods
    
    func setUpChooseCandidatePicker() {
        
        subCatPicker = UIPickerView(frame: CGRectMake(0, objWindow.frame.height - 150, objWindow.frame.width, 150))
        subCatPicker.backgroundColor = UIColor.whiteColor()
        subCatPicker.showsSelectionIndicator = true
        subCatPicker.delegate = self
        subCatPicker.dataSource = self
        self.txtSubCate.inputView = subCatPicker
        
        toolBar = UIToolbar( frame: CGRectMake(0, subCatPicker.frame.origin.y - 40, objWindow.frame.width, 40))
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.darkGrayColor()
        toolBar.sizeToFit()
        self.txtSubCate.inputAccessoryView = toolBar
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target:self, action:"toolBarDoneTapped")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target:self, action:"toolBarCancelTapped")
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrSubCategories.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let objSubCategory : SubCategories = self.arrSubCategories[row] as! SubCategories
        return objSubCategory.subCat_name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let objSubCategory : SubCategories = self.arrSubCategories[row] as! SubCategories
        self.txtSubCate.text = objSubCategory.subCat_name
    }
    
    func toolBarDoneTapped() {
        let objSubCategory : SubCategories = self.arrSubCategories[self.subCatPicker.selectedRowInComponent(0)] as! SubCategories
        self.txtSubCate.text = objSubCategory.subCat_name
        self.txtSubCate.resignFirstResponder()
        self.homePageDelegate?.selectedPickerOption(objSubCategory)
    }
    
    func toolBarCancelTapped() {
        self.txtSubCate.resignFirstResponder()
    }
    
    // MARK: - Text Field Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.getAllSubCategoriesDataFromLocalDB()
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}