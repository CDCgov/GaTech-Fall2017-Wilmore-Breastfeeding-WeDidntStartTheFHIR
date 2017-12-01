//
//  LoginViewController.swift
//  BreastFeedingSupport
//
//  Created by CHONG W GUO on 4/17/17.
//
// LOG IN PAGE, ONLY FOR UI THING, TO-BE-IMPLEMENTED WITH OWN USER ACCOUNT SYSTEM
//
import Foundation
import UIKit
//import SQLite
class LoginViewController: UIViewController {
    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var errorMSGLabel: UILabel!
    @IBOutlet weak var passwordLabel: UITextField!
    
    @IBAction func loginAction(_ sender: Any) {
    
        let fs = FileSystem()
        
        if(!fs.CanConnectToServer()){
            self.errorMSGLabel.text = "Server unreachable."
            return
        }
        
        // Logic for logging in should go here
        // Also change the error messages to conform to the standards of
        // login UI once the login system is in place.
        let userNameText = self.userNameLabel.text
        var isNumberOnly = false
        
        if(userNameText?.isEmpty)!{
            self.errorMSGLabel.text = "Please enter a username."
            return
        }
        
        // verify that the id is a number
        do{
            let idRegex = try NSRegularExpression.init(pattern: Utilities.REGEX_ID_NUMBER, options: [])
            let numMatches = idRegex.numberOfMatches(in: userNameText!, options: [], range: NSRange(location: 0, length: (userNameText?.count)!))
            if(numMatches > 0){
                isNumberOnly = true
            }
        }catch{
            // do nothing
        }
        
        if(!isNumberOnly){
            self.errorMSGLabel.text = "Please enter numbers only in Username."
            return
        }
        
        let loginID = "Patient/" + userNameLabel.text!
        Utilities.UpdatePatiendID(newPatientID: loginID)
        
        if(!fs.DoesPatientExistOnFhirServer()){
            self.errorMSGLabel.text = "Mother patient doesn't exist on FHIR Server."
            return
        }
        
        let patientIDComponents = Utilities.patientID.components(separatedBy: "/")
        
        fs.CreatePatientLogDirectory(patientID: patientIDComponents[1])
    
        self.CheckForHospitalData()
    
        self.UploadDailyBreastFeedingLogData()
    
        let questionnaireInfo = self.AlreadyAnsweredQuestionnaire()
    
            if(!questionnaireInfo.0 || questionnaireInfo.1 || !fs.DoesPatientExistOnFhirServer())
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "BFTabBarController")
                self.present(controller, animated: true, completion: nil)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "Questionnaire") as! QuestionnaireTabViewController
                
                controller.questionnaireID = questionnaireInfo.2
                controller.questionnaireLastDate = questionnaireInfo.3
                controller.milkPreviousAnswer = questionnaireInfo.4
                controller.stoolPreviousAnswer = questionnaireInfo.5
                
                self.present(controller, animated: true, completion: nil)
            }
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*************************************************************************************************
        #*    DEMO SECTION
        #*
        #*    The purpose of this is to create data for demoing. To change the the patient,
        #*    replace the family, given, and birthdate parameters in the "GetPatientIDFromFHIRServer"
        #*    with the patient you want to give data to.
        #*    Once the product is ready for release to the public, comment-out/remove this demo section.
        **************************************************************************************************/
        let fs = FileSystem()
        
        var id = fs.GetPatientIDFromFHIRServer(family: "Wellgood", given:"Maya", birthDate:"1976-01-01")
        
        print(id)
        
        if (id != nil){
            // Create test Breastfeeding Session Logs
            
            fs.CreatePatientLogDirectory(patientID: id!)
            
            let jsonString1 = JSONGenerator.GenerateBreastFeedingSessionLogJson(patientID: id!, date: "2017-10-30", startTime: "8:00 AM", stopTime: "8:30 AM", duration: "30 minute(s)", wetDiapers: "1")
            let jsonString2 = JSONGenerator.GenerateBreastFeedingSessionLogJson(patientID: id!, date: "2017-10-30", startTime: "9:30 AM", stopTime: "10:00 AM", duration: "30 minute(s)", wetDiapers: "1")
            let jsonString3 = JSONGenerator.GenerateBreastFeedingSessionLogJson(patientID: id!, date: "2017-10-30", startTime: "11:00 AM", stopTime: "11:30 AM", duration: "30 minute(s)", wetDiapers: "1")
            let jsonString4 = JSONGenerator.GenerateBreastFeedingSessionLogJson(patientID: id!, date: "2017-10-30", startTime: "12:30 PM", stopTime: "1:00 PM", duration: "30 minute(s)", wetDiapers: "0")
            let jsonString5 = JSONGenerator.GenerateBreastFeedingSessionLogJson(patientID: id!, date: "2017-10-30", startTime: "2:00 PM", stopTime: "2:30 PM", duration: "30 minute(s)", wetDiapers: "1")
            let jsonString6 = JSONGenerator.GenerateBreastFeedingSessionLogJson(patientID: id!, date: "2017-10-30", startTime: "3:30 PM", stopTime: "4:00 PM", duration: "30 minute(s)", wetDiapers: "1")
            let jsonString7 = JSONGenerator.GenerateBreastFeedingSessionLogJson(patientID: id!, date: "2017-10-30", startTime: "5:00 PM", stopTime: "5:30 PM", duration: "30 minute(s)", wetDiapers: "1")
            let jsonString8 = JSONGenerator.GenerateBreastFeedingSessionLogJson(patientID: id!, date: "2017-10-30", startTime: "6:30 PM", stopTime: "7:00 PM", duration: "30 minute(s)", wetDiapers: "0")
            
            fs.WriteJsonBreastfeedingLogToLibrary(jsonContent: jsonString1, fileName: "2017-10-30_08-30-00", id: id!)
            fs.WriteJsonBreastfeedingLogToLibrary(jsonContent: jsonString2, fileName: "2017-10-30_10-00-00", id: id!)
            fs.WriteJsonBreastfeedingLogToLibrary(jsonContent: jsonString3, fileName: "2017-10-30_11-30-00", id: id!)
            fs.WriteJsonBreastfeedingLogToLibrary(jsonContent: jsonString4, fileName: "2017-10-30_13-00-00", id: id!)
            fs.WriteJsonBreastfeedingLogToLibrary(jsonContent: jsonString5, fileName: "2017-10-30_14-30-00", id: id!)
            fs.WriteJsonBreastfeedingLogToLibrary(jsonContent: jsonString6, fileName: "2017-10-30_16-00-00", id: id!)
            fs.WriteJsonBreastfeedingLogToLibrary(jsonContent: jsonString7, fileName: "2017-10-30_17-30-00", id: id!)
            fs.WriteJsonBreastfeedingLogToLibrary(jsonContent: jsonString8, fileName: "2017-10-30_19-00-00", id: id!)
        
            // Remove the 'uploadInfo.json' file so that these json files get pushed.
            do{
                let jsonFilePath = fs.breastFeedingLogDir + "/" + id! + "/uploadInfo.json"
                try fs.fm.removeItem(atPath: jsonFilePath)
            } catch {
            
            }
        
        }
        /***************************************************************************************
        #*    END OF DEMO SECTION
        ****************************************************************************************/
   }
    
    // Return Info
    // Bool = If connection to FHIR server is successful
    // Bool = If the questionnaire has already been answered
    // String? = The testID
    // String? = The date of the test
    // Bool? = The answer to the milk come in question
    // Bool? = The answer to the stool color question
    func AlreadyAnsweredQuestionnaire() -> (Bool, Bool, String?, String?, Bool?, Bool?) {
        let fs = FileSystem()
        
        // Get Questionnaire and today's date information
        let dateFormatter = Utilities.GetDateFormatter()
        let questionInfo = fs.GetLastUploadDateAndDataOfQueestionnaire()
        
        // Test if the connection to server was successful
        if(questionInfo.0 == false){
            return (questionInfo.0, false, questionInfo.1, questionInfo.2, questionInfo.3, questionInfo.4)
        }
        
        // Test if the questions have already been answerd
        if(questionInfo.3 == true && questionInfo.4 == true){
            return (questionInfo.0, true, questionInfo.1, questionInfo.2, questionInfo.3, questionInfo.4)
        }
        
        // Test if there is a date, no date indicates that no questionnaire data is on server.
        if (questionInfo.2 == nil){
            return (questionInfo.0, false, questionInfo.1, questionInfo.2, questionInfo.3, questionInfo.4)
        }
        
        // Compare today's date with the last date
        let lastDate = dateFormatter.date(from: questionInfo.2!)
        let today = Date()
        if (Utilities.CompareDatesNoTime(date1: today, date2: lastDate!) == 1)
        {
            return (questionInfo.0, false, questionInfo.1, questionInfo.2, questionInfo.3, questionInfo.4)
        }
        
        // If everything fell through, then assume questions have already been asked.
        
        // DEBUG: Change the below line to test this functionality, else remove this line  and uncomment the actual code when finalizing the product
        // return (questionInfo.0, false, questionInfo.1, questionInfo.2, questionInfo.3, questionInfo.4)
        
        // Actual code: uncomment when building final project
         return (questionInfo.0, true, questionInfo.1, questionInfo.2, questionInfo.3, questionInfo.4)
    }
    
    func UploadDailyBreastFeedingLogData() -> () {
        let fs = FileSystem()
        var latestDataDate: Date? = nil
    
        // Gather session logs
        let bfLogs = fs.GetJsonBreastfeedingLogFilesFromLibrary()
        
        // Check to see if there are any BreastFeeding Session Data files
        if (bfLogs.count > 0)
        {
            var dataToUpload: [String:String] = [:]
            var dTodaysDate = Date()
            let timeKeeper = TimeKeeper()
            
            var wetDiapers: [String: [Int]] = [:]
            var durations: [String: [Double]] = [:]
            var lastUploadDate: Date
            var datesToProcess = [String]()
            
            if(!fs.DoesJsonUploadInfoFileExist()){
                let tempDate = "1970-01-01"
                lastUploadDate = Utilities.GetDateFormatter().date(from: tempDate)!
            } else {
                lastUploadDate = Utilities.GetDateFormatter().date(from: fs.GetLastUploadDateOfData()!)!
            }


            // Gather needed data from file for calculations
            for file in bfLogs{
            
                if (file == ".DS_Store" || file == "uploadInfo.json"){
                    continue
                }
            
                let sfileDate = file.components(separatedBy: "_")[0]
                let dfileDate = Utilities.GetDateFormatter().date(from: sfileDate)
                
                let result1 = Utilities.CompareDatesNoTime(date1: dfileDate!, date2: lastUploadDate)
                let result2 = Utilities.CompareDatesNoTime(date1: dfileDate!, date2: dTodaysDate)
                
                // If file is not the later date, then skip it
                if(result1 != 1 || result2 != 2){
                    continue
                }
                
                // If it's the latest data date so far, then grab it
                if (latestDataDate == nil || Utilities.CompareDatesNoTime(date1: dfileDate!, date2: latestDataDate!) == 1){
                    latestDataDate = dfileDate
                }

                do {
                
                    let id = Utilities.patientID.components(separatedBy: "/")[1]
        
                    // Create file path
                    let filePath = fs.breastFeedingLogDir + "/" + id + "/" + file
                    let jsonURL = try URL(fileURLWithPath: filePath)
                    let jsonData = try Data(contentsOf: jsonURL)
                    let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            
                    let sStart = json!["startTime"] as! String
                    let sStop = json!["stopTime"] as! String
                    let sDuration = json!["duration"] as! String
                    let diaperCount = json!["wetDiapers"] as! String
                    
                    let dStart = Utilities.GetTimeFormatter().date(from: sStart)
                    let dStop = Utilities.GetTimeFormatter().date(from: sStop)
                    
                    timeKeeper.AddStartTimeToDate(startTime: dStart!, date: sfileDate)
                    timeKeeper.AddEndTimeToDate(endTime: dStop!, date: sfileDate)

                    if(!durations.keys.contains(sfileDate)){
                        durations[sfileDate] = [Double]()
                    }
                    
                    if(!wetDiapers.keys.contains(sfileDate)){
                        wetDiapers[sfileDate] = [Int]()
                    }
                    wetDiapers[sfileDate]?.append(Int(diaperCount)!)
                    
                    durations[sfileDate]?.append(Utilities.ParseOutMinutes(sMinutes: sDuration))

                    if(!datesToProcess.contains(sfileDate))
                    {
                        datesToProcess.append(sfileDate)
                    }
                } catch {
                    print("Unable to extract data from '" + file + "': skipping file")
                    continue
                }
                
            }
            
            // If there is no data then don't upload
            if(datesToProcess.count < 1){
                return
            }
            
            // For each date that needs processing
            // - Calculate Needed Data
            for date in datesToProcess{
                let patientID = Utilities.patientID
                var _: String = date
                let numberOfFeedings: String = String(timeKeeper.GetStartTimesOfDate(date: date).count)
                
                let gaps: [Double] = timeKeeper.GetGapsOfDate(date: date)

                let dMedianGap = Utilities.MedianInDoubleArray(dArray: gaps)
                let dAverageLength = Utilities.AverageInDoubleArray(dArray: durations[date]!)
                let dMaximumGap = Utilities.MaxInDoubleArray(dArray: gaps)
                let dNumberOfwetDiapers = Utilities.SumIntArray(iArray: wetDiapers[date]!)

                if( dMedianGap == nil || dAverageLength == nil || dMaximumGap == nil || dNumberOfwetDiapers == nil)
                {
                    print ("FAILED TO UPLOAD BREASTFEEDING STATS: medianGap, averageLength, maximumGap, and/or numberOfwetDiapers were unable to be calculated.")
                    return
                }

                let medianGap: String = String(dMedianGap!) + " minute(s)"
                let averageLength: String = String(dAverageLength!) + " minute(s)"
                let maximumGap: String = String(dMaximumGap!) + " minute(s)"
                let numberOfwetDiapers: String = String(dNumberOfwetDiapers!)
                
                
                
                let jsonString = JSONGenerator.GenerateDailyLogJson(patientID: patientID, date: date, numberOfFeedings: numberOfFeedings, medianGap: medianGap, averageLength: averageLength, maximumGap: maximumGap, numberOfWetDiapers: numberOfwetDiapers)
                
                dataToUpload[date] = jsonString
            }
            
            let sLatestDatatDate = Utilities.GetDateFormatter().string(from: latestDataDate!)
            
            // - Upload the Data to server
            fs.UploadDailyJsonLogsToFHIRServer(jsonStringLogs: dataToUpload, serverURL: Utilities.QUESTIONNAIRE_RESPONSE_URL+"/", latestDate: sLatestDatatDate)

        }
    }
    
    func CheckForHospitalData() -> () {
        let fs = FileSystem()
        fs.DownloadEHRDataFromHospitalServer()        
    }
}

