//
//  SecondViewController.swift
//  TaskForce
//
//  Created by Teef on 8/29/18.
//  Copyright © 2018 LateefA. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Social
import GoogleMobileAds

class MenuViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var myBannerAd: GADBannerView!
    
    @IBAction func logOut(_ sender: UIButton) {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "LogOutSegue", sender: self)
        ListArr.removeAll() //clears local array for populating tableview data
    }
    //Social Media Sharing
    @IBAction func shareButton(_ sender: Any) {
        let alert = UIAlertController(title: "Share", message: "Share to social media", preferredStyle: .actionSheet)
        
        //Facebook
        let shareFacebook = UIAlertAction(title: "Share on Facebook", style: .default, handler: {(action) in
                
                let appName = "Facebook"
                let appScheme = ("\(appName)")
                let appSchemeURL = URL(string: appScheme)
                
                if UIApplication.shared.canOpenURL(appSchemeURL! as URL){
                    UIApplication.shared.open(appSchemeURL!, options: [:], completionHandler: nil)
                }
            else{
                self.showAlert(service:"Facebook")
                }
        })
            //Twitter
        let shareTwitter = UIAlertAction(title: "Share on Twitter", style: .default, handler: {(action) in

                let appName = "Twitter"
                let appScheme = ("\(appName)://")
                let appSchemeURL = URL(string: appScheme)
                
                if UIApplication.shared.canOpenURL(appSchemeURL! as URL){
                    UIApplication.shared.open(appSchemeURL!, options: [:], completionHandler: nil)
                }
            else{
                self.showAlert(service:"Twitter")
                }
        })
        
        alert.addAction(shareFacebook)
        alert.addAction(shareTwitter)
        
        self.present(alert, animated: true, completion: nil)
    }
    //Alert for showing error for Share button
    func showAlert(service:String){
        let alert = UIAlertController(title: "Error", message: "\(service) is not installed on this device", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Request Ads
        let request = GADRequest()
        //request.testDevices = [kGADSimulatorID]
        
        //Setup the Ad
        myBannerAd.adUnitID = "ca-app-pub-8795101413319517/1626146240"
        
        myBannerAd.rootViewController = self
        myBannerAd.delegate = self
        
        //Load the Ad
        myBannerAd.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

