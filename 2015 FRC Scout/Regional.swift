//
//  Regional.swift
//  FRC Scout
//
//  Created by Louie Bertoncin on 2/15/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
import CoreData

@objc(Regional)
class Regional: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var firstPickList: NSOrderedSet
    @NSManaged var secondPickList: NSSet
    @NSManaged var teams: NSSet

}
