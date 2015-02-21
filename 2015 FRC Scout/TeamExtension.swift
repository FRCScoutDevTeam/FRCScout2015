//
//  TeamExtension.swift
//  FRC Scout
//
//  Created by David Swed on 2/11/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
import CoreData

extension Team {
    
    func addMatch(value:Match) {
        var matches = self.mutableSetValueForKey("matches");
        matches.addObject(value)
    }
    
    class func createTeam(teamNumber: NSNumber, regional: Regional, masterTeam: MasterTeam, context: NSManagedObjectContext) -> Team {
        var team : Team?
        var teamRequest = NSFetchRequest(entityName: "Team")
        teamRequest.predicate = NSPredicate(format: "(teamNumber = \(teamNumber)) AND (regional.name = %@)", regional.name)
        var teamResults = context.executeFetchRequest(teamRequest, error: nil) as [Team]!
        if (teamResults.count > 0) {
            team = teamResults.first
            println("team found")
        } else {
            team = NSEntityDescription.insertNewObjectForEntityForName("Team", inManagedObjectContext: context) as? Team
            team?.regional = regional
            team?.masterTeam = masterTeam
            team?.teamNumber = teamNumber
            team?.uniqueID = Int(NSDate().timeIntervalSince1970)
            regional.addTeam(team!)
            masterTeam.addTeam(team!)
            
            var error: NSError? = nil
            if !context.save(&error) {
                println("Saving error \(error), \(error?.userInfo)")
            } else {
                println("Saved a Team with number: \(team!.teamNumber)")
            }
        }
        
        return team!
    }
}
