//
//  FirstViewController.swift
//  TaskForce
//
//  Created by Teef on 8/29/18.
//  Copyright © 2018 LateefA. All rights reserved.
//

import UIKit
import FirebaseDatabase
import GoogleMobileAds
import FirebaseAuth

var ref: DatabaseReference!     // reference to the Firebase database
var Obj : ListModel?
var ListArr = [ListModel]()
var IDarray : [String] = []
var myIndex = 0
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, GADBannerViewDelegate {
    
    //******THIS IS THE TABLEVIEWCONTROLLER******
    @IBOutlet weak var myTableView: UITableView!    // link to tableview item in storyboard
    
    
    @IBOutlet weak var myBannerAd: GADBannerView!
    
    //required function when using tableview; wants to know how many cells to produce (takes template from prototype cell in storyboard)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (ListArr.count)
    }
    
    // required function when using tableview; actual link to each cell from storyboard
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = ListArr[indexPath.row].Title
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor(red: CGFloat(27/255.0), green: CGFloat(35/255.0), blue: CGFloat(67/255.0), alpha: CGFloat(1/255.0))  //changes background color of tableview to RGBA value (27,35,67,1)
        return (cell)
    }
    
    //function allows you to swipe left to delete an entry(cell)
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == UITableViewCell.EditingStyle.delete
        {
            ref?.child(IDarray[indexPath.row]).setValue(nil)    //Removes the post entry on Firebase(based on the given indexPath) using the key saved in IDarray
            ListArr.remove(at: indexPath.row)                   //Removes the post from local array (ListArr) based on the given indexPath
            self.myTableView.reloadData()
        }
    }
     override func viewDidLoad() {//change "viewDidLoad()" back to "viewDidAppear()"
        super.viewDidLoad()
//        let connectAlert = UIAlertController(title: "", message: "Connecting to your task list", preferredStyle: UIAlertController.Style.alert) // alert that presents itself when viewcontroller loads and is connecting to Firebase
//        self.present(connectAlert, animated: true, completion: nil)        // Presents the alert on screen
    
        //Request Ads
       let request = GADRequest()
       //request.testDevices = [kGADSimulatorID]
       
        //Setup the Ad
        myBannerAd.adUnitID = "ca-app-pub-8795101413319517/7816150078"
        
        myBannerAd.rootViewController = self
        myBannerAd.delegate = self
        
        //Load the Ad
        myBannerAd.load(request)
        
        let uid = Auth.auth().currentUser?.uid          //gets current logged in user's unique user ID
        
        
        ref = Database.database().reference().child("task").child(uid!)  // sets the variable "ref" to connect to our Firebase database, points to firebase child "task" child "uid"; separates everyone's node by their own uid
        ref.observe(.childAdded, with: { (snapshot) in                // Once view controller loads, it synchronizes data in Firebase with tableview
            print(snapshot)
            guard let dictionary = snapshot.value as? [String : AnyObject]
                else {
                    return
            }
//            connectAlert.dismiss(animated: true, completion: nil)   // Dismisses connectAlert once connection to Firebase is established
            
            let Obj = ListModel()                                           // Reference to ListModel; adds title, description, and key from post to a dictionary and appends it a local array (ListArr) so users can read data from post
            Obj.UID = snapshot.key
            Obj.Title = dictionary["title"] as? String
            Obj.Description = dictionary["description"] as? String
            IDarray.append(snapshot.key)
            ListArr.append(Obj)
            
            self.myTableView.reloadData()
        }, withCancel: nil)
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "detailsegue", sender: self)
    }

    
    
    @IBAction func quickAdd(_ sender: UIButton) // Link to add button on FirstViewController
    {
        uploadToFirebase(title: "Post the task?", message: "Enter a title and description for your task")
    }
    
    func uploadToFirebase (title: String, message: String)
    {
        let alert = UIAlertController(title: "Enter Details for Your Post", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField(configurationHandler: { (titleField : UITextField!) in       // Adds a textfield to the alert
            titleField.placeholder = "Enter item"
        })
        alert.addTextField(configurationHandler: { (descField : UITextField!) in        // Adds a textfield to the alert
            descField.placeholder = "Enter Description"
        })
       
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {   // Adds cancel button to alert; voids whatever has been inputted
            (action : UIAlertAction!) -> Void in })
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction! )  in // Adds save button to alert; saves the tasks to Firebase if clicked
            let titleField = alert.textFields![0] as UITextField
            let descField = alert.textFields![1] as UITextField
            if (titleField.text != "")              // Checks to make sure titleField isn't empty
            {
                if (descField.text != "")           // Checks to make sure descField isn't empty
                {
                    let key = ref?.childByAutoId().key
                    let post = ["uid": key,                             // Gets auto generated ID for database entry
                        "title": titleField.text,                    // Saves the title field to Firebase
                        "description": descField.text]         // Saves the description field to Firebase
                    
                    ref?.child(key!).setValue(post)      // Saves the task for Firebase, ties each post with a unique ID
                    //ref?.child(uid!).setValue(post)
                }
            }
        })
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)        // Presents the alert on screen
    }

    
}


