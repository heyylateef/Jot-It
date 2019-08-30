//
//  ThirdViewController.swift
//  TaskForce
//
//  Created by Teef on 8/29/18.
//  Copyright © 2018 LateefA. All rights reserved.
//

import UIKit
import FirebaseDatabase

let date = Date()
let calendar = Calendar.current
let hour = calendar.component(.hour, from: date)
let minutes = calendar.component(.minute, from: date)
let seconds = calendar.component(.second, from: date)
var doneArray = [ReportModel]()
var doneReport: ReportModel!

class DetailViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var ref: DatabaseReference!                 // reference to the Firebase database
    var handle:DatabaseHandle!      // handle for Firebase Database
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var descField: UITextView!
    
    
    @IBAction func importImage(_ sender: Any) {
        let image =  UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true){
            //After it is complete
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage{
            myImageView.image = image
        }
        else{
            //Error
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
        titleLabel.text = ListArr[myIndex].Title     // reference to the list array made in FirstViewController
        descField.text = ListArr[myIndex].Description     // reference to the desc array made in FirstViewController
    
        
        ref = Database.database().reference().child("task")  // sets the variable "ref" to connect to our Firebase database, points to firebase child "task"
        
        ref.observe(.childAdded, with: { (snapshot) in                // Once view controller loads, it synchronizes data in Firebase with tableview
            //print(snapshot)
            guard let dictionary = snapshot.value as? [String : AnyObject]
                else {
                    return
            }
            
//            let Obj = ListModel()                                           // Reference to ListModel; adds title, description, and key from post to a dictionary and appends it a local array (ListArr) so users can read data from post
//            Obj.UID = snapshot.key
//            Obj.Title = dictionary["title"] as? String
//            Obj.Description = dictionary["description"] as? String
//            IDarray.append(snapshot.key)
//            ListArr.append(Obj)
//
//            self.myTableView.reloadData()
        }, withCancel: nil)
    }
        

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}
    // function that lets you add finished tasks to report
    @IBAction func addToReport(_ sender: Any) {
        creatCSV()
    }
    
    

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

// MARK: CSV file creating
func creatCSV() -> Void {   //function that creates a CSV
    let fileName = "Completed_Tasks.csv"
    let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
    var csvText = "Date,Task Name,Task Description,Time Started,Time Ended\n"
    
    doneReport = ReportModel()
    
    
    for _ in 0..<1 {
        doneReport.name = "\(ListArr[myIndex].Title!))"
        doneReport.explaination = "\(ListArr[myIndex].Description!)"
        doneReport.date = "\(Date())"
        doneReport.startTime = "Start *\(hour):\(minutes):\(seconds)"
        //doneReport.endTime = "End \(Date())"
        doneReport.endTime = "End *\(hour):\(minutes):\(seconds)"
        doneArray.append(doneReport!)
    }
    
    for doneReport in doneArray {
        let newLine = "\(doneReport.date),\(doneReport.name),\(doneReport.explaination),\(doneReport.startTime),\(doneReport.endTime)\n"
        csvText.append(newLine)
    }
    
    do {
        try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)  //Writes text to the actual CSV file
        let vc = UIActivityViewController(activityItems: [path!], applicationActivities: []) // Opens the ActivityViewer, so you can choose which app to export the CSV file to
        vc.present(vc, animated: true, completion: nil)
    }
    catch {
        print("Failed to create file")
        print("\(error)")
    }
    print(path ?? "not found")
}
