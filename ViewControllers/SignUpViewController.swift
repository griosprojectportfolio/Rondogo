//
//  SignUpViewController.swift
//  Rondogo
//
//  Created by GrepRuby3 on 09/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit
import Foundation

class SignUpViewController: BaseViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    var scrollView = UIScrollView()
    
    var firstNameTxt        : TextField!
    var lastNameTxt         : TextField!
    var emailTxt            : TextField!
    var contactNo           : TextField!
    var userNameTxt         : TextField!
    var passwordTxt         : TextField!
    var confirmPasswordTxt  : TextField!
    
    var signUpBtn           : UIButton!
    var signUpViaFB         : UIButton!
    
    var arrUserObject       : NSArray = NSArray()

    
    // MARK: - View related methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = NSLocalizedString("REGISTER",comment:"Register")
        self.navigationController?.navigationBarHidden = false
        self.addRightAndLeftNavItemOnView()
        self.applyDefaults()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Navigation bar and their action methods
    
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
    
    // MARK: - View layout setup methods
    
    func applyDefaults(){
        
        var y : CGFloat = 40.0
        
        self.firstNameTxt = TextField(frame: CGRectMake(self.view.frame.origin.x + 20, y, self.view.frame.size.width - 40, 50))
        y = y + 60
        self.lastNameTxt = TextField(frame: CGRectMake(self.view.frame.origin.x + 20, y , self.view.frame.size.width - 40, 50))
        y = y + 60
        self.emailTxt = TextField(frame: CGRectMake(self.view.frame.origin.x + 20, y , self.view.frame.size.width - 40, 50))
        y = y + 60
        self.contactNo = TextField(frame: CGRectMake(self.view.frame.origin.x + 20, y , self.view.frame.size.width - 40, 50))
        y = y + 60
        self.userNameTxt = TextField(frame: CGRectMake(self.view.frame.origin.x + 20, y , self.view.frame.size.width - 40, 50))
        y = y + 60
        self.passwordTxt = TextField(frame: CGRectMake(self.view.frame.origin.x + 20, y , self.view.frame.size.width - 40, 50))
        y = y + 60
        self.confirmPasswordTxt = TextField(frame: CGRectMake(self.view.frame.origin.x + 20, y , self.view.frame.size.width - 40, 50))
        y = y + 100
        self.signUpBtn = UIButton(frame: CGRectMake(self.view.frame.origin.x + 20, y, self.view.frame.size.width - 40, 50))
        
        
        self.scrollView = UIScrollView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height))
        self.scrollView.contentSize = CGSizeMake(self.view.frame.width, 640)
        self.scrollView.backgroundColor = UIColor().appBackgroundColor()
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        
        let firstNamePlaceholder = NSAttributedString(string:NSLocalizedString("FIRST_NAME",comment:"First Name"), attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.firstNameTxt.attributedPlaceholder = firstNamePlaceholder
        self.firstNameTxt.autocapitalizationType = UITextAutocapitalizationType.None
        self.firstNameTxt.delegate = self
        self.firstNameTxt.layer.cornerRadius = 3
        self.firstNameTxt.backgroundColor = UIColor.lightGrayColor()
        self.scrollView.addSubview(self.firstNameTxt)
        
        let lastNamePlaceholder = NSAttributedString(string:NSLocalizedString("LAST_NAME",comment:"Last Name"), attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.lastNameTxt.attributedPlaceholder = lastNamePlaceholder
        self.lastNameTxt.autocapitalizationType = UITextAutocapitalizationType.None
        self.lastNameTxt.delegate = self
        self.lastNameTxt.layer.cornerRadius = 3
        self.lastNameTxt.backgroundColor = UIColor.lightGrayColor()
        self.scrollView.addSubview(self.lastNameTxt)
        
        let emailPlaceholder = NSAttributedString(string: NSLocalizedString("EMAIL",comment:"Email"), attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.emailTxt.attributedPlaceholder = emailPlaceholder
        self.emailTxt.autocapitalizationType = UITextAutocapitalizationType.None
        self.emailTxt.delegate = self
        self.emailTxt.layer.cornerRadius = 3
        self.emailTxt.backgroundColor = UIColor.lightGrayColor()
        self.scrollView.addSubview(self.emailTxt)
        
        let contactNoPlaceholder = NSAttributedString(string: NSLocalizedString("CONTACT_NUMBER",comment:"Contact Number"), attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.contactNo.attributedPlaceholder = contactNoPlaceholder
        self.contactNo.autocapitalizationType = UITextAutocapitalizationType.None
        self.contactNo.delegate = self
        self.contactNo.layer.cornerRadius = 3
        self.contactNo.backgroundColor = UIColor.lightGrayColor()
        self.scrollView.addSubview(self.contactNo)
        
        let userNamePlaceholder = NSAttributedString(string: NSLocalizedString("USER_NAME",comment:"User Name"), attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.userNameTxt.attributedPlaceholder = userNamePlaceholder
        self.userNameTxt.autocapitalizationType = UITextAutocapitalizationType.None
        self.userNameTxt.delegate = self
        self.userNameTxt.layer.cornerRadius = 3
        self.userNameTxt.backgroundColor = UIColor.lightGrayColor()
        self.scrollView.addSubview(self.userNameTxt)
        
        let passwordPlaceholder = NSAttributedString(string:NSLocalizedString("PASSWORD",comment:"Password"), attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.passwordTxt.attributedPlaceholder = passwordPlaceholder
        self.passwordTxt.autocapitalizationType = UITextAutocapitalizationType.None
        self.passwordTxt.delegate = self
        self.passwordTxt.secureTextEntry = true
        self.passwordTxt.layer.cornerRadius = 3
        self.passwordTxt.backgroundColor = UIColor.lightGrayColor()
        self.scrollView.addSubview(self.passwordTxt)
        
        let confirmPasswordPlaceholder = NSAttributedString(string: NSLocalizedString("CONFIRM_PASSWORD",comment:"Confirm Password"), attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.confirmPasswordTxt.attributedPlaceholder = confirmPasswordPlaceholder
        self.confirmPasswordTxt.autocapitalizationType = UITextAutocapitalizationType.None
        self.confirmPasswordTxt.delegate = self
        self.confirmPasswordTxt.secureTextEntry = true
        self.confirmPasswordTxt.layer.cornerRadius = 3
        self.confirmPasswordTxt.backgroundColor = UIColor.lightGrayColor()
        self.scrollView.addSubview(self.confirmPasswordTxt)
        
        self.signUpBtn.setTitle(NSLocalizedString("SIGNUP",comment:"Sign Up"), forState:.Normal)
        self.signUpBtn.setTitleColor(UIColor.whiteColor(), forState:.Normal)
        self.signUpBtn.backgroundColor = UIColor().appSignUpButtonBgColor()
        self.signUpBtn.addTarget(self, action: "signUpButtonTapped", forControlEvents:.TouchUpInside)
        self.scrollView.addSubview(self.signUpBtn)
        
        
        if  arrUserObject.count != 0 {
            
            let userObject : User = arrUserObject.objectAtIndex(0) as! User

            self.title = NSLocalizedString("UPDATE",comment:"Update")
            self.firstNameTxt.text = userObject.first_name
            self.lastNameTxt.text = userObject.last_name
            self.emailTxt.text = userObject.email
            self.contactNo.text = NSString(format:"%@",userObject.contact_no) as String//userObject.contact_no as NSString
            self.userNameTxt.text = userObject.user_name
            self.passwordTxt.text = ""
            self.confirmPasswordTxt.text = ""
            self.signUpBtn.setTitle(NSLocalizedString("UPDATE",comment:"Update"), forState:.Normal)
        }
    }
    
    
    // MARK: - Text Field Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == firstNameTxt {
            animateCurrentViewUpAndDownSide(true, moveValue: 0)
        }else{
            animateCurrentViewUpAndDownSide(true, moveValue: 80)
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if textField == firstNameTxt {
            animateCurrentViewUpAndDownSide(false, moveValue: 0)
        }else{
            animateCurrentViewUpAndDownSide(false, moveValue: 80)
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    // MARK: - Sign up Api call method
    
    func signUpButtonTapped(){
        
        let parameters : NSDictionary = [   "user[first_name]" : firstNameTxt.text!, "user[last_name]" : lastNameTxt.text!,
            "user[email]" : emailTxt.text!, "user[contact_no]" : contactNo.text!,
            "user[user_name]": userNameTxt.text!, "user[password]": passwordTxt.text!,"user[password_confirmation]" : confirmPasswordTxt.text!,
            "auth_token" : self.auth_token[0]]
        
        if isEnteredDataBlankOrInValid(){
            
            if  arrUserObject.count != 0 {
                /* For User Update */
                
                self.startLoadingIndicatorView("Updating..")
                
                self.api.updateUser( parameters as [NSObject : AnyObject], success: { ( operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
                    
                    print(responseObject)
                    let dictResponse : NSDictionary = responseObject as! NSDictionary
                    let token : NSString = (dictResponse.objectForKey("data") as! NSDictionary).objectForKey("auth_token") as! NSString
                    self.auth_token = [token]
                    self.stopLoadingIndicatorView()
                    self.showSuccessAlertToUser("Your profile has been updated successfully.")

                    },
                    failure: { ( operation: AFHTTPRequestOperation?, error: NSError? ) in
                        print(error)
                        self.stopLoadingIndicatorView()
                        self.showAlertMsg("Updating !", message: "Profile updation have some error, please try again later.")
                })

            }else{
                /* For User Registration */
                
                self.startLoadingIndicatorView("Registering..")
                
                self.api.signUpUser( parameters as [NSObject : AnyObject], success: { ( operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
                    
                    print(responseObject)
                    let dictResponse : NSDictionary = responseObject as! NSDictionary
                    let token : NSString = (dictResponse.objectForKey("data") as! NSDictionary).objectForKey("auth_token") as! NSString
                    self.auth_token = [token]
                    self.stopLoadingIndicatorView()
                    self.showSuccessAlertToUser("Your are successfully registered on Rondogo.")
                    
                    },
                    failure: { ( operation: AFHTTPRequestOperation?, error: NSError? ) in
                        print(error)
                        self.stopLoadingIndicatorView()
                        self.showAlertMsg("Registering !", message: "Profile registration have some error, please try again later.")
                })
            }
        }
    }
    
    
    // MARK: - Common methods
    
    func isEnteredDataBlankOrInValid() -> Bool {
        
        var alertMessage : String = String()
        
        if firstNameTxt.text == "" {
            alertMessage = "First name can't be blank. \n"
        }else if lastNameTxt.text == "" {
            alertMessage = "Last name can't be blank. \n"
        }else if !CommonUtilities.isValidEmailAddress(emailTxt.text!) || emailTxt.text! == "" {
            alertMessage = "Please enter valid email address. \n"
        }else if contactNo.text == "" {
            alertMessage = "Contact no can't be blank. \n"
        }else if userNameTxt.text == "" {
            alertMessage = "User name can't be blank. \n"
        }else if passwordTxt.text == "" {
            alertMessage = "Password can't be blank. \n"
        }else if confirmPasswordTxt.text == "" {
            alertMessage = "Confirm password can't be blank. \n"
        }else if passwordTxt.text != confirmPasswordTxt.text{
            alertMessage = "Password and Confirm password dosen't match. \n"
        }else {
            return true
        }
        
        self.showAlertMsg("Register !", message: alertMessage)
        
        return false
    }
    
    func showSuccessAlertToUser(strMessage : NSString){
        
        let alert = UIAlertController(title: "Rondogo", message: strMessage as String, preferredStyle: UIAlertControllerStyle.Alert)
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

}

