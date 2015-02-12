//
//  PitScoutingNav.swift
//  FRC Scout
//
//  Created by David Swed on 2/9/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit

class PitScoutingNav: UIViewController {
    
    @IBOutlet weak var teamRecordBtn: UIButton!
    @IBOutlet weak var viewTeamsBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamRecordBtn.layer.cornerRadius = 5
        viewTeamsBtn.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}