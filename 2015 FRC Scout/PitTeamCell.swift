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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
