//
//  MatchExtension.swift
//  2015 FRC Scout
//
//  Created by David Swed on 2/8/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import Foundation

extension Match {
    func addToteStack(value:ToteStack) {
        var stacks = self.mutableSetValueForKey("toteStacks");
        stacks.addObject(value)
    }
    func removeToteStack(value:ToteStack) {
        var stacks = self.mutableSetValueForKey("toteStacks");
        stacks.removeObject(value)
    }
    func addCoopStack(value:CoopStack) {
        var stacks = self.mutableSetValueForKey("coopStacks");
        stacks.addObject(value)
    }
    func removeCoopStack(value:ToteStack) {
        var stacks = self.mutableSetValueForKey("coopStacks");
        stacks.removeObject(value)
    }
}