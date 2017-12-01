//
//  FirstViewController.swift
//  BreastFeedingSupport
//
//  Created by CHONG W GUO on 3/15/17.
//
//the tab for recording breastfeeding data

import UIKit

class FirstViewController: UITableViewController {
    //variables for stop watch component
    var startTimeGlobal = Date()
    var stopTimeGlobal = Date()
    var durationGlobal = ""
    var timer2 = Timer()
    var startTime = TimeInterval()
    var started = false
    
    //data holder
    var bfld : BreastfeedingLogData = BreastfeedingLogData()
    
    let patientID : String = Utilities.patientID

    
    var canSubmit = false
    
    //variables for alerts
    var alertController: UIAlertController?
    var alertTimer: Timer?
    var remainingTime = 0
    var baseMessage: String?

//check if can submit, and parse data to json and post it to fhir server
    @IBAction func submitButtonAction(_ sender: Any) {
        
        if(canSubmit){
            bfld.patientID = patientID
            bfld.diaperCount = diaperCount.text!
            
            let jsonString = JSONGenerator.GenerateBreastFeedingSessionLogJson(patientID: bfld.patientID, date: bfld.sDate, startTime: bfld.sStart, stopTime: bfld.sStop, duration: bfld.sDuration, wetDiapers: bfld.diaperCount)
            
            let fs = FileSystem()
            
            // Generate name
            let dateCreated = Date()
            let sDateCreated = Utilities.GetDateFormatter().string(from: dateCreated)
            let sTimeCreated = Utilities.GetTimeFormatterMTime().string(from: dateCreated)
            let fileName = sDateCreated + "_" + sTimeCreated
            
            // Get logged in patient ID
            let patientIDComponents = Utilities.patientID.split(separator: "/")
            let id = patientIDComponents[1]
            
            let writeSuccessful = fs.WriteJsonBreastfeedingLogToLibrary(jsonContent: jsonString, fileName: fileName, id: String(id))

            if(writeSuccessful){
                self.showAlertMsg("Result",message: "Succesfully recorded data", time: 5)
                self.resetRecordData()
            }
            else {
                self.showAlertMsg("Result",message: "Failed to record data", time: 5)
            }
            
        }
    }

    // Resets the data
    private func resetRecordData(){
        // Reset the diaper counter
            diaperStepper.value = 0.0
            diaperCount.text = "0"
        
            timer.text = "00:00"
        
            startTimeDetail.text = " "
            stopTimeDetail.text = " "
        
            durationDetail.text = " "

            canSubmit = false
    }

    @IBOutlet weak var timer: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
//stop watch component, set start time when start button is pressed
    @IBAction func startButtonAction(_ sender: Any) {
        if !timer2.isValid {
            started = true
            let aSelector : Selector = #selector(FirstViewController.updateTime)
            timer2 = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate
            startTimeGlobal = Date()
            let formatter = Utilities.GetTimeFormatter()
            let startTimeString = formatter.string(from: startTimeGlobal)
            startTimeDetail.text = startTimeString
            bfld.sStart = startTimeString
            canSubmit = false
            submitButtonOutlet.isEnabled = false
        }
    }
    
//stop watch component, set stop time when start button is pressed
    @IBAction func stopButtonAction(_ sender: Any) {
        if started {
            started = false
            timer2.invalidate()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            
            // let startTimeString = formatter.string(from: startTimeGlobal)
            stopTimeGlobal = Date()
            let stopTimeString = formatter.string(from: stopTimeGlobal)
            
            //startTimeDetail.text = startTimeString
            stopTimeDetail.text = stopTimeString
            bfld.sStop = stopTimeString
            let interval = stopTimeGlobal.timeIntervalSince(startTimeGlobal)
            let minutes = UInt8(interval / 60.0)
            let durationString = String(format: "%02d", minutes)
            durationGlobal = durationString
            durationDetail.text = durationString + " minute(s)"
            bfld.sDuration = durationString + " minute(s)"
            //let seconds = calendar.component(.second, from: date)
            //print("hours = \(hour):\(minutes):\(seconds)")
            canSubmit = true
            submitButtonOutlet.isEnabled = true
        }
    }

//stop watch component, update the stop watch timer
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        
        var elapsedTime: TimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        
        //   let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        // let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        // timer.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        timer.text = "\(strMinutes):\(strSeconds)"
        
        
    }
    

    
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
    
//alert after submit button is pressed
    func showAlertMsg(_ title: String, message: String, time: Int) {
        
        guard (self.alertController == nil) else {
            print("Alert already displayed")
            return
        }
        
        self.baseMessage = message
        self.remainingTime = time
        
        self.alertController = UIAlertController(title: title, message: self.baseMessage, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
            print("Alert was cancelled")
            self.alertController=nil;
            self.alertTimer?.invalidate()
            self.alertTimer=nil
        }
        
        self.alertController!.addAction(cancelAction)
        
        self.alertTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
        
        self.present(self.alertController!, animated: true, completion: nil)
    }
    
    func countDown() {
        
        self.remainingTime -= 1
        if (self.remainingTime < 0) {
            self.alertTimer?.invalidate()
            self.alertTimer = nil
            self.alertController!.dismiss(animated: true, completion: {
                self.alertController = nil
            })
        } else {
            self.alertController!.message = self.alertMessage()
        }
        
    }
    
    func alertMessage() -> String {
        var message=""
        if let baseMessage=self.baseMessage {
            message=baseMessage+" "
        }
        return(message+"\(self.remainingTime)")
    }
    
    
    @IBOutlet weak var diaperStepper: UIStepper!
    @IBOutlet weak var diaperCount: UILabel!
    
    @IBAction func diaperStepperChanged(_ sender: UIStepper){
        diaperCount.text = Int(sender.value).description
    }
    
    @IBOutlet weak var dateDetail: UILabel!
    @IBOutlet weak var startTimeDetail: UILabel!
    @IBOutlet weak var stopTimeDetail: UILabel!
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var durationDetail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        let date = Date()
        let formatter = Utilities.GetDateFormatter()

        let result = formatter.string(from: date)
        //  Set your label:
        
        dateDetail.text = result
        bfld.sDate = result
        submitButtonOutlet.isEnabled = false
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
