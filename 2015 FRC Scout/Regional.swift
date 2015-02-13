//
//  Regional.swift
//  FRC Scout
//
//  Created by David Swed on 2/11/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
import CoreData

@objc(Regional)
class Regional: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var teams: NSSet
    @NSManaged var firstPickList: NSOrderedSet
    @NSManaged var secondPickList: NSSet

}
