//
//  MasterTeamExtension.swift
//  FRC Scout
//
//  Created by David Swed on 2/11/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation

extension MasterTeam {
    func addTeam(value:Team) {
        var regionalTeams = self.mutableSetValueForKey("regionalTeams");
        regionalTeams.addObject(value)
    }
}