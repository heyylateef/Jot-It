//
//  LoginSignUp.swift
//  TaskForce
//
//  Created by Teef on 1/21/19.
//  Copyright © 2019 LateefA. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginSignUp: UIViewController {
   
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var actionButton: UIButton!
    @IBAction func action(_ sender: Any) {
    
        
        if emailText.text != "" && passwordText.text != ""  // Checks to see if both fields are not empty
        {
            if segmentControl.selectedSegmentIndex == 0 // Login tab selected
            {
                Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
                    if user != nil
                    {
                        //Login sucecssful
                        self.performSegue(withIdentifier: "LoginSegue", sender: self)
                    }
                    else
                    {
                        self.emailText.textColor = UIColor.red
                        self.passwordText.textColor = UIColor.red
                        self.emailText.shake()  //shakes emailTextField, indicating incorrect credentials
                        self.passwordText.shake()   //shakes passwordTextField, indicating incorrect credentials
                        
                        if let myError = error?.localizedDescription    // Uses firebase's built in error system to describe the error
                        {
                            print(myError)
                        }
                        else
                        {
                            print("ERROR")
                        }
                    }
                })
            }
            else    // Sign Up tab selected
            {
                actionButton.setTitle("Sign Up", for: .normal)
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!, completion:  { (user, error) in
                    if user != nil
                    {
                        //User Sign Up successful
                        self.performSegue(withIdentifier: "LoginSegue", sender: self)
                    }
                    else
                    {
                        if let myError = error?.localizedDescription    // Uses firebase's built in error system to describe the error
                        {
                            print(myError)
                        }
                        else
                        {
                            print("ERROR")
                        }
                    }
                }
            )}
        }
    }
    @IBAction func resetEmailButton(_ sender: Any) {
        forgotPassword(title: "Forgot Your Password?", message: "Enter your Email Address to Reset Your Password")
    }
    
    @objc func valueDidChange(segmentControl: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            actionButton.setTitle("Login", for: .normal)
        default:
            actionButton.setTitle("Sign Up", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControl.addTarget(self, action: #selector(valueDidChange(segmentControl:)), for: .valueChanged)
        
    }
    
    // Remembers the user's login. Will automatically sign in the use even if the user closes the app.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "LoginSegue", sender: self)
        }
    }
    
    func forgotPassword(title: String, message: String){
        let alert = UIAlertController(title: "Forgot Password?", message: "Enter Email to Reset Your Password", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField(configurationHandler: { (resetEmail : UITextField!) in       // Adds a textfield to the alert
            resetEmail.placeholder = "Enter Email Address"
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {   // Adds cancel button to alert; voids whatever has been inputted
            (action : UIAlertAction!) -> Void in })
        let resetAction = UIAlertAction(title: "Reset", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction! )  in // Adds reset button to alert; Sends the password reset email to whatever email the user typed in
            let resetEmail = alert.textFields![0] as UITextField
            
            if (resetEmail.text != ""){              // Checks to make sure resetEmail textfield isn't empty
                Auth.auth().sendPasswordReset(withEmail: resetEmail.text!, completion: { (error) in // resets password for inputted email
                    //Make sure you execute the following code on the main queue
                    DispatchQueue.main.async {
                        //Use "if let" to access the error, if it is non-nil
                        if let error = error {
                            let resetFailedAlert = UIAlertController(title: "Reset Failed", message: error.localizedDescription, preferredStyle: .alert)
                            resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(resetFailedAlert, animated: true, completion: nil)
                        } else {
                            let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                            resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(resetEmailSentAlert, animated: true, completion: nil)
                        }
                    }
                })
            }
        })
        alert.addAction(resetAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)        // Presents the alert on screen
    }
}

extension UITextField {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}
