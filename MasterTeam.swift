//
//  MasterTeam.swift
//  FRC Scout
//
//  Created by David Swed on 2/22/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
import CoreData

@objc(MasterTeam)
class MasterTeam: NSManagedObject {

    @NSManaged var teamNumber: NSNumber
    @NSManaged var uniqueID: NSNumber
    @NSManaged var pitTeam: PitTeam
    @NSManaged var regionalTeams: NSSet

}
