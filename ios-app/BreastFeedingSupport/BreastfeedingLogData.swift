//
//  BreastfeedingLogData.swift
//  BreastFeedingSupport
//
//  Created by Justin Kristensen on 11/5/17.
//

import Foundation

class BreastfeedingLogData{

    var patientID : String = ""
    var sStart = ""
    var sStop = ""
    var sDuration = ""
    var sDate = ""
    var sTime = ""
    var diaperCount = ""
    var date: Date
    
    init(){
        patientID = ""
        sStart = ""
        sStop = ""
        sDuration = ""
        sDate = ""
        sTime = ""
        diaperCount = ""
        date = Date()
        
    }
    init(patientID: String, sDate: String, sTime: String, sStart: String, sStop: String, sduration: String, diaperCount: String, date:Date){
        self.patientID = patientID
        self.sDate = sDate
        self.sTime = sTime
        self.sStart = sStart
        self.sStop = sStop
        self.sDuration = sduration
        self.diaperCount = diaperCount
        self.date = date
    }
}
