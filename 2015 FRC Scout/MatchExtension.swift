//
//  MatchExtension.swift
//  2015 FRC Scout
//
//  Created by David Swed on 2/8/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
import CoreData

extension Match {
    func addToteStack(value:ToteStack) {
        var stacks = self.mutableSetValueForKey("toteStacks");
        stacks.addObject(value)
    }
    func removeToteStack(value:ToteStack) {
        var stacks = self.mutableSetValueForKey("toteStacks");
        stacks.removeObject(value)
    }
    func addCoopStack(value:CoopStack) {
        var stacks = self.mutableSetValueForKey("coopStacks");
        stacks.addObject(value)
    }
    func removeCoopStack(value:ToteStack) {
        var stacks = self.mutableSetValueForKey("coopStacks");
        stacks.removeObject(value)
    }
    
    class func createMatch(matchDict:[String:AnyObject], m_team: Team, context: NSManagedObjectContext) -> Match {
        var match : Match?
        var team = m_team
        var requestMatch = NSFetchRequest(entityName: "Match")
        requestMatch.predicate = NSPredicate(format: "(team.teamNumber = %@) AND (matchNum = %@) AND (team.regional.name = %@)", team.teamNumber,matchDict["matchNum"] as String,team.regional.name)
        var matchResults = context.executeFetchRequest(requestMatch, error: nil) as [Match]!
        if(matchResults?.count > 0){
            match = matchResults?.first
            println("pre existing match found")
        } else {
            match = NSEntityDescription.insertNewObjectForEntityForName("Match", inManagedObjectContext: context) as? Match
            match?.autoContainers = matchDict["autoContainers"] as NSNumber
            match?.autoTotes = matchDict["autoTotes"] as NSNumber
            match?.numCoopStacks = matchDict["numCoopStacks"] as NSNumber
            match?.numStacks = matchDict["numStacks"] as NSNumber
            match?.noodlesInContainer = matchDict["noodlesInContainer"] as NSNumber
            match?.penalty = matchDict["penalty"] as NSNumber
            match?.stacksKnockedOver = matchDict["stacksKnockedOver"] as NSNumber
            match?.noodlesInLandfill = matchDict["noodlesInLandFill"] as NSNumber
            match?.autoDrive = matchDict["autoDrive"] as NSNumber
            match?.autoStack = matchDict["autoStack"] as NSNumber
            match?.toteStacks = matchDict["toteStacks"] as NSSet
            match?.coopStacks = matchDict["coopStacks"] as NSSet
            match?.matchNum = matchDict["matchNum"] as String
            match?.uniqueID = matchDict["uniqueID"] as NSNumber
            match?.scoutInitials = matchDict["scoutInitials"] as String
            match?.scoutPosition = matchDict["scoutPosition"] as NSNumber
            match?.notes = matchDict["notes"] as String
            println("match created")
        }
        
        
        
        match?.team = team
        team.addMatch(match!)
        team = dataCalc.calculateAverages(team)
        
        return match!
    }
}