//
//  TeamList.swift
//  FRC Scout
//
//  Created by David Swed on 2/11/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit

class TeamList: UIViewController {
    //Items
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    //Control Variables
    var viewingRegional = false //false for regional list, true for all list
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Segment controller press to change list
    @IBAction func changeList(sender: AnyObject) {
        if(segmentController.selectedSegmentIndex == 0){
            viewingRegional = false
        } else {
            viewingRegional = true
        }
    }
}
