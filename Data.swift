//
//  Data.swift
//  2015 FRC Scout
//
//  Created by David Swed on 1/9/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit

class Data: UIViewController {

    @IBOutlet weak var viewTeamsBtn: UIButton!
    @IBOutlet weak var nextMatchBtn: UIButton!
    @IBOutlet weak var allianceSelectionBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTeamsBtn.layer.cornerRadius = 5
        nextMatchBtn.layer.cornerRadius = 5
        allianceSelectionBtn.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
