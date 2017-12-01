//
//  FileSystem.swift
//  BreastFeedingSupport
//
//  Created by Justin Kristensen on 11/2/17.
//

import Foundation

class FileSystem {

    var breastFeedingLogDir: String
    var uploadInfoFileName: String
    var hospitalDataDir: String
    var fm: FileManager
    
    let patientID : String = Utilities.patientID

    init() {
        // Generate the file paths
        let libraryDirPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        
        self.breastFeedingLogDir = libraryDirPath + "/breastFeedingLogs"
        self.hospitalDataDir = libraryDirPath + "/hospitalData"
        self.uploadInfoFileName = "uploadInfo.json"
        
        self.fm = FileManager()
        
        // If the file structure hasn't been created then create it
        var isDir : ObjCBool = true
        if(!self.fm.fileExists(atPath: self.breastFeedingLogDir, isDirectory: &isDir)){
            do{
                try self.fm.createDirectory(atPath: self.breastFeedingLogDir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                // do nothing
            }
        }
        
        if(!self.fm.fileExists(atPath: self.hospitalDataDir, isDirectory: &isDir)){
            do{
                try self.fm.createDirectory(atPath: self.hospitalDataDir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                // do nothing
            }
        }
        
        print(libraryDirPath)
    }
    
    // Writes the JSON Breastfeeding content to a FilePath in the directory
    func WriteJsonBreastfeedingLogToLibrary(jsonContent: String, fileName: String, id: String) -> Bool {
        // Create file path
        let jsonFilePath = self.breastFeedingLogDir + "/" + id + "/" + fileName + ".json"
        let fileURL = URL(fileURLWithPath: jsonFilePath)
        
        // Write file
        do{
            try jsonContent.write(to:fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Unable to write '" + fileName + "' to breastfeeding log dir.")
            return false
        }
        return true
    }
    
    // Writes the JSON content to the sytemInfoDirectory.json
    private func WriteJsonToUploadInfoFile(jsonContent: String) -> Bool {
        
        let id = Utilities.patientID.components(separatedBy: "/")[1]
        
        // Create file path
        let fileURL = URL(fileURLWithPath: self.breastFeedingLogDir + "/" + id + "/" + self.uploadInfoFileName)
        
        // Write file
        do{
            try jsonContent.write(to:fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Unable to write to systemInfo file.")
            return false
        }
        return true
    }
    
    // Writes the JSON content to the hospitalData.json
    func WriteJsonToHospitalDataDirectory(jsonContent: String, fileName: String) -> Bool {
        
        // Create file path
        let jsonFilePath = self.hospitalDataDir + "/" + fileName + ".json"
        let fileURL = URL(fileURLWithPath: jsonFilePath)
        
        // Write file
        do{
            try jsonContent.write(to:fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Unable to write '" + fileName + "' to hospitalData dir.")
            return false
        }
        return true
    }
    
    // Create Patient Log Directory
    func CreatePatientLogDirectory(patientID: String) -> Bool {
        do{
            let newDirPath = self.breastFeedingLogDir + "/" + patientID
            
            var isDir : ObjCBool = true
            if(self.fm.fileExists(atPath: newDirPath, isDirectory: &isDir)){
                return true
            } else {
                try self.fm.createDirectory(atPath: newDirPath, withIntermediateDirectories: true, attributes: nil)
            }
            
        }catch{
            return false
        }
        return true
    }
    
    // Delete files in folder
    func DeleteAllFilesInDirectory(dirPath: String) -> Bool {
        
        do{
            let allFiles = try self.fm.contentsOfDirectory(atPath: dirPath)
            for file in allFiles{
                let pathToFile = dirPath + "/" + file
                try fm.removeItem(atPath: pathToFile)
            }
        
        }catch{
            return false
        }
        let dirURL = URL(fileURLWithPath: dirPath)
        
        return true
    }
    
    // Returns a list of JSON files in a particular folder location
    func GetJsonBreastfeedingLogFilesFromLibrary() -> Array<String> {
        var jsonFiles = [String]()
        let id = Utilities.patientID.components(separatedBy: "/")[1]
        let logDir = self.breastFeedingLogDir + "/" + id
        
        do{
            jsonFiles = try self.fm.contentsOfDirectory(atPath: logDir)
        } catch {
            print("Unable to get files from library.")
        }
        
        return jsonFiles
    }
    
    // Returns path to the systeminfo.json file if it exists
    func DoesJsonUploadInfoFileExist() -> Bool {
        var isDir : ObjCBool = false
        let id = Utilities.patientID.components(separatedBy: "/")[1]
        let dirPath = self.breastFeedingLogDir + "/" + id + "/" + self.uploadInfoFileName
        return self.fm.fileExists(atPath: dirPath, isDirectory: &isDir)
    }
    
    // Returns path to the systeminfo.json file if it exists
    func DoesHospitalDataDirectoryExist() -> Bool {
        var isDir : ObjCBool = true
        return self.fm.fileExists(atPath: self.hospitalDataDir, isDirectory: &isDir)
    }
    
    func DoesFileExistInHospitalDataDirectory(fileName:String) -> Bool {
        var isDir : ObjCBool = false
        let path = self.hospitalDataDir + "/" + fileName + ".json"
        return self.fm.fileExists(atPath: path, isDirectory: &isDir)
    }
    
    // updates the SystemInfo file
    func UpdateUploadInfoFile(dataLastUpload : String) -> Bool {
        let jsonText = JSONGenerator.GenerateSystemInfoJson(dataLastUpload: dataLastUpload)
        return self.WriteJsonToUploadInfoFile(jsonContent: jsonText)
    }
    
    // gets the last upload date of the questionnaire from the server
    // process it and returns the data of the latest questionnaire
    //
    // Return Info
    // Bool = If connection was succesful
    // String? = The testID
    // String? = The date of the test upload
    // Bool? = The answer to the milk come in question
    // Bool? = The answer to the stool color question
    func GetLastUploadDateAndDataOfQueestionnaire() -> (Bool, String?, String?, Bool?, Bool?) {

        let url = URL(string: Utilities.GetQuestionnaireResponseSourceSearchURL(sPatientID: self.patientID))! //restful api GET the resource with specific patientID
        
        var connectionSuccessful = true
        var testID : String? = nil
        var latestDate : Date? = nil
        var stoolAnswer : Bool? = nil
        var milkAnswer : Bool? = nil
        
        // pull data from fhir and get the latest
        do {
            let data = NSData(contentsOf: url)
            
            if (data == nil){
                print ("Unable to connect to server '" + url.absoluteString + "'.")
                connectionSuccessful = false
                return (connectionSuccessful, testID, nil, stoolAnswer, milkAnswer)
            }
                    
            if let json = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? [String: Any]
            {
                        
                var count = 0
                count = json["total"] as! Int
                        
                if(count>0){
                           
                    // parse json data from fhir into BreastfeedingData
                    let responseEntry : NSArray = json["entry"] as! NSArray
                            
                    for response in responseEntry {
                        
                        let d2 = (response as! NSDictionary)["resource"] as! NSDictionary
                        let d3 = d2["item"] as! NSArray
                        
                        
                        let qType = (d3[0] as! NSDictionary)["answer"] as! NSArray
                        let qvalue = qType[0] as! NSDictionary
                        let questionnaireType = qvalue["valueString"] as! String
                                
                        if (questionnaireType != "Patient questionnaire responses"){
                            continue
                        }
                                
                        let metaData = d2["meta"] as! NSDictionary
                        var rawDate = metaData["lastUpdated"] as! String
                                
                        // Remove colon from rawDate
                        rawDate = rawDate.replacingOccurrences(of: ":", with: "")
                        let dateFormatter = Utilities.GetMetaDateFormatter()
                        let tempDate = dateFormatter.date(from: rawDate)
                                
                        if(latestDate == nil || Utilities.CompareDatesNoTime(date1: tempDate!, date2: latestDate!) == 1){
                            latestDate = tempDate
                            
                            testID = d2["id"] as? String
                            
                            let milkIn = (d3[1] as! NSDictionary)["answer"] as! NSArray
                            let mvalue = milkIn[0] as! NSDictionary
                            milkAnswer = mvalue["valueBoolean"] as? Bool
                        
                            let stoolCol = (d3[2] as! NSDictionary)["answer"] as! NSArray
                            let svalue = stoolCol[0] as! NSDictionary
                            stoolAnswer = svalue["valueBoolean"] as? Bool
                        }
                    }
                }
            }
        } catch {
            print("error in JSONSerialization")
        }
        
        var finalDate :String? = nil
        
        if(latestDate != nil){
            finalDate = Utilities.GetDateFormatter().string(from: latestDate!)
        }
        
        return (connectionSuccessful, testID, finalDate, milkAnswer, stoolAnswer)
    }
   
   
   func GetPatientIDFromFHIRServer(family: String, given:String, birthDate:String) -> String? {

        let url = URL(string: Utilities.GetPatientURLByGivenFamilyBirthDate(family: family, given: given, birthDate: birthDate))! //restful api GET the resource with specific patientID

        var id : String? = nil
    
        // pull data from fhir and get the latest
        do {
            let data = NSData(contentsOf: url)
            
            if (data == nil){
                print ("Unable to connect to server '" + url.absoluteString + "'.")
                return id
            }
            
            if let json = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? [String: Any]
            {
                
                var count = 0
                count = json["total"] as! Int
                
                if(count>0){
                    
                    // parse json data from fhir into BreastfeedingData
                    let responseEntry : NSArray = json["entry"] as! NSArray
                    
                    for response in responseEntry {
                        let resourceDict = (response as! NSDictionary)["resource"] as! NSDictionary
                        id = resourceDict["id"] as! String
                    }
                }
            }
        } catch {
            print("error in JSONSerialization")
        }
    
        return id
    }
    
    func CanConnectToServer() -> Bool {
        let url = URL(string: Utilities.CARE_PROVIDER_SERVER_URL+"/Patient")! //restful api GET the resource with specific patientID
        
        // pull data from fhir and get the latest
        let data = NSData(contentsOf: url)
            
        if (data == nil){
            print ("Can't connect to Server: '" + Utilities.CARE_PROVIDER_SERVER_URL + "'.")
            return false
        } else {
            return true
        }
    }
    
    func DoesPatientExistOnFhirServer() -> Bool {

        let url = URL(string: Utilities.GetPatientByIDURL(sPatientID: Utilities.patientID))! //restful api GET the resource with specific patientID
        
        // pull data from fhir and get the latest
        do {
            let data = NSData(contentsOf: url)
            
            if (data == nil){
                print ("Patient Not Found: '" + url.absoluteString + "'.")
                return false
            }
            
            if let json = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? [String: Any]
            {
                if (json.keys.contains("_birthDate")){
                    print ("Patient is baby, don't login")
                    return false
                }
                
                print ("Patient found, proceed with login")
                return true
            }
        } catch {
            print("error in JSONSerialization")
        }
        
        return false
    }
    
    // gets the last upload date of the data
    func GetLastUploadDateOfData() -> String? {
        if (self.DoesJsonUploadInfoFileExist()){
            do {
                let id = Utilities.patientID.components(separatedBy: "/")[1]
                let dirPath = self.breastFeedingLogDir + "/" + id + "/" + self.uploadInfoFileName
            
                let jsonURL = try URL(fileURLWithPath: dirPath)
                let jsonData = try Data(contentsOf: jsonURL)
            
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
                
                return (json!["dataLastUpload"] as! String)
            
            } catch {
                return nil
            }
        }
        return nil
    }
    
    // Uploads a specified JSON file to the FHIR server
    func UploadDailyJsonLogsToFHIRServer(jsonStringLogs: [String:String], serverURL: String, latestDate: String) -> Void {
    
        for date in jsonStringLogs{
            let jsonDic = Utilities.ConvertToDictionary(text: date.value)
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonDic)
            let url = URL(string: serverURL)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
            // insert json data to the request
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
                let currentDataDate = date.key
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
            
                    let issueArr = (responseJSON["issue"] as! NSArray)
                    let issueDict = (issueArr[0] as! NSDictionary)
                    let code = issueDict["code"] as! String
                    // If resonse it ok (informational), then update the date if it's the latest
                    // else don't update date
                    if(code == "informational"){
                        if (currentDataDate == latestDate){
                            _ = self.UpdateUploadInfoFile(dataLastUpload: latestDate)
                        }
                    }
                
                print(responseJSON)
            }
        }
        
        task.resume()
        }
    }

    func ExtractObservationReferenceFromFile(fileName: String) -> String{
        var referenceID = ""
        
        do {
            let filePath = self.hospitalDataDir + "/" + fileName + ".json"
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: jsonURL)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            
            if(json?.keys.contains("subject"))!{
                let subjectDict = json!["subject"] as! NSDictionary
                referenceID = subjectDict["reference"] as! String
            }
            
        } catch {
            print("Unable to extract data from '" + fileName + "': skipping file")
        }
        
        return referenceID
    }
    
    func ExtractClaimDiagnosisReferenceAndCodeFromFile(fileName:String, codeHeur:String)->(String,String){
        var referenceID = ""
        var code = ""
        
        do {
            let filePath = self.hospitalDataDir + "/" + fileName + ".json"
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: jsonURL)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            
            if(json?.keys.contains("diagnosis"))!{
                let diagnosisArr = json!["diagnosis"] as! NSArray
                for i in diagnosisArr{
                    let dict1 = i as! NSDictionary
                    let dict1Keys = dict1.allKeys as! [String]
                    if(dict1Keys.contains("diagnosisCodeableConcept")){
                        let diagnosisCodeDict = dict1["diagnosisCodeableConcept"] as! NSDictionary
                        let diagnosisCodeDictKeys = diagnosisCodeDict.allKeys as! [String]
                        if(diagnosisCodeDictKeys.contains("coding")){
                            let codeArr = diagnosisCodeDict["coding"] as! NSArray
                            for i in codeArr{
                                let codeDict = i as!NSDictionary
                                let sCode = codeDict["code"] as! String
                                if(sCode.contains(codeHeur)){
                                        code = sCode
                                        let patientDict = json!["patient"] as! NSDictionary
                                        referenceID = patientDict["reference"] as! String
                                        return (referenceID, code)
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("Unable to extract data from '" + fileName + "': skipping file")
        }
        return (referenceID, code)
    }
    
    func ExtractClaimDiagnosisReferenceAndCodeFromFile(fileName:String, codeHeurs:[String])->(String,String){
        var referenceID = ""
        var code = ""
        
        do {
            let filePath = self.hospitalDataDir + "/" + fileName + ".json"
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: jsonURL)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            
            if(json?.keys.contains("diagnosis"))!{
                let diagnosisArr = json!["diagnosis"] as! NSArray
                for i in diagnosisArr{
                    let dict1 = i as! NSDictionary
                    let dict1Keys = dict1.allKeys as! [String]
                    if(dict1Keys.contains("diagnosisCodeableConcept")){
                        let diagnosisCodeDict = dict1["diagnosisCodeableConcept"] as! NSDictionary
                        let diagnosisCodeDictKeys = diagnosisCodeDict.allKeys as! [String]
                        if(diagnosisCodeDictKeys.contains("coding")){
                            let codeArr = diagnosisCodeDict["coding"] as! NSArray
                            for i in codeArr{
                                let codeDict = i as!NSDictionary
                                let sCode = codeDict["code"] as! String
                                for s in codeHeurs{
                                    if(sCode.contains(s)){
                                        code = sCode
                                        let patientDict = json!["patient"] as! NSDictionary
                                        referenceID = patientDict["reference"] as! String
                                        return (referenceID, code)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("Unable to extract data from '" + fileName + "': skipping file")
        }
        return (referenceID, code)
    }
    
    func ExtractClaimProcedureReferenceAndCodeFromFile(fileName:String, codeHeur:String)->(String,String){
        var referenceID = ""
        var code = ""
        
        do {
            let filePath = self.hospitalDataDir + "/" + fileName + ".json"
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: jsonURL)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            
            if(json?.keys.contains("procedure"))!{
                let diagnosisArr = json!["procedure"] as! NSArray
                for i in diagnosisArr{
                    let dict1 = i as! NSDictionary
                    let dict1Keys = dict1.allKeys as! [String]
                    if(dict1Keys.contains("procedureCodeableConcept")){
                        let procedureCodeDict = dict1["procedureCodeableConcept"] as! NSDictionary
                        let procedureCodeDictKeys = procedureCodeDict.allKeys as! [String]
                        if(procedureCodeDictKeys.contains("coding")){
                            let codeArr = procedureCodeDict["coding"] as! NSArray
                            for i in codeArr{
                                let codeDict = i as!NSDictionary
                                let sCode = codeDict["code"] as! String
                                if(sCode.contains(codeHeur)){
                                        code = sCode
                                        let patientDict = json!["patient"] as! NSDictionary
                                        referenceID = patientDict["reference"] as! String
                                        return (referenceID, code)
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("Unable to extract data from '" + fileName + "': skipping file")
        }
        return (referenceID, code)
    }
    
    func ExtractClaimProcedureReferenceAndCodeFromFile(fileName:String, codeHeurs:[String])->(String,String){
        var referenceID = ""
        var code = ""
        
        do {
            let filePath = self.hospitalDataDir + "/" + fileName + ".json"
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: jsonURL)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            
            if(json?.keys.contains("procedure"))!{
                let diagnosisArr = json!["procedure"] as! NSArray
                for i in diagnosisArr{
                    let dict1 = i as! NSDictionary
                    let dict1Keys = dict1.allKeys as! [String]
                    if(dict1Keys.contains("procedureCodeableConcept")){
                        let procedureCodeDict = dict1["procedureCodeableConcept"] as! NSDictionary
                        let procedureCodeDictKeys = procedureCodeDict.allKeys as! [String]
                        if(procedureCodeDictKeys.contains("coding")){
                            let codeArr = procedureCodeDict["coding"] as! NSArray
                            for i in codeArr{
                                let codeDict = i as!NSDictionary
                                let sCode = codeDict["code"] as! String
                                for s in codeHeurs{
                                    if(sCode.contains(s)){
                                        code = sCode
                                        let patientDict = json!["patient"] as! NSDictionary
                                        referenceID = patientDict["reference"] as! String
                                        return (referenceID, code)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("Unable to extract data from '" + fileName + "': skipping file")
        }
        return (referenceID, code)
    }

    func ExtractFirstNameLastNameBirthdayFromFile(fileName : String) -> [String]{
        var firstName = ""
        var lastName = ""
        var birthday = ""
        
        do {
            let filePath = self.hospitalDataDir + "/" + fileName + ".json"
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: jsonURL)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            
            // Extract name
            let nameArr = json!["name"] as! NSArray
            for i in nameArr{
                let nameDict = i as! NSDictionary
                let useVal = nameDict["use"] as! String
                if(useVal == "official"){
                    lastName = nameDict["family"] as! String
                    let givenArr = nameDict["given"] as! NSArray
                    for j in givenArr{
                        firstName = (j as! String)
                        break
                    }
                }
            }
            
            birthday = json!["birthDate"] as! String
            
        } catch {
            print("Unable to extract data from '" + Utilities.EHR_PATIENT_FILENAME + "': skipping file")
        }
        
        return [firstName, lastName, birthday]
    }

    
    func ExtractPatientNameAge() -> [String]{
        var fullName = "n/a"
        var age = "n/a"
        
        do {
            let filePath = self.hospitalDataDir + "/" + Utilities.EHR_PATIENT_FILENAME + ".json"
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: jsonURL)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            
            // Extract full name
            var firstName = "n/a"
            var lastName = "n/a"
            
            let nameArr = json!["name"] as! NSArray
            for i in nameArr{
                let nameDict = i as! NSDictionary
                let useVal = nameDict["use"] as! String
                if(useVal == "official"){
                    lastName = nameDict["family"] as! String
                    let givenArr = nameDict["given"] as! NSArray
                    for j in givenArr{
                        if(firstName == "n/a"){
                            firstName = ""
                        }
                        firstName += (j as! String) + " "
                    }
                    
                    fullName = firstName + lastName
                    break
                }
            }
            
            // Calculate age based on birthday
            let sBirthdate = json!["birthDate"] as! String
            let dBirthdate = Utilities.GetDateFormatter().date(from: sBirthdate)
            
            age = Utilities.FindAge(birthDate: dBirthdate!)
            
        } catch {
            print("Unable to extract data from '" + Utilities.EHR_PATIENT_FILENAME + "': skipping file")
        }
        
        return [fullName, age]
    }
    
    func ExtractPatientBMI() -> String{
        var bmi = "n/a"
        
        do {
            var bmiValue = ""
            var bmiUnits = ""
        
            let filePath = self.hospitalDataDir + "/" + Utilities.EHR_PATIENT_BMI_FILENAME + ".json"
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: jsonURL)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            
            let valueQuantityDict = json!["valueQuantity"] as! NSDictionary
            bmiValue = String((valueQuantityDict["value"] as! Int64))
            bmiUnits = valueQuantityDict["unit"] as! String
            
            bmi = bmiValue + " " + bmiUnits
            
            
        } catch {
            print("Unable to extract data from '" + Utilities.EHR_PATIENT_BMI_FILENAME + "': skipping file")
        }
        
        return bmi
    }
    
    func ExtractBabyNameBirthTime() -> [String]{
        var fullName = "n/a"
        var birthTime = "n/a"
        
        do {
            let filePath = self.hospitalDataDir + "/" + Utilities.EHR_PATIENT_BABY_FILENAME + ".json"
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: jsonURL)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            
            // Extract full name
            var firstName = "n/a"
            var lastName = "n/a"
            
            let nameArr = json!["name"] as! NSArray
            for i in nameArr{
                let nameDict = i as! NSDictionary
                let useVal = nameDict["use"] as! String
                if(useVal == "official"){
                    lastName = nameDict["family"] as! String
                    let givenArr = nameDict["given"] as! NSArray
                    for j in givenArr{
                        if(firstName == "n/a"){
                            firstName = ""
                        }
                        firstName += (j as! String) + " "
                    }
                    
                    fullName = firstName + lastName
                    break
                }
            }
            
            // Get Birth Time
            let jsonDict = json! as NSDictionary
            let jsonKeys = jsonDict.allKeys  as! [String]
            if(jsonKeys.contains("_birthDate"))
            {
                let birthTimeDict = json!["_birthDate"] as! NSDictionary
                let extArr = birthTimeDict["extension"] as! NSArray
                let extOneDict = extArr[0] as! NSDictionary
                let sValueDateTime = extOneDict["valueDateTime"] as! String
                let dValueDateTime = Utilities.GetBirthTimeDateFormatter().date(from: sValueDateTime)
                birthTime = Utilities.GetAppBirthTimeDateFormatter().string(from: dValueDateTime!)
            } else if(jsonKeys.contains("birthDate")){
                birthTime = json!["birthDate"] as! String
            }
        } catch {
            print("Unable to extract data from '" + Utilities.EHR_PATIENT_BABY_FILENAME + "': skipping file")
        }
        
        return [fullName, birthTime]
    }
    
    func ExtractBabyBirthWeight() -> String{
        var babyBirthWeight = "n/a"
        
        do {
            var bbwMetricValue = ""
            var bbwMetricUnits = ""
            
            var bbwImpValue = ""
            let bbwImpUnits = "lb"
        
            let filePath = self.hospitalDataDir + "/" + Utilities.EHR_BIRTH_WEIGHT_FILENAME + ".json"
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: jsonURL)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            
            let valueQuantityDict = json!["valueQuantity"] as! NSDictionary
            bbwMetricValue = String((valueQuantityDict["value"] as! Double))
            bbwMetricUnits = valueQuantityDict["unit"] as! String
            
            babyBirthWeight = bbwMetricValue + " " + bbwMetricUnits + " "
            
            // Convert to lbs
            if (bbwMetricUnits == "g"){
                let dBbwImpValue = Utilities.ConvertGramsToPounds(grams: Double(bbwMetricValue)!)
                bbwImpValue = String(format: "%.2f",dBbwImpValue)
                
            } else if (bbwMetricUnits == "kg"){
                let gramValue = Double(bbwMetricValue)! * 1000.00
                let dBbwImpValue = Utilities.ConvertGramsToPounds(grams: gramValue)
                bbwImpValue = String(format: "%.2f",dBbwImpValue)
            }
            
            babyBirthWeight += "(" + bbwImpValue + " " + bbwImpUnits + ")"
            
        } catch {
            print("Unable to extract data from '" + Utilities.EHR_PATIENT_BMI_FILENAME + "': skipping file")
        }
        
        return babyBirthWeight
    }
    
    func ExtractDeliveryOutcome() -> String{
        var outcome = "n/a"
        
        do {
            let filePath = self.hospitalDataDir + "/" + Utilities.EHR_DELIVERY_OUTCOME_FILENAME + ".json"
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: jsonURL)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            
            let diagnosisArr = json!["diagnosis"] as! NSArray
            for i in diagnosisArr{
                let dict1 = i as! NSDictionary
                let dict1Keys = dict1.allKeys as! [String]
                if(dict1Keys.contains("diagnosisCodeableConcept")){
                    let diagnosisCodeDict = dict1["diagnosisCodeableConcept"] as! NSDictionary
                    let diagnosisCodeDictKeys = diagnosisCodeDict.allKeys as! [String]
                    if(diagnosisCodeDictKeys.contains("coding")){
                        let codeArr = diagnosisCodeDict["coding"] as! NSArray
                        for i in codeArr{
                            let codeDict = i as!NSDictionary
                            let sCode = codeDict["code"] as! String
                            if sCode.contains(Utilities.DELIVERY_OUTCOME_CODE)
                            {
                                outcome = codeDict["display"] as! String
                            }
                        }
                    }
                }
            }
        } catch {
            print("Unable to extract data from '" + Utilities.EHR_DELIVERY_OUTCOME_FILENAME + "': skipping file")
        }
        
        return outcome
    }
    
    func ExtractDelivery() -> String{
        var delivery = "n/a"
        
        do {
            let filePath = self.hospitalDataDir + "/" + Utilities.EHR_DELIVERY_FILENAME + ".json"
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: jsonURL)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            
            let procedureArr = json!["procedure"] as! NSArray
            for i in procedureArr{
                let dict1 = i as! NSDictionary
                let dict1Keys = dict1.allKeys as! [String]
                if(dict1Keys.contains("procedureCodeableConcept")){
                    let procedureCodeDict = dict1["procedureCodeableConcept"] as! NSDictionary
                    let procedureCodeDictKeys = procedureCodeDict.allKeys as! [String]
                    if(procedureCodeDictKeys.contains("coding")){
                        let codeArr = procedureCodeDict["coding"] as! NSArray
                        for i in codeArr{
                            let codeDict = i as!NSDictionary
                            switch(codeDict["code"] as! String){
                                case "O80.0":
                                    delivery = "Spontaneous Vertex"
                                    break
                                case "O82.0":
                                    delivery = "Caesarean Section"
                                    break
                                case "O81.5":
                                    delivery = "Vacuum Extractor"
                                    break
                                default:
                                    break
                            }
                        }
                    }
                }
            }
        } catch {
            print("Unable to extract data from '" + Utilities.EHR_PATIENT_BMI_FILENAME + "': skipping file")
        }
        
        return delivery
    }
    
    func ExtractDischargeWeight() -> String{
        var babyBirthWeight = "n/a"
        
        do {
            var bbwMetricValue = ""
            var bbwMetricUnits = ""
            
            var bbwImpValue = ""
            let bbwImpUnits = "lb"
        
            let filePath = self.hospitalDataDir + "/" + Utilities.EHR_DISCHARGE_WEIGHT_FILENAME + ".json"
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: jsonURL)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            
            let valueQuantityDict = json!["valueQuantity"] as! NSDictionary
            bbwMetricValue = String((valueQuantityDict["value"] as! Double))
            bbwMetricUnits = valueQuantityDict["unit"] as! String
            
            babyBirthWeight = bbwMetricValue + " " + bbwMetricUnits + " "
            
            // Convert to lbs
            if (bbwMetricUnits == "g"){
                let dBbwImpValue = Utilities.ConvertGramsToPounds(grams: Double(bbwMetricValue)!)
                bbwImpValue = String(format: "%.2f",dBbwImpValue)
                
            } else if (bbwMetricUnits == "kg"){
                let gramValue = Double(bbwMetricValue)! * 1000.00
                let dBbwImpValue = Utilities.ConvertGramsToPounds(grams: gramValue)
                bbwImpValue = String(format: "%.2f",dBbwImpValue)
            }
            
            babyBirthWeight += "(" + bbwImpValue + " " + bbwImpUnits + ")"
            
        } catch {
            print("Unable to extract data from '" + Utilities.EHR_PATIENT_BMI_FILENAME + "': skipping file")
        }
        
        return babyBirthWeight
    }

/* ----
        Beyond this point is the functions that deal with downloadin data from the EHR server
        and uploading the data to the FHIR server. Once a real EHR server is in place. You may
        need to modify the below code to conform to the EHR server's JSON data standards.
---- */
    func DownloadEHRDataFromHospitalServer(){

        var relatedPersonID = ""
        var patientBabyID = ""
        
        // Delete files
        self.DeleteAllFilesInDirectory(dirPath: self.hospitalDataDir)
        
        self.downloadPatientJson()
        relatedPersonID = self.downloadRelatedPersonJson()
        
        if (!relatedPersonID.isEmpty){
            patientBabyID = self.downloadPatientBabyJson(relatedPersonID: relatedPersonID)
        }
        
        self.downloadPatientBMIJson()
        
        if (!patientBabyID.isEmpty){
            self.downloadBabyBirthWeightJson(patientBabyID: patientBabyID)
            self.downloadBabyDischargeWeightJson(patientBabyID: patientBabyID)
        }
        
        self.downloadPatientClaimJsons()

    }
    
    
    private func downloadPatientJson(){
        // Get the Patient Information
        let url = URL(string: Utilities.HOSPITAL_SERVER_URL + "/" + Utilities.patientID)!
        
        // pull data from fhir and get the latest
        do {
            let data = try Data.init(contentsOf: url)
            
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            {
            
                // parse json data from fhir into BreastfeedingData
                let rawJson = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)

                // Write Patient JSON to file
                let patientJson = String.init(data: rawJson, encoding: .utf8)!
                
                // Remove Escape Characters
                let cleanPatientJson = patientJson.replacingOccurrences(of: "\\/", with: "/")
                if (!cleanPatientJson.isEmpty)
                {
                    self.WriteJsonToHospitalDataDirectory(jsonContent: cleanPatientJson, fileName: Utilities.EHR_PATIENT_FILENAME)
                }
            }
            else
            {
                print ("No patient data from server: '" + url.absoluteString + "'.")
            }
        } catch {
            print ("No patient data from server: '" + url.absoluteString + "'.")
        }
    }
    
    
    private func downloadRelatedPersonJson() -> String{
        // Get Related Person Info
        let url = URL(string: Utilities.HOSPITAL_SERVER_URL + "/" + "RelatedPerson?patient:reference=" + Utilities.patientID)!
        var relatedPersonID: String = ""
        
        // pull data from fhir and get the latest
        do {
            let data = try Data.init(contentsOf: url)
            
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            {
                // Extract related person ID for later use
                var count = 0
                count = json["total"] as! Int
                
                if(count>0){
                    
                    // parse json data from fhir into BreastfeedingData
                    let responseEntry : NSArray = json["entry"] as! NSArray
                    
                    for response in responseEntry {
                        let resourceDict = (response as! NSDictionary)["resource"] as! NSDictionary
                        let rpID = resourceDict["id"] as! String
                        relatedPersonID = "RelatedPerson/" + rpID
                    }
                }else {
                    return ""
                }
                
                // Write RelatedPerson Json to file
                let responseEntry : NSArray = json["entry"] as! NSArray
                let jsonToConvertRaw = (responseEntry[0]as! NSDictionary)["resource"] as! NSDictionary
                let rawJson = try JSONSerialization.data(withJSONObject: jsonToConvertRaw, options: .prettyPrinted)
                let relatedPersonJson = String.init(data: rawJson, encoding: .utf8)!
                // Remove Escape Characters
                let cleanRelatedPersonJson = relatedPersonJson.replacingOccurrences(of: "\\/", with: "/")
                if (!cleanRelatedPersonJson.isEmpty)
                {
                    self.WriteJsonToHospitalDataDirectory(jsonContent: cleanRelatedPersonJson, fileName: Utilities.EHR_RELATED_PERSON_FILENAME)
                }
            }
            else
            {
                print ("No patient data from server: '" + url.absoluteString + "'.")
            }
        } catch {
            print ("No patient data from server: '" + url.absoluteString + "'.")
        }
        
        return relatedPersonID
    }
    
    private func downloadPatientBabyJson(relatedPersonID: String) -> String{
        let url = URL(string: Utilities.HOSPITAL_SERVER_URL + "/" + "Patient?link:other:reference=" + relatedPersonID)!
        var patientBabyID: String = ""
        
        // pull data from fhir and get the latest
        do {
            let data = try Data.init(contentsOf: url)
            
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            {
            
                // Extract patientBabyID for later use
                var count = 0
                count = json["total"] as! Int
                
                if(count>0){
                    
                    // parse json data from fhir into BreastfeedingData
                    let responseEntry : NSArray = json["entry"] as! NSArray
                    
                    for response in responseEntry {
                        let resourceDict = (response as! NSDictionary)["resource"] as! NSDictionary
                        let bpID = resourceDict["id"] as! String
                        patientBabyID = "Patient/" + bpID
                    }
                } else {
                    return ""
                }
            
                // Write Patient Baby Json
                let rawJsonTEST = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                print(String.init(data: rawJsonTEST, encoding: .utf8)!)
                
                let responseEntry : NSArray = json["entry"] as! NSArray
                let jsonToConvertRaw = (responseEntry[0]as! NSDictionary)["resource"] as! NSDictionary
                let rawJson = try JSONSerialization.data(withJSONObject: jsonToConvertRaw, options: .prettyPrinted)
                let patientBabyJson = String.init(data: rawJson, encoding: .utf8)!
                // Remove Escape Characters
                let cleanPatientBabyJson = patientBabyJson.replacingOccurrences(of: "\\/", with: "/")
                if (!cleanPatientBabyJson.isEmpty)
                {
                    self.WriteJsonToHospitalDataDirectory(jsonContent: cleanPatientBabyJson, fileName: Utilities.EHR_PATIENT_BABY_FILENAME)
                }
            }
            else
            {
                print ("No patient data from server: '" + url.absoluteString + "'.")
            }
        } catch {
            print ("No patient data from server: '" + url.absoluteString + "'.")
        }
        
        return patientBabyID
    }
    
    
    private func downloadPatientBMIJson() {
        // Get Patient's BMI Data
        let url = URL(string: Utilities.HOSPITAL_SERVER_URL + "/" + "Observation?code:coding:code=39156-5&subject:reference=" + Utilities.patientID)!
        
        // pull data from fhir and get the latest
        do {
            let data = try Data.init(contentsOf: url)
            
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            {
                var count = 0
                count = json["total"] as! Int
                if(count<1){
                    return
                }
            
                // Write Patient BMI Json
                let responseEntry : NSArray = json["entry"] as! NSArray
                let jsonToConvertRaw = (responseEntry[0]as! NSDictionary)["resource"] as! NSDictionary
                let rawJson = try JSONSerialization.data(withJSONObject: jsonToConvertRaw, options: .prettyPrinted)
                let patientBMIJson = String.init(data: rawJson, encoding: .utf8)!
                // Remove Escape Characters
                let cleanPatientBMIJson = patientBMIJson.replacingOccurrences(of: "\\/", with: "/")
                if (!cleanPatientBMIJson.isEmpty)
                {
                    self.WriteJsonToHospitalDataDirectory(jsonContent: cleanPatientBMIJson, fileName: Utilities.EHR_PATIENT_BMI_FILENAME)
                }
            }
            else
            {
                print ("No patient data from server: '" + url.absoluteString + "'.")
            }
        } catch {
            print ("No patient data from server: '" + url.absoluteString + "'.")
        }
    }
    
    
    private func downloadBabyBirthWeightJson(patientBabyID: String) {
        let url = URL(string: Utilities.HOSPITAL_SERVER_URL + "/" + "Observation?code:coding:code=8339-4&subject:reference=" + patientBabyID)!
        
        // pull data from fhir and get the latest
        do {
            let data = try Data.init(contentsOf: url)
            
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            {
                var count = 0
                count = json["total"] as! Int
                if(count<1){
                    return
                }
            
                // Write Patient BMI Json
                let responseEntry : NSArray = json["entry"] as! NSArray
                let jsonToConvertRaw = (responseEntry[0]as! NSDictionary)["resource"] as! NSDictionary
                let rawJson = try JSONSerialization.data(withJSONObject: jsonToConvertRaw, options: .prettyPrinted)
                let babyBirthWeightJson = String.init(data: rawJson, encoding: .utf8)!
                // Remove Escape Characters
                let cleanBabyBirthWeightJson = babyBirthWeightJson.replacingOccurrences(of: "\\/", with: "/")
                if (!cleanBabyBirthWeightJson.isEmpty)
                {
                    self.WriteJsonToHospitalDataDirectory(jsonContent: cleanBabyBirthWeightJson, fileName: Utilities.EHR_BIRTH_WEIGHT_FILENAME)
                }
            }
            else
            {
                print ("No patient data from server: '" + url.absoluteString + "'.")
            }
        } catch {
            print ("No patient data from server: '" + url.absoluteString + "'.")
        }
    }
    
    
    private func downloadBabyDischargeWeightJson(patientBabyID: String) {
        let url = URL(string: Utilities.HOSPITAL_SERVER_URL + "/" + "Observation?code:coding:code=3141-9&subject:reference=" + patientBabyID)!
        
        // pull data from fhir and get the latest
        do {
            let data = try Data.init(contentsOf: url)
            
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            {
                
                var weightDicts: [String:String] = [:]
                
                var count = 0
                count = json["total"] as! Int
                if(count<1){
                    return
                }
                
                // parse json data from fhir into BreastfeedingData
                let responseEntry : NSArray = json["entry"] as! NSArray
                
                for response in responseEntry {
                    let resourceDict = (response as! NSDictionary)["resource"] as! NSDictionary
                    let effectiveDate = resourceDict["effectiveDateTime"] as! String
                    let rawJson = try JSONSerialization.data(withJSONObject: resourceDict, options: .prettyPrinted)
                    let sRawJson = String.init(data: rawJson, encoding: .utf8)!
                    // Remove Escape Characters
                    let cleansRawJson = sRawJson.replacingOccurrences(of: "\\/", with: "/")
                    
                    if(!cleansRawJson.isEmpty){
                        weightDicts[effectiveDate] = cleansRawJson
                    }
                }
            
                if(weightDicts.count < 1){
                    return
                }
            
                // Determine which weight is earliest
                var earliestDate = ""
                for date in weightDicts{
                    if (earliestDate == ""){
                        earliestDate = date.key
                    } else {
                        let date1 = Utilities.GetBirthTimeDateFormatter().date(from: earliestDate)
                        let date2 = Utilities.GetBirthTimeDateFormatter().date(from: date.key)
                    
                        let result = Utilities.CompareDatesNoTime(date1: date1!, date2: date2!)
                        if(result == 1){
                            earliestDate = date.key
                        }
                    }
                }
                
                // Write earliest
                self.WriteJsonToHospitalDataDirectory(jsonContent: weightDicts[earliestDate]!, fileName: Utilities.EHR_DISCHARGE_WEIGHT_FILENAME)
            }
            else
            {
                print ("No patient data from server: '" + url.absoluteString + "'.")
            }
        } catch {
            print ("No patient data from server: '" + url.absoluteString + "'.")
        }
    }
        
    
    private func downloadPatientClaimJsons(){
        let url = URL(string: Utilities.HOSPITAL_SERVER_URL + "/" + "Claim?patient:reference=" + Utilities.patientID)!
        
        // pull data from fhir and get the latest
        do {
            let data = try Data.init(contentsOf: url)
            
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            {
            
                // Sift through data to find specifics
                var count = 0
                count = json["total"] as! Int
                
                if(count>0){
                    
                    // parse json data from fhir into BreastfeedingData
                    let responseEntry : NSArray = json["entry"] as! NSArray
                    
                    for response in responseEntry {
                        let resourceDict = (response as! NSDictionary)["resource"] as! NSDictionary
                        let resourceDictKeys = resourceDict.allKeys as! [String]
                        if(resourceDictKeys.contains("diagnosis")){
                            let diagnosisArr = resourceDict["diagnosis"] as! NSArray
                            for i in diagnosisArr{
                                let dict1 = i as! NSDictionary
                                let dict1Keys = dict1.allKeys as! [String]
                                if(dict1Keys.contains("diagnosisCodeableConcept")){
                                    let diagnosisCodeDict = dict1["diagnosisCodeableConcept"] as! NSDictionary
                                    let diagnosisCodeDictKeys = diagnosisCodeDict.allKeys as! [String]
                                    if( diagnosisCodeDictKeys.contains("coding")){
                                        let codeArr = diagnosisCodeDict["coding"] as! NSArray
                                        for i in codeArr{
                                            let codeDict = i as!NSDictionary
                                            let sCode = codeDict["code"] as! String
                                            var saveJson = false
                                            var saveFileName = ""
                                            
                                            for j in Utilities.DIABETES_CODES{
                                                if (sCode.contains(j)){
                                                    saveJson = true
                                                    saveFileName = Utilities.EHR_PATIENT_DIABETES_FILENAME
                                                    break
                                                }
                                            }
                                            
                                            if (sCode.contains(Utilities.POLYCYSTIC_OVARIAN_CODE)){
                                                saveJson = true
                                                saveFileName = Utilities.EHR_PATIENT_POLYOVARIAN_FILENAME
                                            } else if (sCode.contains(Utilities.HYPERTHYROIDISM_CODE)){
                                                saveJson = true
                                                saveFileName = Utilities.EHR_PATIENT_HYPERTHYROIDISM_FILENAME
                                            }else if (sCode.contains(Utilities.HYPOTHYROIDISM_CODE)){
                                                saveJson = true
                                                saveFileName = Utilities.EHR_PATIENT_HYPOTHYROIDISM_FILENAME
                                            }else if (sCode.contains(Utilities.BREAST_PATHOLOGY_SURGERY_CODE)){
                                                saveJson = true
                                                saveFileName = Utilities.EHR_PATIENT_BREAST_SURGERY_FILENAME
                                            }else if (sCode.contains(Utilities.PRIMARY_GLANDULAR_INSUFFICIENCEY_CODE)){
                                                saveJson = true
                                                saveFileName = Utilities.EHR_PATIENT_GLANDULAR_FILENAME
                                            }else if (sCode.contains(Utilities.POSTPARTUM_HEMORRHAGE_CODE)){
                                                saveJson = true
                                                saveFileName = Utilities.EHR_POSTPARTUM_HEMORRHAGE_FILENAME
                                            }else if (sCode.contains(Utilities.GESTATIONAL_HYPERTENSION_CODE)){
                                                saveJson = true
                                                saveFileName = Utilities.EHR_GESTATIONAL_HYPERTENSION_FILENAME
                                            }else if (sCode.contains(Utilities.OBESITY_CODE)){
                                                saveJson = true
                                                saveFileName = Utilities.EHR_OBESITY_FILENAME
                                            }else if (sCode.contains(Utilities.CYSTIC_FIBROSIS_CODE)){
                                                saveJson = true
                                                saveFileName = Utilities.EHR_CYSTIC_FIBROSIS_FILENAME
                                            }else if (sCode.contains(Utilities.DEPRESSION_CODE)){
                                                saveJson = true
                                                saveFileName = Utilities.EHR_DEPRESSION_FILENAME
                                            }else if (sCode.contains(Utilities.AGALACTIA_CODE)){
                                                saveJson = true
                                                saveFileName = Utilities.EHR_AGALACTIA_FILENAME
                                            }else if (sCode.contains(Utilities.FAILED_EXTRACTION_CODE)){
                                                saveJson = true
                                                saveFileName = Utilities.EHR_FAILED_EXTRACTION_FILENAME
                                            }else if (sCode.contains(Utilities.SUPERVISION_LACTATE_CODE)){
                                                saveJson = true
                                                saveFileName = Utilities.EHR_SUPERVISION_LACTATE_FILENAME
                                            }else if(sCode.contains(Utilities.DELIVERY_OUTCOME_CODE)){
                                                var isExcludedCode = false
                                                for i in Utilities.DELIVERY_OUTCOME_EXCLUDE_CODES{
                                                    if(sCode.contains(i)){
                                                        isExcludedCode = true
                                                        break
                                                    }
                                                }
                                                if(!isExcludedCode){
                                                    saveJson = true
                                                    saveFileName = Utilities.EHR_DELIVERY_OUTCOME_FILENAME
                                                }
                                            }
                                            
                                            if(saveJson && !saveFileName.isEmpty){
                                                let rawJson = try JSONSerialization.data(withJSONObject: resourceDict, options: .prettyPrinted)
                                                let sRawJson = String.init(data: rawJson, encoding: .utf8)!
                                                // Remove Escape Characters
                                                let cleansRawJson = sRawJson.replacingOccurrences(of: "\\/", with: "/")

                                                if(!cleansRawJson.isEmpty){
                                                    self.WriteJsonToHospitalDataDirectory(jsonContent: cleansRawJson, fileName: saveFileName)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if(resourceDictKeys.contains("procedure")){
                            let procedureArr = resourceDict["procedure"] as! NSArray
                            for i in procedureArr{
                                let dict1 = i as! NSDictionary
                                let dict1Keys = dict1.allKeys as! [String]
                                if(dict1Keys.contains("procedureCodeableConcept")){
                                    let procedureCodeDict = dict1["procedureCodeableConcept"] as! NSDictionary
                                    let procedureCodeDictKeys = procedureCodeDict.allKeys as! [String]
                                    if( procedureCodeDictKeys.contains("coding")){
                                        let codeArr = procedureCodeDict["coding"] as! NSArray
                                        for i in codeArr{
                                            let codeDict = i as!NSDictionary
                                            let sCode = codeDict["code"] as! String
                                            for j in Utilities.DELIVERY_CODES{
                                                if (sCode.contains(j)){
                                                    let rawJson = try JSONSerialization.data(withJSONObject: resourceDict, options: .prettyPrinted)
                                                    let sRawJson = String.init(data: rawJson, encoding: .utf8)!
                                                    // Remove Escape Characters
                                                    let cleansRawJson = sRawJson.replacingOccurrences(of: "\\/", with: "/")
                    
                                                    if(!cleansRawJson.isEmpty){
                                                        self.WriteJsonToHospitalDataDirectory(jsonContent: cleansRawJson, fileName: Utilities.EHR_DELIVERY_FILENAME)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }else {
                    return
                }
            }
            else
            {
                print ("No patient data from server: '" + url.absoluteString + "'.")
            }
        } catch {
            print ("No patient data from server: '" + url.absoluteString + "'.")
        }
    }
    
    private func uploadEHRJsonDataToServer(sURL: String, fileName: String){
        let url = URL(string: sURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // insert json data to the request
        do{
            let filePath = self.hospitalDataDir + "/" + fileName + ".json"
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: jsonURL)
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
            }

            task.resume()
        }catch{
            print("Something went wrong with the '" + fileName + "' upload")
        }
    }

    private func uploadPatientEHRJsonDataToServer(){
    
        // See if the patient already exists
        var newPatientID = ""
        let sURL = Utilities.PATIENT_URL + "/"
        let fileName = Utilities.EHR_PATIENT_FILENAME
        
        let patientInfo = self.ExtractFirstNameLastNameBirthdayFromFile(fileName: Utilities.EHR_PATIENT_FILENAME)
        let verdict = self.doesRecordAlreadyExist(fhirResourceURL: Utilities.GetPatientURLByGivenFamilyBirthDate(family: patientInfo[1], given: patientInfo[0], birthDate: patientInfo[2]))
        
        // If there is a record on the server then skip and move onto related person
        // else upload the new record, get id, then add related person
        if(verdict.0){
            print("Patient Already exists on server")
            newPatientID = verdict.1
            self.uploadRelatedPersonEHRJsonDataToServer(patientID: newPatientID)
            return
        }
        
        let url = URL(string: sURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
        // insert json data to the request
        do{
            let filePath = self.hospitalDataDir + "/" + fileName + ".json"
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: jsonURL)
            request.httpBody = jsonData
        
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                    let issueArr = (responseJSON["issue"] as! NSArray)
                    let issueDict = (issueArr[0] as! NSDictionary)
                    let code = issueDict["code"] as! String
                    // If resonse it ok (informational), then obtain the new ID from the message
                    if(code == "informational"){
                        let sDiagnostics = issueDict["diagnostics"] as! String
                        newPatientID = Utilities.ExtractIDFromDiagnostics(regexPattern: Utilities.REGEX_PATIENT_ID, diagnostics: sDiagnostics, seperatorChar: "/")
                        
                        // This is for debugging purposes only, you may need to change this
                        // once a login system is established.
                        if(Utilities.patientID != newPatientID)
                        {
                            Utilities.UpdatePatiendID(newPatientID: newPatientID)
                        }
                    }
                }
                
                // Go to next upload
                self.uploadRelatedPersonEHRJsonDataToServer(patientID: newPatientID)
            }
        
            task.resume()
        }catch{
            print("Something went wrong with the '" + fileName + "' upload")
        }
    }
    
    private func uploadRelatedPersonEHRJsonDataToServer(patientID: String){
        var newRelatedPersonID = ""
        let sURL = Utilities.RELATED_PERSON_URL + "/"
        let fileName = Utilities.EHR_RELATED_PERSON_FILENAME
        
        let relationInfo = self.ExtractFirstNameLastNameBirthdayFromFile(fileName: Utilities.EHR_RELATED_PERSON_FILENAME)
        let verdict = self.doesRecordAlreadyExist(fhirResourceURL: Utilities.GetPatientRelationURLByGivenFamilyBirthDate(family: relationInfo[1], given: relationInfo[0], birthDate: relationInfo[2]))
        
        // Modify Patient reference in the file if patientID isn't empty
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: fileName, replaceWith: "Patient/"+patientID)
        }
        
        // If there is record then just update else add new one
        if(verdict.0){
            print("Related Person Already exists on server")
            newRelatedPersonID = verdict.1
            self.uploadBabyPatientEHRJsonDataToServer(relatedPersonID: newRelatedPersonID, patientID: patientID)
            return
        }
        
        // Modify Patient reference in the file if patientID isn't empty
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: fileName, replaceWith: "Patient/"+patientID)
        }
    
        let url = URL(string: sURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
        // insert json data to the request
        do{
            let filePath = self.hospitalDataDir + "/" + fileName + ".json"
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: jsonURL)
            request.httpBody = jsonData
        
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                    let issueArr = (responseJSON["issue"] as! NSArray)
                    let issueDict = (issueArr[0] as! NSDictionary)
                    let code = issueDict["code"] as! String
                    // If resonse it ok (informational), then obtain the new ID from the message
                    if(code == "informational"){
                        let sDiagnostics = issueDict["diagnostics"] as! String
                        newRelatedPersonID = Utilities.ExtractIDFromDiagnostics(regexPattern: Utilities.REGEX_RELATED_PERSON_ID, diagnostics: sDiagnostics, seperatorChar: "/")
                    }
                }
                
                // Go To Next Upload
                self.uploadBabyPatientEHRJsonDataToServer(relatedPersonID: newRelatedPersonID, patientID: patientID)
            }
        
            task.resume()
        }catch{
            print("Something went wrong with the '" + fileName + "' upload")
        }
    }
    
    private func uploadBabyPatientEHRJsonDataToServer(relatedPersonID: String, patientID: String){
        var newBabyID = ""
        let sURL = Utilities.PATIENT_URL + "/"
        let fileName = Utilities.EHR_PATIENT_BABY_FILENAME
        
        // See if the Baby patient already exists
        let patientInfo = self.ExtractFirstNameLastNameBirthdayFromFile(fileName: Utilities.EHR_PATIENT_BABY_FILENAME)
        let verdict = self.doesRecordAlreadyExist(fhirResourceURL: Utilities.GetPatientURLByGivenFamilyBirthDate(family: patientInfo[1], given: patientInfo[0], birthDate: patientInfo[2]))
        
        // Modify Patient reference in the file if patientID isn't empty
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_RELATED_PERSON, fileName: fileName, replaceWith: "RelatedPerson/"+relatedPersonID)
        }
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Baby Patient Already exists on server")
            newBabyID = verdict.1
            self.UploadRestOfEHRDataProcedure(patientID: patientID, babyPatientID: newBabyID)
            return
        }
        
        let url = URL(string: sURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
        // insert json data to the request
        do{
            let filePath = self.hospitalDataDir + "/" + fileName + ".json"
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonData = try Data(contentsOf: jsonURL)
            request.httpBody = jsonData
        
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                    
                    let issueArr = (responseJSON["issue"] as! NSArray)
                    let issueDict = (issueArr[0] as! NSDictionary)
                    let code = issueDict["code"] as! String
                    // If resonse it ok (informational), then obtain the new ID from the message
                    if(code == "informational"){
                        let sDiagnostics = issueDict["diagnostics"] as! String
                        newBabyID = Utilities.ExtractIDFromDiagnostics(regexPattern: Utilities.REGEX_PATIENT_ID, diagnostics: sDiagnostics, seperatorChar: "/")
                    }
                }
                
                // Go to next upload
                self.UploadRestOfEHRDataProcedure(patientID: patientID, babyPatientID: newBabyID)
                
            }
        
            task.resume()
        }catch{
            print("Something went wrong with the '" + fileName + "' upload")
        }
    }
    
    func ModifyJsonFileWithRegEx(regexPattern: String, fileName: String, replaceWith: String){
        do {
            let filePath = self.hospitalDataDir + "/" + fileName + ".json"
            let regexObj = try NSRegularExpression.init(pattern: regexPattern)
            
            let sNewString = "\"" + replaceWith + "\""
            
            let jsonURL = try URL(fileURLWithPath: filePath)
            let jsonString = try String.init(contentsOf: jsonURL)
            
            let stringRange = NSMakeRange(0, jsonString.count)
            
            let newJsonString = regexObj.stringByReplacingMatches(in: jsonString, options: [], range: stringRange, withTemplate: sNewString)
            
            var arrIndex = 0
            
            self.WriteJsonToHospitalDataDirectory(jsonContent: newJsonString, fileName: fileName)

        } catch {
            print("Unable to modify data in '" + fileName + "': No changes made.")
        }
    }
    
    func BeginUploadEHRDataProcedure(){
    
        self.uploadPatientEHRJsonDataToServer()
    }
    
    private func UploadRestOfEHRDataProcedure(patientID: String, babyPatientID: String){
    
        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_PATIENT_BMI_FILENAME))
        {
            self.uploadPatientBMIJson(patientID: patientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_PATIENT_DIABETES_FILENAME))
        {
            self.uploadPatientDiabetesJson(patientID: patientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_PATIENT_POLYOVARIAN_FILENAME))
        {
            self.uploadPatientPolyOvarianJson(patientID: patientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_PATIENT_GLANDULAR_FILENAME))
        {
            self.uploadPatientGlandularJson(patientID: patientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_PATIENT_BREAST_SURGERY_FILENAME))
        {
            self.uploadPatientBreastSurgeryJson(patientID: patientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_BIRTH_WEIGHT_FILENAME))
        {
            self.uploadBabyBirthWeightJson(babyID: babyPatientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_DISCHARGE_WEIGHT_FILENAME))
        {
            self.uploadBabyDischargeWeightJson(babyID: babyPatientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_DELIVERY_FILENAME))
        {
            self.uploadDeliveryJson(patientID: patientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_PATIENT_HYPERTHYROIDISM_FILENAME))
        {
            self.uploadHyperJson(patientID: patientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_PATIENT_HYPOTHYROIDISM_FILENAME))
        {
            self.uploadHypoJson(patientID: patientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_POSTPARTUM_HEMORRHAGE_FILENAME))
        {
            self.uploadPostpartumJson(patientID: patientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_GESTATIONAL_HYPERTENSION_FILENAME))
        {
            self.uploadGestationalJson(patientID: patientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_OBESITY_FILENAME))
        {
            self.uploadObesityJson(patientID: patientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_CYSTIC_FIBROSIS_FILENAME))
        {
            self.uploadCysticFibrosisJson(patientID: patientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_DEPRESSION_FILENAME))
        {
            self.uploadDepressionJson(patientID: patientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_AGALACTIA_FILENAME))
        {
            self.uploadAgalactiaJson(patientID: patientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_FAILED_EXTRACTION_FILENAME))
        {
            self.uploadFailedExtractionJson(patientID: patientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_DELIVERY_OUTCOME_FILENAME))
        {
            self.uploadDeliveryOutcomeJson(patientID: patientID)
        }

        if(self.DoesFileExistInHospitalDataDirectory(fileName: Utilities.EHR_SUPERVISION_LACTATE_FILENAME))
        {
            self.uploadSupervisionJson(patientID: patientID)
        }
        
    }
    
    private func uploadPatientBMIJson(patientID: String){
    
        // Modify Patient reference in the file if patientID isn't empty
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_PATIENT_BMI_FILENAME, replaceWith: "Patient/"+patientID)
        }
    
        // See if the Patient BMI already exists
        let subjectReference = self.ExtractObservationReferenceFromFile(fileName: Utilities.EHR_PATIENT_BMI_FILENAME)
        let verdict = self.doesRecordAlreadyExist(fhirResourceURL: Utilities.GetObservationURLByPatientReferenceAndCode(patientReference: subjectReference, code: Utilities.BMI_CODE))
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("BMI Already exists on server")
            return
        }
        
        self.uploadEHRJsonDataToServer(sURL: Utilities.OBSERVATION_URL + "/", fileName: Utilities.EHR_PATIENT_BMI_FILENAME)
    }
    
    private func uploadPatientDiabetesJson(patientID: String){
        // Modify Patient reference in the file if patientID isn't empty
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_PATIENT_DIABETES_FILENAME, replaceWith: "Patient/"+patientID)
        }
        
        // See if the Patient Diabetes already exists
        let patientReferenceCode = self.ExtractClaimDiagnosisReferenceAndCodeFromFile(fileName: Utilities.EHR_PATIENT_DIABETES_FILENAME, codeHeurs: Utilities.DIABETES_CODES)
        let verdict = self.doesClaimRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetPatientClaimsURLByPatientReference(patientReference: patientReferenceCode.0), code: patientReferenceCode.1)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Diabetes Already exists on server")
            return
        }
        
        self.uploadEHRJsonDataToServer(sURL: Utilities.CLAIM_URL + "/", fileName: Utilities.EHR_PATIENT_DIABETES_FILENAME)
    }
    
    private func uploadPatientPolyOvarianJson(patientID: String){
    
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_PATIENT_POLYOVARIAN_FILENAME, replaceWith: "Patient/"+patientID)
        }
        
    
        // See if the Patient PolyOvarian already exists
        let patientReferenceCode = self.ExtractClaimDiagnosisReferenceAndCodeFromFile(fileName: Utilities.EHR_PATIENT_POLYOVARIAN_FILENAME, codeHeur: Utilities.POLYCYSTIC_OVARIAN_CODE)
        let verdict = self.doesClaimRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetPatientClaimsURLByPatientReference(patientReference: patientReferenceCode.0), code: patientReferenceCode.1)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Polycystic Ovarian Already exists on server")
            return
        }
        self.uploadEHRJsonDataToServer(sURL: Utilities.CLAIM_URL + "/", fileName: Utilities.EHR_PATIENT_POLYOVARIAN_FILENAME)
    }
    
    private func uploadPatientGlandularJson(patientID: String){
        
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_PATIENT_GLANDULAR_FILENAME, replaceWith: "Patient/"+patientID)
        }
        
        // See if the Patient Glandular already exists
        let patientReferenceCode = self.ExtractClaimDiagnosisReferenceAndCodeFromFile(fileName: Utilities.EHR_PATIENT_GLANDULAR_FILENAME, codeHeur: Utilities.PRIMARY_GLANDULAR_INSUFFICIENCEY_CODE)
        let verdict = self.doesClaimRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetPatientClaimsURLByPatientReference(patientReference: patientReferenceCode.0), code: patientReferenceCode.1)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Glandular Already exists on server")
            return
        }
        
        self.uploadEHRJsonDataToServer(sURL: Utilities.CLAIM_URL + "/", fileName: Utilities.EHR_PATIENT_GLANDULAR_FILENAME)
    }
    
    private func uploadPatientBreastSurgeryJson(patientID: String){
        
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_PATIENT_BREAST_SURGERY_FILENAME, replaceWith: "Patient/"+patientID)
        }
        
        // See if the Patient Breast Surgery already exists
        let patientReferenceCode = self.ExtractClaimDiagnosisReferenceAndCodeFromFile(fileName: Utilities.EHR_PATIENT_BREAST_SURGERY_FILENAME, codeHeur: Utilities.BREAST_PATHOLOGY_SURGERY_CODE)
        let verdict = self.doesClaimRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetPatientClaimsURLByPatientReference(patientReference: patientReferenceCode.0), code: patientReferenceCode.1)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Breast Surgery Already exists on server")
            return
        }
        
        self.uploadEHRJsonDataToServer(sURL: Utilities.CLAIM_URL + "/", fileName: Utilities.EHR_PATIENT_BREAST_SURGERY_FILENAME)
    }
    
    private func uploadBabyBirthWeightJson(babyID: String){
        
        if(!babyID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_BIRTH_WEIGHT_FILENAME, replaceWith: "Patient/"+babyID)
        }
        
        // See if the Patient Birth Weight already exists
        let patientReferenceCode = self.ExtractObservationReferenceFromFile(fileName: Utilities.EHR_BIRTH_WEIGHT_FILENAME)
        let verdict = self.doesObservationRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetObservationURLByPatientReferenceAndCode(patientReference: patientReferenceCode, code: Utilities.BIRTH_WEIGHT_CODE), code: Utilities.BIRTH_WEIGHT_CODE)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Birth Weight Already exists on server")
            return
        }
        
        self.uploadEHRJsonDataToServer(sURL: Utilities.OBSERVATION_URL + "/", fileName: Utilities.EHR_BIRTH_WEIGHT_FILENAME)
    }
    
    private func uploadBabyDischargeWeightJson(babyID: String){
        
        if(!babyID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_DISCHARGE_WEIGHT_FILENAME, replaceWith: "Patient/"+babyID)
        }
        
        // See if the Baby Discharge Weight already exists
        let patientReferenceCode = self.ExtractObservationReferenceFromFile(fileName: Utilities.EHR_DISCHARGE_WEIGHT_FILENAME)
        let verdict = self.doesObservationRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetObservationURLByPatientReferenceAndCode(patientReference: patientReferenceCode, code: Utilities.DISCHARGE_WEIGHT_CODE), code: Utilities.DISCHARGE_WEIGHT_CODE)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Baby Discharge Weight Already exists on server")
            return
        }
        
        self.uploadEHRJsonDataToServer(sURL: Utilities.OBSERVATION_URL + "/", fileName: Utilities.EHR_DISCHARGE_WEIGHT_FILENAME)
    }
    
    private func uploadDeliveryJson(patientID: String){
        
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_DELIVERY_FILENAME, replaceWith: "Patient/"+patientID)
        }
        
        // See if Delivery already exists
        let patientReferenceCode = self.ExtractClaimProcedureReferenceAndCodeFromFile(fileName: Utilities.EHR_DELIVERY_FILENAME, codeHeurs: Utilities.DELIVERY_CODES)
        let verdict = self.doesClaimRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetPatientClaimsURLByPatientReference(patientReference: patientReferenceCode.0), code: patientReferenceCode.1)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Delivery Already exists on server")
            return
        }
        
        self.uploadEHRJsonDataToServer(sURL: Utilities.CLAIM_URL + "/", fileName: Utilities.EHR_DELIVERY_FILENAME)
    }
    
    private func uploadHyperJson(patientID: String){
        
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_PATIENT_HYPERTHYROIDISM_FILENAME, replaceWith: "Patient/"+patientID)
        }
        
        // See if Hyperthyroidism already exists
        let patientReferenceCode = self.ExtractClaimDiagnosisReferenceAndCodeFromFile(fileName: Utilities.EHR_PATIENT_HYPERTHYROIDISM_FILENAME, codeHeur: Utilities.HYPERTHYROIDISM_CODE)
        let verdict = self.doesClaimRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetPatientClaimsURLByPatientReference(patientReference: patientReferenceCode.0), code: patientReferenceCode.1)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Hyper Already exists on server")
            return
        }
        
        self.uploadEHRJsonDataToServer(sURL: Utilities.CLAIM_URL + "/", fileName: Utilities.EHR_PATIENT_HYPERTHYROIDISM_FILENAME)
    }
    
    private func uploadHypoJson(patientID: String){
        
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_PATIENT_HYPOTHYROIDISM_FILENAME, replaceWith: "Patient/"+patientID)
        }

        // See if Hypothyroidism already exists
        let patientReferenceCode = self.ExtractClaimDiagnosisReferenceAndCodeFromFile(fileName: Utilities.EHR_PATIENT_HYPOTHYROIDISM_FILENAME, codeHeur: Utilities.HYPOTHYROIDISM_CODE)
        let verdict = self.doesClaimRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetPatientClaimsURLByPatientReference(patientReference: patientReferenceCode.0), code: patientReferenceCode.1)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Hypo Already exists on server")
            return
        }

        self.uploadEHRJsonDataToServer(sURL: Utilities.CLAIM_URL + "/", fileName: Utilities.EHR_PATIENT_HYPOTHYROIDISM_FILENAME)
    }
    
    private func uploadPostpartumJson(patientID: String){
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_POSTPARTUM_HEMORRHAGE_FILENAME, replaceWith: "Patient/"+patientID)
        }
        
        
        // See if Postpartum Hemorrhage already exists
        let patientReferenceCode = self.ExtractClaimDiagnosisReferenceAndCodeFromFile(fileName: Utilities.EHR_POSTPARTUM_HEMORRHAGE_FILENAME, codeHeur: Utilities.POSTPARTUM_HEMORRHAGE_CODE)
        let verdict = self.doesClaimRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetPatientClaimsURLByPatientReference(patientReference: patientReferenceCode.0), code: patientReferenceCode.1)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Postpartum Hemorrhage Already exists on server")
            return
        }
        
        
        self.uploadEHRJsonDataToServer(sURL: Utilities.CLAIM_URL + "/", fileName: Utilities.EHR_POSTPARTUM_HEMORRHAGE_FILENAME)
    }
    
    private func uploadGestationalJson(patientID: String){
        
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_GESTATIONAL_HYPERTENSION_FILENAME, replaceWith: "Patient/"+patientID)
        }
        
        // See if Gestational Hypertension already exists
        let patientReferenceCode = self.ExtractClaimDiagnosisReferenceAndCodeFromFile(fileName: Utilities.EHR_GESTATIONAL_HYPERTENSION_FILENAME, codeHeur: Utilities.GESTATIONAL_HYPERTENSION_CODE)
        let verdict = self.doesClaimRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetPatientClaimsURLByPatientReference(patientReference: patientReferenceCode.0), code: patientReferenceCode.1)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Gestaional Hypertension Already exists on server")
            return
        }
        
        self.uploadEHRJsonDataToServer(sURL: Utilities.CLAIM_URL + "/", fileName: Utilities.EHR_GESTATIONAL_HYPERTENSION_FILENAME)
    }
    
    private func uploadObesityJson(patientID: String){
        
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_OBESITY_FILENAME, replaceWith: "Patient/"+patientID)
        }
        
        // See if Obesity already exists
        let patientReferenceCode = self.ExtractClaimDiagnosisReferenceAndCodeFromFile(fileName: Utilities.EHR_OBESITY_FILENAME, codeHeur: Utilities.OBESITY_CODE)
        let verdict = self.doesClaimRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetPatientClaimsURLByPatientReference(patientReference: patientReferenceCode.0), code: patientReferenceCode.1)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Obesity Already exists on server")
            return
        }
        
        self.uploadEHRJsonDataToServer(sURL: Utilities.CLAIM_URL + "/", fileName: Utilities.EHR_OBESITY_FILENAME)
    }
    
    private func uploadCysticFibrosisJson(patientID: String){
        
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_CYSTIC_FIBROSIS_FILENAME, replaceWith: "Patient/"+patientID)
        }
        
        // See if Cystic Fibrosis already exists
        let patientReferenceCode = self.ExtractClaimDiagnosisReferenceAndCodeFromFile(fileName: Utilities.EHR_CYSTIC_FIBROSIS_FILENAME, codeHeur: Utilities.CYSTIC_FIBROSIS_CODE)
        let verdict = self.doesClaimRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetPatientClaimsURLByPatientReference(patientReference: patientReferenceCode.0), code: patientReferenceCode.1)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Cystic Fibrosis Already exists on server")
            return
        }

        self.uploadEHRJsonDataToServer(sURL: Utilities.CLAIM_URL + "/", fileName: Utilities.EHR_CYSTIC_FIBROSIS_FILENAME)
    }
    
    private func uploadDepressionJson(patientID: String){
        
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_DEPRESSION_FILENAME, replaceWith: "Patient/"+patientID)
        }
        
        
        // See if Depression already exists
        let patientReferenceCode = self.ExtractClaimDiagnosisReferenceAndCodeFromFile(fileName: Utilities.EHR_DEPRESSION_FILENAME, codeHeur: Utilities.DEPRESSION_CODE)
        let verdict = self.doesClaimRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetPatientClaimsURLByPatientReference(patientReference: patientReferenceCode.0), code: patientReferenceCode.1)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Depression Already exists on server")
            return
        }

        self.uploadEHRJsonDataToServer(sURL: Utilities.CLAIM_URL + "/", fileName: Utilities.EHR_DEPRESSION_FILENAME)
    }
    
    private func uploadAgalactiaJson(patientID: String){
        
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_AGALACTIA_FILENAME, replaceWith: "Patient/"+patientID)
        }
        
        // See if Agalactia already exists
        let patientReferenceCode = self.ExtractClaimDiagnosisReferenceAndCodeFromFile(fileName: Utilities.EHR_AGALACTIA_FILENAME, codeHeur: Utilities.AGALACTIA_CODE)
        let verdict = self.doesClaimRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetPatientClaimsURLByPatientReference(patientReference: patientReferenceCode.0), code: patientReferenceCode.1)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Agalactia Already exists on server")
            return
        }
        
        self.uploadEHRJsonDataToServer(sURL: Utilities.CLAIM_URL + "/", fileName: Utilities.EHR_AGALACTIA_FILENAME)
    }
    
    private func uploadFailedExtractionJson(patientID: String){
        
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_FAILED_EXTRACTION_FILENAME, replaceWith: "Patient/"+patientID)
        }
        
        // See if Failed Extraction already exists
        let patientReferenceCode = self.ExtractClaimDiagnosisReferenceAndCodeFromFile(fileName: Utilities.EHR_FAILED_EXTRACTION_FILENAME, codeHeur: Utilities.FAILED_EXTRACTION_CODE)
        let verdict = self.doesClaimRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetPatientClaimsURLByPatientReference(patientReference: patientReferenceCode.0), code: patientReferenceCode.1)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Failed Extraction Already exists on server")
            return
        }
        
        self.uploadEHRJsonDataToServer(sURL: Utilities.CLAIM_URL + "/", fileName: Utilities.EHR_FAILED_EXTRACTION_FILENAME)
    }
    
    private func uploadDeliveryOutcomeJson(patientID: String){
    
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_DELIVERY_OUTCOME_FILENAME, replaceWith: "Patient/"+patientID)
        }
    
        // See if Delivery Outcome already exists
        let patientReferenceCode = self.ExtractClaimDiagnosisReferenceAndCodeFromFile(fileName: Utilities.EHR_DELIVERY_OUTCOME_FILENAME, codeHeur: Utilities.DELIVERY_OUTCOME_CODE)
        let verdict = self.doesClaimRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetPatientClaimsURLByPatientReference(patientReference: patientReferenceCode.0), code: patientReferenceCode.1)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Delivery Outcome Already exists on server")
            return
        }
        
        self.uploadEHRJsonDataToServer(sURL: Utilities.CLAIM_URL + "/", fileName: Utilities.EHR_DELIVERY_OUTCOME_FILENAME)
    }
    
    private func uploadSupervisionJson(patientID: String){
        
        if(!patientID.isEmpty){
            ModifyJsonFileWithRegEx(regexPattern: Utilities.REGEX_PATIENT, fileName: Utilities.EHR_SUPERVISION_LACTATE_FILENAME, replaceWith: "Patient/"+patientID)
        }
        
        // See if Supervision already exists
        let patientReferenceCode = self.ExtractClaimDiagnosisReferenceAndCodeFromFile(fileName: Utilities.EHR_SUPERVISION_LACTATE_FILENAME, codeHeur: Utilities.SUPERVISION_LACTATE_CODE)
        let verdict = self.doesClaimRecordWithCodeAlreadyExist(fhirResourceURL: Utilities.GetPatientClaimsURLByPatientReference(patientReference: patientReferenceCode.0), code: patientReferenceCode.1)
        
        // If there is a record on the server then skip, else add it
        if(verdict.0){
            print("Supervision Already exists on server")
            return
        }
        
        self.uploadEHRJsonDataToServer(sURL: Utilities.CLAIM_URL + "/", fileName: Utilities.EHR_SUPERVISION_LACTATE_FILENAME)
    }
   
    private func doesObservationRecordWithCodeAlreadyExist(fhirResourceURL: String, code: String) -> (Bool, String){
        let url = URL(string: fhirResourceURL)!

        var foundRecord = false
        var recordID = ""

        // pull data from fhir and get the latest
        do {
            let data = NSData(contentsOf: url)

            if (data == nil){
                print ("Unable to connect to server '" + url.absoluteString + "'.")
                return (foundRecord, recordID)
            }

            if let json = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? [String: Any]
            {

                var count = 0
                count = json["total"] as! Int

                if(count > 0){

                    // parse json data from fhir into BreastfeedingData
                    // parse json data from fhir into BreastfeedingData
                    let responseEntry : NSArray = json["entry"] as! NSArray
                    
                    for response in responseEntry {
                        let resourceDict = (response as! NSDictionary)["resource"] as! NSDictionary
                        let resourceDictKeys = resourceDict.allKeys as! [String]
                        
                        if(resourceDictKeys.contains("code")){
                            let codeDict = resourceDict["code"] as! NSDictionary
                            let codeDictKeys = codeDict.allKeys as! [String]
                            if(codeDictKeys.contains("coding")){
                                let codingArr = codeDict["coding"] as! NSArray
                                for i in codingArr{
                                    let dict1 = i as! NSDictionary
                                    let dict1Keys = dict1.allKeys as! [String]
                                    if(dict1Keys.contains("code")){
                                        let codeVal = dict1["code"] as! String
                                        if (codeVal.contains(code)){
                                            foundRecord = true
                                            recordID = (resourceDict["id"] as? String)!
                                            return (foundRecord, recordID)
                                        }
                                    }

                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("error in JSONSerialization")
        }
        return (foundRecord, recordID)
    }
   
    private func doesRecordAlreadyExist(fhirResourceURL: String) -> (Bool, String){
        let url = URL(string: fhirResourceURL)!

        var foundRecord = false
        var recordID = ""

        // pull data from fhir and get the latest
        do {
            let data = NSData(contentsOf: url)

            if (data == nil){
                print ("Unable to connect to server '" + url.absoluteString + "'.")
                return (foundRecord, recordID)
            }

            if let json = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? [String: Any]
            {

                var count = 0
                count = json["total"] as! Int

                if(count == 1){

                    // parse json data from fhir into BreastfeedingData
                    let responseEntry : NSArray = json["entry"] as! NSArray
                    for response in responseEntry {

                        let d2 = (response as! NSDictionary)["resource"] as! NSDictionary
                        recordID = (d2["id"] as? String)!
                        foundRecord = true
                        break

                    }
                }
            }
        } catch {
            print("error in JSONSerialization")
        }
            return (foundRecord, recordID)
    }
    
    private func doesClaimRecordWithCodeAlreadyExist(fhirResourceURL: String, code: String) -> (Bool, String){
        let url = URL(string: fhirResourceURL)!

        var foundRecord = false
        var recordID = ""

        // pull data from fhir and get the latest
        do {
            let data = NSData(contentsOf: url)

            if (data == nil){
                print ("Unable to connect to server '" + url.absoluteString + "'.")
                return (foundRecord, recordID)
            }

            if let json = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? [String: Any]
            {

                var count = 0
                count = json["total"] as! Int

                if(count > 0){

                    // parse json data from fhir into BreastfeedingData
                    // parse json data from fhir into BreastfeedingData
                    let responseEntry : NSArray = json["entry"] as! NSArray
                    
                    for response in responseEntry {
                        let resourceDict = (response as! NSDictionary)["resource"] as! NSDictionary
                        let resourceDictKeys = resourceDict.allKeys as! [String]
                        if(resourceDictKeys.contains("diagnosis")){
                            let diagnosisArr = resourceDict["diagnosis"] as! NSArray
                            for i in diagnosisArr{
                                let dict1 = i as! NSDictionary
                                let dict1Keys = dict1.allKeys as! [String]
                                if(dict1Keys.contains("diagnosisCodeableConcept")){
                                    let procedureCodeDict = dict1["diagnosisCodeableConcept"] as! NSDictionary
                                    let procedureCodeDictKeys = procedureCodeDict.allKeys as! [String]
                                    if(procedureCodeDictKeys.contains("coding")){
                                        let codeArr = procedureCodeDict["coding"] as! NSArray
                                        for i in codeArr{
                                            let codeDict = i as!NSDictionary
                                            let sCode = codeDict["code"] as! String
                                            if(sCode.contains(code)){
                                                recordID = (resourceDict["id"] as? String)!
                                                foundRecord = true
                                                return (foundRecord, recordID)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if(resourceDictKeys.contains("procedure")){
                            let procedureArr = resourceDict["procedure"] as! NSArray
                            for i in procedureArr{
                                let dict1 = i as! NSDictionary
                                let dict1Keys = dict1.allKeys as! [String]
                                if(dict1Keys.contains("procedureCodeableConcept")){
                                    let procedureCodeDict = dict1["procedureCodeableConcept"] as! NSDictionary
                                    let procedureCodeDictKeys = procedureCodeDict.allKeys as! [String]
                                    if( procedureCodeDictKeys.contains("coding")){
                                        let codeArr = procedureCodeDict["coding"] as! NSArray
                                        for i in codeArr{
                                            let codeDict = i as!NSDictionary
                                            let sCode = codeDict["code"] as! String
                                            if(sCode.contains(code)){
                                                recordID = (resourceDict["id"] as? String)!
                                                foundRecord = true
                                                return (foundRecord, recordID)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("error in JSONSerialization")
        }
        return (foundRecord, recordID)
    }
}
