//
//  BreastfeedingDailyData.swift
//  BreastFeedingSupport
//
//  Created by CHONG W GUO on 4/6/17.
//

//the class for Breastfeeding data 
import Foundation

class BreastfeedingDailyData{
    var patientID: String
    var sDate: String
    var totalFeedings: String
    var medianGap: String
    var averageLength: String
    var maximumGap: String
    var totalWetDiapers: String
    
    init(){
        patientID = ""
        sDate = ""
        totalFeedings = ""
        medianGap = ""
        averageLength = ""
        maximumGap = ""
        totalWetDiapers = ""
    }
    
    init(patientID: String, sDate: String, totalFeedings: String, medianGap: String, averageLength: String, maximumGap: String, totalWetDiapers: String){
        self.patientID = patientID
        self.sDate = sDate
        self.totalFeedings = totalFeedings
        self.medianGap = medianGap
        self.averageLength = averageLength
        self.maximumGap = maximumGap
        self.totalWetDiapers = totalWetDiapers
    }
}
