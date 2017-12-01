//
//  SecondViewController.swift
//  BreastFeedingSupport
//
//  Created by CHONG W GUO on 3/15/17.
//
// the class for data log tab

import UIKit

class SecondViewController: UITableViewController {
    let patientID = Utilities.patientID
    var bflData: [BreastfeedingLogData] = [] {
        didSet {
          tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()
        
        let when = DispatchTime.now() + 0.5 //delay reloading data
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.tableView.reloadData()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.refreshControl?.addTarget(self, action: #selector(SecondViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged) // refresh control
        
    }
    //refresh control
    func handleRefresh(_ refreshControl: UIRefreshControl) {
 
        updateTable()
        refreshControl.endRefreshing()
    }
    
    //update table
    func updateTable(){
        bflData = []
        
        let fs = FileSystem()
        
        let bfldFiles = fs.GetJsonBreastfeedingLogFilesFromLibrary().sorted(by: >)
        
        do {
            let id = Utilities.patientID.components(separatedBy: "/")[1]
            for file in bfldFiles{
            
                if (file == ".DS_Store" || file == "uploadInfo.json"){
                    continue
                }
            
                // Create file path
                let filePath = fs.breastFeedingLogDir + "/" + id + "/" + file
            
                let jsonURL = try URL(fileURLWithPath: filePath)
                let jsonData = try Data(contentsOf: jsonURL)
            
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]

                let bfld : BreastfeedingLogData = BreastfeedingLogData()
                bfld.patientID = json!["patientID"] as! String
                bfld.sDate = json!["date"] as! String
                bfld.sStart = json!["startTime"] as! String
                bfld.sStop = json!["stopTime"] as! String
                bfld.sDuration = json!["duration"] as! String
                bfld.diaperCount = json!["wetDiapers"] as! String
                self.bflData.append(bfld)
            }
        } catch {
            print("Unable to gather log data for log display")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        return bflData.count
    }
    
    // generating log table cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "logTableCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! logTableCell
        cell.dataLabel?.text = self.bflData[indexPath.row].sDate
        cell.startLabel?.text = self.bflData[indexPath.row].sStart
        cell.stopLabel?.text = self.bflData[indexPath.row].sStop
        cell.durationLabel?.text = self.bflData[indexPath.row].sDuration
        cell.diaperLabel?.text = self.bflData[indexPath.row].diaperCount
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    } 
}

