//
//  MatchCell.swift
//  FRC Scout
//
//  Created by David Swed on 2/12/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit

class MatchCell: UITableViewCell {
    @IBOutlet weak var matchNumber: UILabel!
    @IBOutlet weak var autoScoreLbl: UILabel!
    @IBOutlet weak var toteScoreLbl: UILabel!
    @IBOutlet weak var teleScoreLbl: UILabel!
    @IBOutlet weak var containerScoreLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        // Initialization code
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
