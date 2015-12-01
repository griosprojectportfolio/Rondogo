//
//  LoginViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 05/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: BaseViewController, UITextFieldDelegate {
    
    var logoImageView       : UIImageView!
    var userNameTxt         : TextField!
    var passwordTxt         : TextField!
    var loginBtn            : UIButton!
    var signUpBtn           : UIButton!
    var forgotPasswordBtn   : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("LOGIN",comment:"Log In")
        self.navigationController?.navigationBarHidden = false
        self.view.backgroundColor =  UIColor().appBackgroundColor() //UIColor(hexColorCode: "#ded0a4") // F7F8E0
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
        
        if isiPhone5orLower{
            
            if isiPhone4s {
                self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 60, 75, 120, 120))
                self.userNameTxt = TextField(frame: CGRectMake(0, 230 , self.view.frame.size.width, 50))
                self.passwordTxt = TextField(frame: CGRectMake(0, 281 , self.view.frame.size.width, 50))
                self.loginBtn = UIButton(frame: CGRectMake(0, 340 , self.view.frame.size.width, 50))
                self.signUpBtn = UIButton(frame: CGRectMake(0, 400 , self.view.frame.size.width, 50))
                
            }else{
                self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 75, 75, 150, 150))
                self.userNameTxt = TextField(frame: CGRectMake(0, 230 + 30, self.view.frame.size.width, 50))
                self.passwordTxt = TextField(frame: CGRectMake(0, 281  + 30, self.view.frame.size.width, 50))
                self.loginBtn = UIButton(frame: CGRectMake(0, 340  + 30, self.view.frame.size.width, 50))
                self.signUpBtn = UIButton(frame: CGRectMake(0, 400 + 30, self.view.frame.size.width, 50))
            }
            
        }else if isiPhone6{
            self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 90, 90, 180, 180))
            self.userNameTxt = TextField(frame: CGRectMake(0, 300 + 30, self.view.frame.size.width, 50))
            self.passwordTxt = TextField(frame: CGRectMake(0, 351 + 30, self.view.frame.size.width, 50))
            self.loginBtn = UIButton(frame: CGRectMake(0, 410 + 30, self.view.frame.size.width, 50))
            self.signUpBtn = UIButton(frame: CGRectMake(0, 470 + 30, self.view.frame.size.width, 50))
            
        }else{
            self.logoImageView = UIImageView(frame: CGRectMake(self.view.center.x - 90, 90, 200, 200))
            self.userNameTxt = TextField(frame: CGRectMake(0, 370 + 30, self.view.frame.size.width, 50))
            self.passwordTxt = TextField(frame: CGRectMake(0, 421 + 30, self.view.frame.size.width, 50))
            self.loginBtn = UIButton(frame: CGRectMake(0, 480 + 30, self.view.frame.size.width, 50))
            self.signUpBtn = UIButton(frame: CGRectMake(0, 540 + 30, self.view.frame.size.width, 50))
        }
        
        self.logoImageView.image = UIImage (named: "Logo.png")
        self.view.addSubview(self.logoImageView)
        
        let userNamePlaceholder = NSAttributedString(string: NSLocalizedString("EMAIL",comment:"Email"), attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.userNameTxt.attributedPlaceholder = userNamePlaceholder
        self.userNameTxt.autocapitalizationType = UITextAutocapitalizationType.None
        self.userNameTxt.keyboardType = UIKeyboardType.EmailAddress
        self.userNameTxt.delegate = self
        self.userNameTxt.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(self.userNameTxt)
        
        let passwordPlaceholder = NSAttributedString(string: NSLocalizedString("PASSWORD",comment:"Password"), attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.passwordTxt.attributedPlaceholder = passwordPlaceholder
        self.passwordTxt.delegate = self
        self.passwordTxt.secureTextEntry = true
        self.passwordTxt.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(self.passwordTxt)
        
        self.loginBtn.setTitle(NSLocalizedString("SIGNIN",comment:"Sign In"), forState:.Normal)
        self.loginBtn.setTitleColor(UIColor.whiteColor(), forState:.Normal)
        self.loginBtn.backgroundColor = UIColor().appSignInButtonBgColor()
        self.loginBtn.addTarget(self, action: "loginButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.loginBtn)
        
        self.signUpBtn.setTitle(NSLocalizedString("SIGNUP",comment:"Sign Up"), forState:.Normal)
        self.signUpBtn.setTitleColor(UIColor.whiteColor(), forState:.Normal)
        self.signUpBtn.backgroundColor = UIColor().appSignUpButtonBgColor()
        self.signUpBtn.addTarget(self, action: "signUpButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.signUpBtn)
        
        self.forgotPasswordBtn = UIButton(frame: CGRectMake(self.view.center.x, self.view.frame.height - 40, self.view.frame.width/2, 40))
        self.forgotPasswordBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.forgotPasswordBtn.titleLabel?.textAlignment = NSTextAlignment.Right
        self.forgotPasswordBtn.setTitle(NSLocalizedString("FORGOT_PASSWORD",comment:"Forgot Password"), forState: .Normal)
        self.forgotPasswordBtn.backgroundColor = UIColor.clearColor()
        self.forgotPasswordBtn.addTarget(self, action: "forgotPasswordButtonTapped", forControlEvents:.TouchUpInside)
        self.view.addSubview(self.forgotPasswordBtn)
    }
    
    /* ======= Text Field Delegate Methods ======== */
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    /* ===============================================*/
    
    
    /* Login Button Tapped method */
    
    func loginButtonTapped(){
        
        let parameters : NSDictionary = ["user[email]": userNameTxt.text!, "user[password]": passwordTxt.text!]
        let objSyncApp : SynchronizeApp = SynchronizeApp()
        
        if isEnteredDataBlankOrInValid() {
            
            /* Method to Add Custom UIActivityIndicatorView in current screen */
            activityIndicator = ActivityIndicatorView(frame: self.view.frame)
            activityIndicator.startActivityIndicator(self)

            self.api.loginUser(parameters as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
                
                print(responseObject)
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                let token : NSString = (dictResponse.objectForKey("data") as! NSDictionary).objectForKey("auth_token")as! NSString
                let admin : Bool = (dictResponse.objectForKey("user") as! NSDictionary).objectForKey("is_admin")as! Bool
                self.auth_token = [token]
                self.is_Admin = [admin]

                self.activityIndicator.stopActivityIndicator(self)

                // Block method to start Sync Process
                objSyncApp.startSyncMethodCall(self, success: { (responseObject: AnyObject?) in
                    
                    self.showSuccessAlertToUser("Successfully loged in")

                    }, failure: { (responseObject: AnyObject?) in
                })
                
                },
                failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
                    print(error)
                    self.activityIndicator.stopActivityIndicator(self)
                    self.showSuccessAlertToUser("Login have some error")
            })
        }
    }
    
    func isEnteredDataBlankOrInValid() -> Bool {
        
        var alertMessage : NSString = ""
        
         if !CommonUtilities.isValidEmailAddress(userNameTxt.text!) || userNameTxt.text! == "" {
            alertMessage = "Invalid Email Address \n"
        }else if passwordTxt.text == "" {
            alertMessage = "Password can't be blank \n"
        }else {
            return true
        }
        
        let alert = UIAlertController(title: "Alert!", message: alertMessage as String, preferredStyle: UIAlertControllerStyle.Alert)
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
                print("Ok")
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
    }

    
    /* Sign Up Button Tapped Method */
    
    func signUpButtonTapped(){
        let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignUp") as! SignUpViewController
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    /*  Forgot Password Button Tapped */
    
    func forgotPasswordButtonTapped(){
        let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ForgotPassword") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
