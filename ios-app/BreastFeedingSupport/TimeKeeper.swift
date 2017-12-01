//
//  TimeKeeper.swift
//  BreastFeedingSupport
//
//  Created by Justin Kristensen on 11/7/17.
//

import Foundation

class TimeKeeper{

//    private var dataStructure = Dictionary<String, Dictionary<String, Array<Date>>>()
    private var dataStructureStarTime : [String: [Date]] = [:]
    private var dataStructureEndTime : [String: [Date]] = [:]

    func AddStartTimeToDate(startTime: Date, date: String) -> Void {
    
        let datesList = self.GetStartTimeDates()
        
        if(!datesList.contains(date)){
            dataStructureStarTime[date] = [Date]()
        }
    
        dataStructureStarTime[date]?.append(startTime)
        dataStructureStarTime[date]?.sort()
    }
    
    func AddEndTimeToDate(endTime: Date, date: String) -> Void {
        let datesList = self.GetEndTimeDates()
        
        if(!datesList.contains(date)){
            dataStructureEndTime[date] = [Date]()
        }
    
        dataStructureEndTime[date]?.append(endTime)
        dataStructureEndTime[date]?.sort()
    }
    
    func GetStartTimeDates() -> Array<String>{
        return Array(dataStructureStarTime.keys)
    }
    
    func GetEndTimeDates() -> Array<String>{
        return Array(dataStructureEndTime.keys)
    }
    
    func GetStartTimesOfDate(date: String) -> Array<Date>{
        return Array(dataStructureStarTime[date]!)
    }
    
    func GetEndTimesOfDate(date: String) -> Array<Date>{
        return Array(dataStructureEndTime[date]!)
    }
    
    func GetGapsOfDate(date:String) -> Array<Double>{
        if(!dataStructureStarTime.keys.contains(date) &&
           !dataStructureEndTime.keys.contains(date)){
            return [Double]()
        }
        
        if((dataStructureStarTime[date]?.count)! < 2 ||
            (dataStructureEndTime[date]?.count)! < 2){
            return [Double]()
        }
        
        let startTimes = self.GetStartTimesOfDate(date: date)
        let endTimes = self.GetEndTimesOfDate(date: date)
        
        let numOfItems = startTimes.count
        
        var sIndex = 1
        var eIndex = 0
        var gapList = [Double]()
        
        while(sIndex < numOfItems){
        
            let startTimeEntity = startTimes[sIndex]
            let endTimeEntity = endTimes[eIndex]
            let timeInt = startTimeEntity.timeIntervalSince(endTimeEntity)
            
            gapList.append(timeInt/60.0)
            
            sIndex += 1
            eIndex += 1
        }
        
        return gapList
    }

}
