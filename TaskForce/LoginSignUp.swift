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
    
//    func switchButtonTitle(){
//        if segmentControl.selectedSegmentIndex == 0 // Login tab selected
//        {
//            actionButton.setTitle("Login", for: .normal)
//        }
//        else
//        {
//            actionButton.setTitle("Sign Up", for: .normal)
//        }
//    }
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
