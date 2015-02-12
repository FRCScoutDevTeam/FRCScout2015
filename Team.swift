//
//  Team.swift
//  FRC Scout
//
//  Created by David Swed on 2/12/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
import CoreData

@objc(Team)
class Team: NSManagedObject {

    @NSManaged var autoStrength: NSNumber
    @NSManaged var containerAvg: NSNumber
    @NSManaged var teleAvg: NSNumber
    @NSManaged var toteAvg: NSNumber
    @NSManaged var teamNumber: String
    @NSManaged var teamName: String
    @NSManaged var masterTeam: MasterTeam
    @NSManaged var matches: NSSet
    @NSManaged var regional: Regional
    @NSManaged var regionalFirstPickList: Regional
    @NSManaged var regionalSecondPickList: Regional

}
