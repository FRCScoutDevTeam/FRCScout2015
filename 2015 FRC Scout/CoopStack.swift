//
//  CoopStack.swift
//  2015 FRC Scout
//
//  Created by David Swed on 2/8/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
import CoreData

@objc(CoopStack)
class CoopStack: NSManagedObject {

    @NSManaged var tote1: NSNumber
    @NSManaged var tote2: NSNumber
    @NSManaged var tote3: NSNumber
    @NSManaged var tote4: NSNumber
    @NSManaged var uniqueID: NSNumber
    @NSManaged var match: Match

}
