//
//  PitTeamCell.swift
//  FRC Scout
//
//  Created by David Swed on 2/9/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit

class PitTeamCell: UITableViewCell {

    @IBOutlet weak var robotPic: UIImageView!
    @IBOutlet weak var teamNumberLbl: UILabel!
    @IBOutlet weak var teamNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        robotPic.layer.cornerRadius = 5
        robotPic.clipsToBounds = true
    }

}
