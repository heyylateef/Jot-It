//
//  ReportDetailController.swift
//  TaskForce
//
//  Created by Teef on 9/6/18.
//  Copyright © 2018 LateefA. All rights reserved.
//

import UIKit

//let date = Date()
//let calendar = Calendar.current
//let hour = calendar.component(.hour, from: date)
//let minutes = calendar.component(.minute, from: date)
//let seconds = calendar.component(.second, from: date)
//var doneArray = [ReportModel]()
//var doneReport: ReportModel!

class ReportDetailController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var reportImageView: UIImageView!
    @IBOutlet weak var reportDescField: UITextView!
    @IBAction func emailButton(_ sender: Any) {
        creatCSV()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        reportLabel.text = reportList[myReportIndex]     // reference to the list array made in ReportViewController
        reportDescField.text = reportDesc[myReportIndex]      // reference to the desc array made in ReportViewController
        
    }
    
//    // MARK: CSV file creating
//    func creatCSV() -> Void {   //function that creates a CSV
//        let fileName = "Completed_Tasks.csv"
//        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
//        var csvText = "Date,Task Name,Task Description,Time Started,Time Ended\n"
//        
//        doneReport = ReportModel()
//        
//        
//        for _ in 0..<1 {
//            doneReport.name = "\(reportList[myReportIndex])"
//            doneReport.explaination = "\(reportDesc[myReportIndex])"
//            doneReport.date = "\(Date())"
//            doneReport.startTime = "Start *\(hour):\(minutes):\(seconds)"
//            //doneReport.endTime = "End \(Date())"
//            doneReport.endTime = "End *\(hour):\(minutes):\(seconds)"
//            doneArray.append(doneReport!)
//        }
//        
//        for doneReport in doneArray {
//            let newLine = "\(doneReport.date),\(doneReport.name),\(doneReport.explaination),\(doneReport.startTime),\(doneReport.endTime)\n"
//            csvText.append(newLine)
//        }
//        
//        do {
//            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)  //Writes text to the actual CSV file
//            let vc = UIActivityViewController(activityItems: [path!], applicationActivities: []) // Opens the ActivityViewer, so you can choose which app to export the CSV file to
//            present(vc, animated: true, completion: nil)
//        }
//        catch {
//            print("Failed to create file")
//            print("\(error)")
//        }
//        print(path ?? "not found")
//    }
    
}
