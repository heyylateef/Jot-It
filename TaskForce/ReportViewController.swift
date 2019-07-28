//
//  ReportViewController.swift
//  TaskForce
//
//  Created by Teef on 9/4/18.
//  Copyright © 2018 LateefA. All rights reserved.
//

import UIKit
import MessageUI

var reportList : [String] = []   //global list, set outside any class so it can be global (globaal, as in can be accessed from other view controllers
var reportDesc : [String] = []
var myReportIndex = 0


class ReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var myReportView: UITableView!
    
    //******THIS IS THE REPORT TABLEVIEWCONTROLLER******
    // link to tableview item in storyboard
    
    //required function when using tableview; wants to know how many cells to produce (takes template from prototype cell in storyboard)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return(reportList.count)
    }
    
    // required function when using tableview; actual link to each cell from storyboard
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let reportCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "reportCell")
        reportCell.textLabel?.text = reportList[indexPath.row]
        reportCell.textLabel?.textColor = UIColor.white
        reportCell.backgroundColor = UIColor(red: CGFloat(27/255.0), green: CGFloat(35/255.0), blue: CGFloat(67/255.0), alpha: CGFloat(1/255.0))  //changes background color of tableview to RGBA value (27,35,67,1)
        return (reportCell)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidLoad()
       
        
        myReportView.reloadData()
        
    }
    
//    // MARK: CSV file creating
//    func creatCSV() -> Void {   //function that creates a CSV
//        let fileName = "Completed_Tasks.csv"
//        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
//        var csvText = "Date,Task Name,Task Description,Time Started,Time Ended\n"
//
//        doneReport = ReportModel()
//        var indexingCount = 0
//        for _ in reportList {
//            doneReport.name = "\(reportList[indexingCount])"
//            doneReport.explaination = "\(reportDesc[indexingCount])"
//            doneReport.date = "\(Date())"
//            doneReport.startTime = "Start \(Date())"
//            doneReport.endTime = "End \(Date())"
//            doneArray.append(doneReport!)
//            indexingCount = indexingCount + 1
//        }
//        
//        for doneReport in doneArray {
//            let newLine = "\(doneReport.date),\(doneReport.name),\(doneReport.explaination),\(doneReport.startTime),\(doneReport.endTime)\n"
//            csvText.append(newLine)
//        }
//
//        do {
//            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)  //Writes text to the actual CSV file
//            let vc = UIActivityViewController(activityItems: [path], applicationActivities: []) // Opens the ActivityViewer, so you can choose which app to export the CSV file to
//            present(vc, animated: true, completion: nil)
//        }
//        catch {
//            print("Failed to create file")
//            print("\(error)")
//        }
//        print(path ?? "not found")
//    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myReportIndex = indexPath.row
        performSegue(withIdentifier: "reportSegue", sender: self)
    }

}
