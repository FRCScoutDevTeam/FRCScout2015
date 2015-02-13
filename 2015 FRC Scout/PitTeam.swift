//
//  PitTeam.swift
//  FRC Scout
//
//  Created by David Swed on 2/12/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
import CoreData

@objc(PitTeam)
class PitTeam: NSManagedObject {

    @NSManaged var additionalNotes: String
    @NSManaged var autoContainer: NSNumber
    @NSManaged var autoMobility: NSNumber
    @NSManaged var autoNone: NSNumber
    @NSManaged var autoStack: NSNumber
    @NSManaged var autoStepContainer: NSNumber
    @NSManaged var autoTote: NSNumber
    @NSManaged var carryCapacity: String
    @NSManaged var containerLevel: String
    @NSManaged var coop: String
    @NSManaged var driveTrain: String
    @NSManaged var heightOfStack: String
    @NSManaged var noodles: String
    @NSManaged var stackContainer: String
    @NSManaged var stackerType: String
    @NSManaged var stackTotes: String
    @NSManaged var strategy: String
    @NSManaged var teamName: String
    @NSManaged var teamNumber: String
    @NSManaged var uniqueID: NSNumber
    @NSManaged var withContainer: NSNumber
    @NSManaged var masterTeam: MasterTeam

}
