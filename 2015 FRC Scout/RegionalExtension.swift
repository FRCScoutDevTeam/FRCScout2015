//
//  RegionalExtension.swift
//  FRC Scout
//
//  Created by David Swed on 2/11/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
extension Regional {
    func addTeam(value:Team) {
        var teams = self.mutableSetValueForKey("teams");
        teams.addObject(value)
    }
}