//
//  CoopStack.swift
//  FRC Scout
//
//  Created by Louie Bertoncin on 2/15/15.
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
