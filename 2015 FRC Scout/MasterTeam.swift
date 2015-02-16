//
//  MasterTeam.swift
//  FRC Scout
//
//  Created by Louie Bertoncin on 2/15/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
import CoreData

@objc(MasterTeam)
class MasterTeam: NSManagedObject {

    @NSManaged var teamNumber: NSNumber
    @NSManaged var pitTeam: PitTeam
    @NSManaged var regionalTeams: NSSet

}
