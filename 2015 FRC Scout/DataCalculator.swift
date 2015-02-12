//
//  DataCalculator.swift
//  FRC Scout
//
//  Created by David Swed on 2/11/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var dataCalc = DataCalculator()


class DataCalculator: NSObject{
    
    
    func calculateAverages (team: Team) -> Team {
        var t_Team = team
        
        var matchCount = t_Team.matches.count
        var toteCount = [Int]()
        var stackCount = 0
        var stackHeights = [Int]()
        var containerHeights = [Int]()
        var teleScores = [Int]()
        var autoStrengths = [Int]()
        
        for match in t_Team.matches.allObjects as [Match]{
            var tele = 0
            tele += match.noodlesInContainer.integerValue*6
            tele += match.noodlesInLandfill.integerValue
            
            var auto = 0
            auto += match.autoTotes.integerValue * 2
            auto += match.autoContainers.integerValue * 3
            if(match.autoStack == true) {
                auto += 20
            }
            if(match.autoDrive == true) {
                auto += 2
            }
            var numTotes: Int = 0
            var matchContainer = [Int]()
            stackCount += match.toteStacks.count
            for stack in match.toteStacks.allObjects as [ToteStack]{
                var totesInStack: [NSNumber] = [stack.tote1,stack.tote2,stack.tote3,stack.tote4,stack.tote5,stack.tote6]
                var heightOfStack = 6
                for var t = totesInStack.count - 1; t >= 0; t--  {
                    if totesInStack[t] == 0 {
                        heightOfStack = t
                    } else if (totesInStack[t] == 2) {
                        numTotes++
                    }
                }
                stackHeights.append(heightOfStack)
                if(stack.containerLvl as Int > 0) {
                    containerHeights.append(stack.containerLvl as Int)
                    matchContainer.append(stack.containerLvl as Int)
                }
            }
            
            tele += numTotes * 2
            for x in matchContainer {
                tele += x * 4
            }
            teleScores.append(tele)
            autoStrengths.append(auto)
            toteCount.append(numTotes)
        }
        var numTotes: Float = 0
        for i in toteCount {
            numTotes += Float(i)
        }
        var totalTele: Float = 0
        for i in teleScores {
            totalTele += Float(i)
        }
        var totalAuto: Float = 0
        for i in autoStrengths {
            totalAuto += Float(i)
        }
        t_Team.autoStrength = totalAuto / Float(matchCount)
        t_Team.teleAvg = totalTele / Float(matchCount)
        t_Team.toteAvg = NSNumber(float: numTotes / Float(matchCount))
        t_Team.containerAvg = Float(containerHeights.count) / Float(matchCount)
        
        return t_Team
    }
}