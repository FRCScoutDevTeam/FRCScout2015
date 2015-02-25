//
//  MasterTeamExtension.swift
//  FRC Scout
//
//  Created by David Swed on 2/11/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
import CoreData

extension MasterTeam {
    func addTeam(value:Team ) {
        var regionalTeams = self.mutableSetValueForKey("regionalTeams");
        regionalTeams.addObject(value)
    }
    
    class func createMasterTeam(teamNumber: NSNumber, context: NSManagedObjectContext) -> MasterTeam {
        var newMasterTeam : MasterTeam?
        var requestMasterTeam = NSFetchRequest(entityName: "MasterTeam")
        requestMasterTeam.predicate = NSPredicate(format: "teamNumber=\(teamNumber)")
        var resultsMasterTeam = context.executeFetchRequest(requestMasterTeam, error: nil) as [MasterTeam]!
        if (resultsMasterTeam.count > 0){
            newMasterTeam = resultsMasterTeam.first! as MasterTeam
            println("Master Team found")
        } else {
            newMasterTeam = NSEntityDescription.insertNewObjectForEntityForName("MasterTeam", inManagedObjectContext: context) as? MasterTeam
            newMasterTeam?.teamNumber = teamNumber
            newMasterTeam?.uniqueID = Int(NSDate().timeIntervalSince1970)
            
            var error: NSError? = nil
            if !context.save(&error) {
                println("Saving error \(error), \(error?.userInfo)")
            } else {
                println("Saved a MasterTeam with number: \(newMasterTeam!.teamNumber)")
            }
        }
        
        return newMasterTeam!
    }
}