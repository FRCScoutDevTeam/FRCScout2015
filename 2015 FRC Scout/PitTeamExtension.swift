//
//  PitTeamExtension.swift
//  FRC Scout
//
//  Created by David Swed on 2/17/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
import CoreData

extension PitTeam {
    class func createPitTeam(pitDict:[String:AnyObject], masterTeam: MasterTeam, context: NSManagedObjectContext) -> PitTeam {
        var pitTeam: PitTeam?
        
        var request = NSFetchRequest(entityName: "PitTeam")
        request.predicate = NSPredicate(format: "teamNumber = %@", masterTeam.teamNumber)
        var results = context.executeFetchRequest(request, error: nil) as [PitTeam]!
        if (results.count > 0){
            pitTeam = results.first! as PitTeam!
            println("found existing pit team")
        } else {
            let ent = NSEntityDescription.entityForName("PitTeam", inManagedObjectContext: context)
            pitTeam = PitTeam(entity: ent!, insertIntoManagedObjectContext: context) as PitTeam!
            pitTeam!.teamNumber = pitDict["teamNumber"] as NSNumber
            pitTeam!.teamName = pitDict["teamName"] as String
            pitTeam!.driveTrain = pitDict["driveTrain"] as String
            pitTeam!.stackTotes = pitDict["stackTotes"] as NSNumber
            pitTeam!.stackerType = pitDict["stackerType"] as String
            pitTeam!.heightOfStack = pitDict["heightOfStack"] as NSNumber
            pitTeam!.stackContainer = pitDict["stackContainer"] as NSNumber
            pitTeam!.containerLevel = pitDict["containerLevel"] as NSNumber
            pitTeam!.carryCapacity = pitDict["carryCapacity"] as NSNumber
            pitTeam!.withContainer = pitDict["withContainer"] as NSNumber
            pitTeam!.autoNone = pitDict["autoNone"] as NSNumber
            pitTeam!.autoMobility = pitDict["autoMobility"] as NSNumber
            pitTeam!.autoTote = pitDict["autoTote"] as NSNumber
            pitTeam!.autoContainer = pitDict["autoContainer"] as NSNumber
            pitTeam!.autoStack = pitDict["autoStack"] as NSNumber
            pitTeam!.autoStepContainer = pitDict["autoStepContainer"] as NSNumber
            pitTeam!.coop = pitDict["coop"] as String
            pitTeam!.noodles = pitDict["noodles"] as String
            pitTeam!.strategy = pitDict["strategy"] as  String
            pitTeam!.additionalNotes = pitDict["additionalNotes"] as String
            pitTeam!.uniqueID = pitDict["uniqueID"] as NSNumber
            pitTeam!.picture = pitDict["picture"] as NSData
            println("created pit team")
            
            pitTeam?.masterTeam = masterTeam
            masterTeam.pitTeam = pitTeam!
            
            var error: NSError? = nil
            if !context.save(&error) {
                println("Saving error \(error), \(error?.userInfo)")
            } else {
                println("Saved a PitTeam with name: \(pitTeam!.teamNumber)")
            }
        }
        
        return pitTeam!
    }
    
}
