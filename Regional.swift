//
//  Regional.swift
//  FRC Scout
//
//  Created by David Swed on 2/22/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
import CoreData

@objc(Regional)
class Regional: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var uniqueID: NSNumber
    @NSManaged var firstPickList: NSOrderedSet
    @NSManaged var secondPickList: NSSet
    @NSManaged var teams: NSSet

}
