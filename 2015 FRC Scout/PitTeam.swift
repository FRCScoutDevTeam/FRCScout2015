//
//  PitTeam.swift
//  FRC Scout
//
//  Created by David Swed on 2/9/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
import CoreData

@objc(PitTeam)
class PitTeam: NSManagedObject {

    @NSManaged var teamNumber: String
    @NSManaged var teamName: String
    @NSManaged var driveTrain: String
    @NSManaged var stackTotes: String
    @NSManaged var stackerType: String
    @NSManaged var heightOfStack: String
    @NSManaged var stackContainer: String
    @NSManaged var containerLevel: String
    @NSManaged var carryCapacity: String
    @NSManaged var withContainer: NSNumber
    @NSManaged var autoNone: NSNumber
    @NSManaged var autoMobility: NSNumber
    @NSManaged var autoTote: NSNumber
    @NSManaged var autoContainer: NSNumber
    @NSManaged var autoStack: NSNumber
    @NSManaged var autoStepContainer: NSNumber
    @NSManaged var coop: String
    @NSManaged var noodles: String
    @NSManaged var strategy: String
    @NSManaged var additionalNotes: String
    @NSManaged var uniqueID: NSNumber

}
