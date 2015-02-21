//
//  RegionalExtension.swift
//  FRC Scout
//
//  Created by David Swed on 2/11/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
import CoreData

extension Regional {
    func addTeam(value:Team) {
        var teams = self.mutableSetValueForKey("teams");
        teams.addObject(value)
    }
    
    class func createRegional(name:String , context: NSManagedObjectContext) -> Regional {
        var regional : Regional?
        var request = NSFetchRequest(entityName: "Regional")
        request.predicate = NSPredicate(format: "name = %@", name)
        var results = context.executeFetchRequest(request, error: nil) as [Regional]!
        if (results.count > 0){
            regional = results.first! as Regional!
            println("Regional Found!")
        } else {
            regional = NSEntityDescription.insertNewObjectForEntityForName("Regional", inManagedObjectContext: context) as? Regional
            regional?.name = name
            regional?.uniqueID = Int(NSDate().timeIntervalSince1970)
            
            var error: NSError? = nil
            if !context.save(&error) {
                println("Saving error \(error), \(error?.userInfo)")
            } else {
                println("Saved a Regional with name: \(regional!.name)")
            }
        }
        
        return regional!
    }
}