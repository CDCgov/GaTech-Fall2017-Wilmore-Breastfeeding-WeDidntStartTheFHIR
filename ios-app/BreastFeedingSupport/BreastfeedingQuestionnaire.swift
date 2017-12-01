//
//  BreastfeedingQuestionnaire.swift
//  BreastFeedingSupport
//
//  Created by CHONG W GUO on 4/16/17.
//

//the class for breastfeeding questionnaire
import Foundation

class BreastfeedingQuestionnaire{
    
    
    var patientID : String = ""
    var hasMilkComeIn : Bool = true
    var isStoolMustard : Bool = true
    
    init(){
         patientID = ""
         hasMilkComeIn = true
         isStoolMustard = true
    }
    init(patientID: String, hasMilkComeIn: Bool, isStoolMustard : Bool){
        self.patientID = patientID
        self.hasMilkComeIn = hasMilkComeIn
        self.isStoolMustard = isStoolMustard
    }
}
