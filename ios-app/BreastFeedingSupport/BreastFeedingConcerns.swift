//
//  BreastFeedingConcerns.swift
//  BreastFeedingSupport
//
//  Created by Justin Kristensen on 10/27/17.
//

import Foundation

class BreastFeedingConcerns{
    
    var patientID : String = ""
    var concerns : String = ""
    
    init(){
         patientID = ""
         concerns = ""
    }
    init(patientID: String, isConcerned: Bool, concerns : String){
        self.patientID = patientID
        self.concerns = concerns
    }
}
