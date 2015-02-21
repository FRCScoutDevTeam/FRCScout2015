//
//  Match.swift
//  FRC Scout
//
//  Created by David Swed on 2/16/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
import CoreData

@objc(Match)
class Match: NSManagedObject {

    @NSManaged var autoContainers: NSNumber
    @NSManaged var autoDrive: NSNumber
    @NSManaged var autoStack: NSNumber
    @NSManaged var autoTotes: NSNumber
    @NSManaged var matchNum: String
    @NSManaged var matchType: String
    @NSManaged var noodlesInContainer: NSNumber
    @NSManaged var noodlesInLandfill: NSNumber
    @NSManaged var notes: String
    @NSManaged var numCoopStacks: NSNumber
    @NSManaged var numStacks: NSNumber
    @NSManaged var penalty: NSNumber
    @NSManaged var recordingTeam: NSNumber
    @NSManaged var stacksKnockedOver: NSNumber
    @NSManaged var uniqueID: NSNumber
    @NSManaged var scoutInitials: String
    @NSManaged var scoutPosition: NSNumber
    @NSManaged var coopStacks: NSSet
    @NSManaged var team: Team
    @NSManaged var toteStacks: NSSet

}
