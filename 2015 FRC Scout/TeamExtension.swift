//
//  TeamExtension.swift
//  FRC Scout
//
//  Created by David Swed on 2/11/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation
extension Team {
    
    func addMatch(value:Match) {
        var matches = self.mutableSetValueForKey("matches");
        matches.addObject(value)
    }
}
