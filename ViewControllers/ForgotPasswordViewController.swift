//
//  ForgotPasswordViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 09/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

class ForgotPasswordViewController: BaseViewController,UITextFieldDelegate {
    
    var recoveryEmailIdTxt  : TextField!
    var forgotPasswordBtn   : UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = NSLocalizedString("FORGOT_PASSWORD",comment:"Forgot Password")
        self.navigationController?.navigationBarHidden = false
        self.view.backgroundColor =  UIColor().appBackgroundColor()
        self.addRightAndLeftNavItemOnView()
        self.applyDefaults()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
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
    
    func applyDefaults(){
        
        var y : CGFloat = 100.0

        self.recoveryEmailIdTxt = TextField(frame: CGRectMake(self.view.frame.origin.x + 20, y, self.view.frame.size.width - 40, 50))
        let emailPlaceholder = NSAttributedString(string:NSLocalizedString("EMAIL",comment:"Email"), attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.recoveryEmailIdTxt.attributedPlaceholder = emailPlaceholder;
        self.recoveryEmailIdTxt.autocapitalizationType = UITextAutocapitalizationType.None
        self.recoveryEmailIdTxt.delegate = self
        self.recoveryEmailIdTxt.layer.cornerRadius = 3
        self.recoveryEmailIdTxt.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(self.recoveryEmailIdTxt)
        
        y = y + 70
        
        self.forgotPasswordBtn = UIButton(frame: CGRectMake(self.view.frame.origin.x + 20, y, self.view.frame.size.width - 40, 50))
        self.forgotPasswordBtn.setTitle(NSLocalizedString("FORGOT_PASSWORD",comment:"Forgot Password"), forState:.Normal)
        self.forgotPasswordBtn.setTitleColor(UIColor.whiteColor(), forState:.Normal)
        self.forgotPasswordBtn.backgroundColor = UIColor().appSignInButtonBgColor()
        self.forgotPasswordBtn.addTarget(self, action:"forgotPasswordButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.forgotPasswordBtn)
    }
    
    /* Text Field Delegate Methods */
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    /* Button Tapped method */
    
    func forgotPasswordButtonTapped(){
        
        let parameters : NSDictionary = [ "user[email]" : recoveryEmailIdTxt.text! ]
        
        if isEnteredEmailBlankOrInValid(){
            
            /* Method to Add Custom UIActivityIndicatorView in current screen */
            activityIndicator = ActivityIndicatorView(frame: self.view.frame)
            activityIndicator.startActivityIndicator(self)
            
            self.api.forgotPassword( parameters as [NSObject : AnyObject], success: { ( operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
                print(responseObject)
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                self.showSuccessAlertToUser(dictResponse.objectForKey("info") as! NSString)
                self.activityIndicator.stopActivityIndicator(self)
                },
                failure: { ( operation: AFHTTPRequestOperation?, error: NSError? ) in
                    print(error)
                    self.activityIndicator.stopActivityIndicator(self)
                    self.showSuccessAlertToUser("Forgot Password have some error")
            })
        }
    }
    
    // Checking Email Validation 
    
    func isEnteredEmailBlankOrInValid() -> Bool {
    
        var alertMessage : NSString = ""
        
        if recoveryEmailIdTxt.text == "" {
            alertMessage = "Email can't be blank"
        }else if !CommonUtilities.isValidEmailAddress(recoveryEmailIdTxt.text!){
            alertMessage = "Invalid Email Address"
        }else {
             return true
        }
        
        let alert = UIAlertController(title: "Alert!",
            message: alertMessage as String,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK",comment:"Ok"), style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        return false
    }
    
    
    /* Show pop up on success */
    
    func showSuccessAlertToUser(strMessage : NSString){
        
        let alert = UIAlertController(title: "Alert", message: strMessage as String, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomePage") as! HomePageViewController
                self.navigationController?.pushViewController(destinationViewController, animated: true)
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
