//
//  ToteStack.swift
//  FRC Scout
//
//  Created by David Swed on 2/16/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
import CoreData

@objc(ToteStack)
class ToteStack: NSManagedObject {

    @NSManaged var containerLvl: NSNumber
    @NSManaged var tote1: NSNumber
    @NSManaged var tote2: NSNumber
    @NSManaged var tote3: NSNumber
    @NSManaged var tote4: NSNumber
    @NSManaged var tote5: NSNumber
    @NSManaged var tote6: NSNumber
    @NSManaged var uniqueID: NSNumber
    @NSManaged var match: Match

}
