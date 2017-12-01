//
//  Utilities.swift
//  BreastFeedingSupport
//
//  Created by Justin Kristensen on 11/3/17.
//

import Foundation

class Utilities {

    // Patient IDs
    // DEBUGGING ONLY Remove once final product is released
    static let CESECTION_ID = "Patient/1"
    static let CISTICA_ID = "Patient/8"
    
    //Once Logging in is implemented, then this needs to be updated or a new way of keeping track of patientID is needed
    static var patientID : String = "Patient/1"
    
    // Server URLs
    static let HOSPITAL_SERVER_URL = "http://localhost:8080/baseDstu3" // Once there is an EHR server, replace this with the server URL
    static let CARE_PROVIDER_SERVER_URL = "http://localhost:8080/baseDstu3"
    
    // Specific Care Provider FHIR Server Resource URLS
    static let QUESTIONNAIRE_RESPONSE_URL = "http://localhost:8080/baseDstu3/QuestionnaireResponse"
    static let PATIENT_URL = "http://localhost:8080/baseDstu3/Patient"
    static let RELATED_PERSON_URL = "http://localhost:8080/baseDstu3/RelatedPerson"
    static let OBSERVATION_URL = "http://localhost:8080/baseDstu3/Observation"
    static let CLAIM_URL = "http://localhost:8080/baseDstu3/Claim"
    
    // Hospital Json Filenames
    static let EHR_PATIENT_FILENAME = "patient" // Patient
    static let EHR_RELATED_PERSON_FILENAME = "relatedPerson" // RelatedPerson
    static let EHR_PATIENT_BMI_FILENAME = "patientBMI" // Observation
    static let EHR_PATIENT_DIABETES_FILENAME = "patientDiabetes" // Claim
    static let EHR_PATIENT_POLYOVARIAN_FILENAME = "patientPolyOverian" // Claim
    static let EHR_PATIENT_BABY_FILENAME = "patientBaby" // Patient
    static let EHR_BIRTH_WEIGHT_FILENAME = "babyBirthWeight" // Observation
    static let EHR_DELIVERY_FILENAME = "delivery" // Claim
    static let EHR_DISCHARGE_WEIGHT_FILENAME = "dischargeWeight" // Observation
    static let EHR_PATIENT_BREAST_SURGERY_FILENAME = "patientBreastSurgery" // Claim
    static let EHR_PATIENT_HYPERTHYROIDISM_FILENAME = "hyperthyroidism" // Claim
    static let EHR_PATIENT_HYPOTHYROIDISM_FILENAME = "hypothyroidism" // Claim
    static let EHR_POSTPARTUM_HEMORRHAGE_FILENAME = "postpartumHemorrhage" // Claim
    static let EHR_GESTATIONAL_HYPERTENSION_FILENAME = "gestationalHypertension" // Claim
    static let EHR_OBESITY_FILENAME = "obesity" // Claim
    static let EHR_CYSTIC_FIBROSIS_FILENAME = "cysticFibrosis" // Claim
    static let EHR_DEPRESSION_FILENAME = "depression" // Claim
    static let EHR_AGALACTIA_FILENAME = "agalactia" // Claim
    static let EHR_PATIENT_GLANDULAR_FILENAME = "patientGlandular" // Claim
    static let EHR_FAILED_EXTRACTION_FILENAME = "failedExtraction" // Claim
    static let EHR_DELIVERY_OUTCOME_FILENAME = "deliveryOutcome" // Claim
    static let EHR_SUPERVISION_LACTATE_FILENAME = "supervisionLactate" // Claim
    
    
    // ICD-10 CODES
    static let DIABETES_CODES = ["E10.", "E11.", "E13."]
    static let DELIVERY_CODES = ["O82.", "O80.", "O81.5"]
    static let POLYCYSTIC_OVARIAN_CODE = "E28.2"
    static let HYPERTHYROIDISM_CODE = "E05.90"
    static let HYPOTHYROIDISM_CODE = "E03.9"
    static let BREAST_PATHOLOGY_SURGERY_CODE = "C50."
    static let PRIMARY_GLANDULAR_INSUFFICIENCEY_CODE = "O92.79"
    static let POSTPARTUM_HEMORRHAGE_CODE = "O72."
    static let GESTATIONAL_HYPERTENSION_CODE = "O13.9"
    static let OBESITY_CODE = "E66."
    static let CYSTIC_FIBROSIS_CODE = "E84.0"
    static let DEPRESSION_CODE = "F33."
    static let AGALACTIA_CODE = "O92."
    static let FAILED_EXTRACTION_CODE = "O66.5"
    static let DELIVERY_OUTCOME_CODE = "Z37."
    static let DELIVERY_OUTCOME_EXCLUDE_CODES = ["Z37.1", "Z37.4", "Z37.7", "Z37.9"]
    static let SUPERVISION_LACTATE_CODE = "Z39.1"

    // OTHER CODES
    static let BIRTH_WEIGHT_CODE = "8339-4"
    static let DISCHARGE_WEIGHT_CODE = "3141-9"
    static let BMI_CODE = "39156-5"
    
    // Regex
    static let REGEX_RELATED_PERSON = "\"RelatedPerson/[0-9]*\""
    static let REGEX_PATIENT = "\"Patient\\/[0-9]*\""
    static let REGEX_PATIENT_ID = "Patient\\/[0-9]*\\/_history"
    static let REGEX_RELATED_PERSON_ID = "RelatedPerson\\/[0-9]*\\/_history"
    static let REGEX_ID_NUMBER = "^\\d+$"

    static func UpdatePatiendID(newPatientID: String)
    {
        self.patientID = newPatientID
    }
    
    // URL Generators
    static func GetQuestionnaireResponseSourceSearchURL(sPatientID: String) -> String
    {
        return self.QUESTIONNAIRE_RESPONSE_URL+"?source=\(sPatientID)"
//        return "http://localhost:8080/baseDstu3/QuestionnaireResponse?source=\(sPatientID)"
    }
    
    static func GetPatientByIDURL(sPatientID: String) -> String
    {
        return self.CARE_PROVIDER_SERVER_URL + "/" + sPatientID
    }
    
    static func GetQuestionnaireResponseURL (questionnaireID: String) -> String
    {
        return self.QUESTIONNAIRE_RESPONSE_URL+"/\(questionnaireID)"
//        return "http://localhost:8080/baseDstu3/QuestionnaireResponse/\(questionnaireID)"
    }
    
    static func GetPatientURL(sPatientID: String) -> String
    {
        return self.PATIENT_URL+"/\(sPatientID)"
//        return "http://localhost:8080/baseDstu3/Patient/\(sPatientID)"
    }
    
    static func GetRelatedPersonURL(relatedPersonID: String) -> String
    {
        return self.RELATED_PERSON_URL+"/\(relatedPersonID)"
//        return "http://localhost:8080/baseDstu3/RelatedPerson/\(relatedPersonID)"
    }
    
    static func GetPatientURLByGivenFamilyBirthDate(family:String, given:String, birthDate:String) -> String
    {
        return self.PATIENT_URL+"?family=\(family)&given=\(given)&birthdate=\(birthDate)"
        //let url = URL(string: Utilities.PATIENT_URL+"?family=\(patientInfo[1])&given=\(patientInfo[0])&birthdate=\(patientInfo[2])")!
    }
    
    static func GetPatientRelationURLByGivenFamilyBirthDate(family:String, given:String, birthDate:String) -> String
    {
        return self.RELATED_PERSON_URL+"?name:family=\(family)&name:given=\(given)&birthdate=\(birthDate)"
        //let url = URL(string: Utilities.RELATED_PERSON_URL + "?name:family=\(recordInfo[1])&name:given=\(recordInfo[0])&birthdate=\(recordInfo[2])")!
    }
    
    static func GetPatientClaimsURLByPatientReference(patientReference:String) -> String
    {
        return self.CLAIM_URL+"?patient:reference=\(patientReference)"
    }
    
    static func GetObservationURLByPatientReferenceAndCode(patientReference: String, code: String) -> String
    {
        return self.OBSERVATION_URL+"?subject:reference=\(patientReference)&code=\(code)"
    }
    
    
    // Other Utility Functions
    //convert string to dictionary
    static func ConvertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func GetDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }
    
    static func GetMetaDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HHmmss.SSSZ"
        
        return dateFormatter
    }
    
    static func GetBirthTimeDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter
    }
    
    static func GetAppBirthTimeDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        
        return dateFormatter
    }
    
    static func GetTimeFormatterMTime() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH-mm-ss"
        
        return dateFormatter
    }
    
    static func ParseOutMinutes(sMinutes:String) -> Double {
        let sMinComponent = sMinutes.components(separatedBy: " ")
        
        return Double(sMinComponent[0])!
    }
    
    static func GetTimeFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter
    }
    
    static func SumIntArray(iArray: [Int]) -> Int? {
        if(iArray.isEmpty){
            return nil
        }
        var result = 0
        for num in iArray{
            result += num
        }
        return result
    }
    
    static func MaxInDoubleArray(dArray: [Double]) -> Double? {
        if(dArray.isEmpty){
            return nil
        }
        var result = dArray[0]
        for num in dArray{
            if (num > result){
                result = num
            }
        }
        return result
    }
    
    static func AverageInDoubleArray(dArray: [Double]) -> Double? {
        if(dArray.isEmpty){
            return nil
        }
        var sumResult = 0.0
        let numInArr = Double(dArray.count)
        
        for num in dArray{
            sumResult += num
        }
        
        return (sumResult/numInArr)
    }
    
    static func MedianInDoubleArray(dArray: [Double]) -> Double? {
        if(dArray.isEmpty){
            return nil
        }
        let sortedArr = dArray.sorted()
        let numInArr = dArray.count
        var isEven = false
        
        if(numInArr % 2 == 0){
            isEven = true
        }
        
        if(isEven){
            let firstIndex = numInArr/2
            let secondIndex = firstIndex - 1
            
            return ((sortedArr[firstIndex] + sortedArr[secondIndex])/2.0)
            
        } else {
            let index = numInArr/2
            return sortedArr[index]
        }
    }

    // Compares the days of two dates, ignores the time.
    // Returns 1 if first date is later, 2 if the second date is later, or 0 if both dates are the same.
    static func CompareDatesNoTime(date1: Date, date2: Date) -> Int{
    
        let result = Calendar.current.compare(date1, to: date2, toGranularity: Calendar.Component.day)
    
        if(result == ComparisonResult.orderedAscending){
            return 2
        } else if (result == ComparisonResult.orderedDescending){
            return 1
        } else{
            return 0
        }
    }
    
    static func FindAge(birthDate: Date) -> String{
    
        let result = Calendar.current.dateComponents([.year], from: birthDate, to: Date())
        return String(describing: result.year!)
    }
    
    // Formula obtained from : http://www.rapidtables.com/convert/weight/gram-to-pound.htm
    static func ConvertGramsToPounds(grams: Double) -> Double{
        return (grams / 453.59237)
    }
    
    static func ExtractIDFromDiagnostics(regexPattern: String, diagnostics: String, seperatorChar: String) -> String{
        var id = ""
        do{
            let regexObj = try NSRegularExpression.init(pattern: regexPattern)
            
            // Extract the String
            // Code
            /****************************************************************************************
             #*    Title: Swift extract regex matches
             #*    Author: Rob Mecham
             #*    Date: 17 Oct 2016
             #*    Code version: N/A
             #*    Availability: https://stackoverflow.com/questions/27880650/swift-extract-regex-matches
             #*    Date Retrived: 15 Nov 2017
             ****************************************************************************************/
            let nsString = NSString(string: diagnostics)
            let results = regexObj.matches(in: diagnostics, options: [], range: NSRange(location: 0, length: nsString.length))
            let stringResult = results.map { nsString.substring(with: $0.range) }
            /***************************************************************************************
            #*    END OF CITATION
            ****************************************************************************************/
            
            let stringComp = stringResult.first?.components(separatedBy: seperatorChar)
            id = stringComp![1]
            
        }catch {
        }
        return id
    }
}
