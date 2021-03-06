//
//  SignUpVC.swift
//  Blip
//
//  Created by Gbenga Ayobami on 2018-03-07.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Firebase
import Material
import PopupDialog

class SignUpVC: UIViewController {

    @IBOutlet weak var firstNameTF: TextField!
    @IBOutlet weak var lastNameTF: TextField!
    @IBOutlet weak var emailTF: TextField!
    @IBOutlet weak var passwordTF: TextField!
    @IBOutlet weak var confirmPasswordTF: TextField!
    @IBOutlet weak var phoneNumberTF: TextField!
    @IBOutlet weak var signUpButton: UIButton!
    //Singleton Service call instance
    let service = ServiceCalls.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
        signUpButton.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func signUpPressed(){
        //Checking if the text fields are empty
        let empty = (firstNameTF.text?.isEmpty)! || (lastNameTF.text?.isEmpty)! || (emailTF.text?.isEmpty)! || (passwordTF.text?.isEmpty)! || (confirmPasswordTF.text?.isEmpty)! 
        
        if !(empty){
            //All textfields are filled
            service.createUser(email: emailTF.text!, password: passwordTF.text!, completion: { (errMsg, user) in
                if errMsg != nil{
                    //Some type of error occured while creating user
                    print(errMsg!)
                }else{
                    //Created User successfully
                    //Add to Firebase Database if user has verified email
                    let emailVerifyPopup = self.prepareEmailVerifyPopup(user: user as! User)
                    self.present(emailVerifyPopup, animated: true, completion: nil)
                }
            })
        }else{
            // One or more of the textfields are empty
            // Let User know they have to empty fields to fill up
            return
        }
    }
    
    func prepareTextFields(){
        
        self.emailTF.placeholderLabel.font = UIFont(name: "CenturyGothic", size: 17)
        self.emailTF.font = UIFont(name: "CenturyGothic", size: 17)
        self.emailTF.textColor = Color.white
        self.emailTF.placeholder = "Email"
        self.emailTF.placeholderActiveColor = Color.white
        self.emailTF.placeholderNormalColor = Color.white
        self.passwordTF.placeholderLabel.font = UIFont(name: "CenturyGothic", size: 17)
        self.passwordTF.font = UIFont(name: "CenturyGothic", size: 17)
        self.passwordTF.textColor = Color.white
        self.passwordTF.placeholder = "Password"
        self.passwordTF.placeholderActiveColor = Color.white
        self.passwordTF.placeholderNormalColor = Color.white
        self.firstNameTF.placeholderLabel.font = UIFont(name: "CenturyGothic", size: 17)
        self.firstNameTF.font = UIFont(name: "CenturyGothic", size: 17)
        self.firstNameTF.textColor = Color.white
        self.firstNameTF.placeholder = "First Name"
        self.firstNameTF.placeholderActiveColor = Color.white
        self.firstNameTF.placeholderNormalColor = Color.white
        self.lastNameTF.placeholderLabel.font = UIFont(name: "CenturyGothic", size: 17)
        self.lastNameTF.font = UIFont(name: "CenturyGothic", size: 17)
        self.lastNameTF.textColor = Color.white
        self.lastNameTF.placeholder = "Last Name"
        self.lastNameTF.placeholderActiveColor = Color.white
        self.lastNameTF.placeholderNormalColor = Color.white
        self.confirmPasswordTF.placeholderLabel.font = UIFont(name: "CenturyGothic", size: 17)
        self.confirmPasswordTF.font = UIFont(name: "CenturyGothic", size: 17)
        self.confirmPasswordTF.textColor = Color.white
        self.confirmPasswordTF.placeholder = "Confirm Password"
        self.confirmPasswordTF.placeholderActiveColor = Color.white
        self.confirmPasswordTF.placeholderNormalColor = Color.white
    }
    
    func prepareEmailVerifyPopup(user: User) -> PopupDialog{
        let title = "Verify your email"
        let message = "Please check your email for a verification link, then press continue after verifying"
        let emailVerifyPopup = PopupDialog(title: title, message: message)
        //Resend verification email
        let resendButton = DefaultButton(title: "Resend verification Email", dismissOnTap: false) {
            user.sendEmailVerification(completion: { (error) in
                if error != nil{
                    print(error!.localizedDescription)
                    return
                }
            })
        }
        
        let continueButton = DefaultButton(title: "Continue", dismissOnTap: false){
            user.reload(completion: { (err) in
                if let error = err{
                    print(error.localizedDescription)
                    return
                }
                if user.isEmailVerified{
                    emailVerifyPopup.dismiss()
                   
                    //trying to setup profile name
                    let profile = user.createProfileChangeRequest()
                    profile.displayName = "\(self.firstNameTF.text!) \(self.lastNameTF.text!)"
                    profile.commitChanges(completion: { (error2) in
                        if (error2 != nil){
                            print(error2!.localizedDescription)
                            return
                        }
                        else{
                            //Successfully committed profile changes
                            //Add to firebase database
                            self.service.addUserToDB(firstName: self.firstNameTF.text!, lastName: self.lastNameTF.text!, email: self.emailTF.text!, phoneNumber: self.phoneNumberTF.text!)
                        }
                    })
                }
                else{   // if user has not verified email
                    emailVerifyPopup.shake()
                }
            })
        }
        emailVerifyPopup.addButtons([continueButton, resendButton])
        return emailVerifyPopup
    }
    

}
