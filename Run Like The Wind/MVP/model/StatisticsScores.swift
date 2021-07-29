//
//  TotalScores.swift
//  Run Like The Wind
//
//  Created by Yarden Barak on 11/07/2021.
//

import Foundation

class StatisticsScores : Codable{
    
    var totalRunTime: Int = 0
    var totalDistance : Double = 0.0
    var totalAvgSpeed : Double = 0.0
    
    public var description: String { return "MyClass: \(totalRunTime) \(totalDistance) \(totalAvgSpeed)" }

    init(totalRunTime: Int, totalDistance : Double, totalAvgSpeed : Double) {
        self.totalRunTime = totalRunTime
        self.totalDistance = totalDistance
        self.totalAvgSpeed = totalAvgSpeed
    }
    
    init() {}
}
