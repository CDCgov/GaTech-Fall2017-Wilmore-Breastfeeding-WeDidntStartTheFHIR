//
//  JSONGenerator.swift
//  BreastFeedingSupport
//
//  Created by Justin Kristensen on 11/2/17.
//

import Foundation

class JSONGenerator {

    static func GenerateDailyQuestionnaireJson(patientID: String, hasMilkComeIn : Bool, isStoolMustard : Bool) -> String? {
        let jsonString = "{\"resourceType\": \"QuestionnaireResponse\",\"author\": {\"reference\": \"\(patientID)\" },\"source\": {  \"reference\": \"\(patientID)\" }, \"identifier\": \"questionnaire\", \"item\": [ {\"linkId\": \"questionnaireType\",\"text\": \"QuestionnaireType\", \"answer\": [{  \"valueString\": \"Patient questionnaire responses\"} ]},{\"linkId\": \"hasMilkComeIn\",\"text\": \"Has your milk come in?\", \"answer\": [ {\"valueBoolean\": \"\(hasMilkComeIn)\"} ] },{ \"linkId\": \"isStoolMustard\",\"text\": \"Is your baby having bowel movements that look like yellow, seedy mustard?\",\"answer\":{\"valueBoolean\": \"\(isStoolMustard)\"} }]}"
        
        return jsonString
    }
    
    static func GenerateDailyQuestionnaireJsonWithTestID(patientID: String, testID: String, hasMilkComeIn : Bool, isStoolMustard : Bool) -> String? {
    
        let jsonString = "{\"resourceType\": \"QuestionnaireResponse\", \"id\": \"\(testID)\", \"author\": {\"reference\": \"\(patientID)\" },\"source\": {  \"reference\": \"\(patientID)\" }, \"identifier\": \"questionnaire\", \"item\": [ {\"linkId\": \"questionnaireType\",\"text\": \"QuestionnaireType\", \"answer\": [{  \"valueString\": \"Patient questionnaire responses\"} ]},{\"linkId\": \"hasMilkComeIn\",\"text\": \"Has your milk come in?\", \"answer\": [ {\"valueBoolean\": \"\(hasMilkComeIn)\"} ] },{ \"linkId\": \"isStoolMustard\",\"text\": \"Is your baby having bowel movements that look like yellow, seedy mustard?\",\"answer\":{\"valueBoolean\": \"\(isStoolMustard)\"} }]}"
        
        return jsonString
    }
    
    static func GenerateDailyLogJson(patientID: String, date: String, numberOfFeedings: String, medianGap: String, averageLength: String, maximumGap: String, numberOfWetDiapers: String) -> String {
        
        let jsonString = "{\"resourceType\": \"QuestionnaireResponse\",  \"author\": {\"reference\": \"\(patientID)\" },\"source\": {  \"reference\": \"\(patientID)\" }, \"identifier\": \"data\", \"item\": [{\"linkId\": \"questionnaireType\",\"text\": \"QuestionnaireType\", \"answer\": [{  \"valueString\": \"Daily Breastfeeding Data\"} ]}, {\"linkId\": \"date\",\"text\": \"What date is this\", \"answer\": [{  \"valueDate\": \"\(date)\"} ]},{\"linkId\": \"numberOfFeedings\",  \"text\": \"Number of Feedings\", \"answer\":[{ \"valueString\": \"\(numberOfFeedings)\"}]}, {\"linkId\": \"medianGap\",\"text\": \"Median Gap\", \"answer\": [ {\"valueString\": \"\(medianGap)\"} ] },{ \"linkId\": \"averageLength\", \"text\": \"Average Length\", \"answer\": [{\"valueString\": \"\(averageLength)\"}] },{ \"linkId\": \"maximumGap\",\"text\": \"Maximum Gap\",\"answer\":{\"valueString\": \"\(maximumGap)\"} },{\"linkId\": \"numberOfWetDiapers\", \"text\": \"Number of Wet Diapers\",\"answer\":{\"valueString\": \"\(numberOfWetDiapers)\"}}]}"
        
        return jsonString
    }
    
    static func GenerateBreastFeedingSessionLogJson(patientID: String, date : String, startTime : String, stopTime : String, duration : String, wetDiapers : String) -> String {

        let jsonString = "{\"patientID\": \"\(patientID)\",\"date\": \"\(date)\",\"startTime\": \"\(startTime)\",\"stopTime\": \"\(stopTime)\",\"duration\": \"\(duration)\",\"wetDiapers\": \"\(wetDiapers)\"}"
        
        return jsonString
    }
    
    static func GenerateConcernJson(patientID:String, concerns:String) -> String {
        let jsonString = "{\"resourceType\": \"QuestionnaireResponse\",\"author\": {\"reference\": \"\(patientID)\" },\"source\": {  \"reference\": \"\(patientID)\" }, \"identifier\": \"questionnaire\", \"item\": [ {\"linkId\": \"questionnaireType\",\"text\": \"QuestionnaireType\", \"answer\": [{  \"valueString\": \"Concern Form\"} ]},{\"linkId\": \"concerns\",\"text\": \"What concerns do you have about breastfeeding?\",\"answer\": {\"valueString\": \"\(concerns)\"}}]}"
        
        return jsonString
    }
        
    static func GenerateSystemInfoJson(dataLastUpload : String) -> String {
        
        let jsonString = "{\"dataLastUpload\": \"\(dataLastUpload)\"}"
        
        return jsonString
    }
    
}
