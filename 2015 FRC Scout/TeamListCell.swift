//
//  TeamListCell.swift
//  FRC Scout
//
//  Created by David Swed on 2/11/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit

class TeamListCell: UITableViewCell {

    @IBOutlet weak var rankLbl: UILabel!
    @IBOutlet weak var teamNumberLbl: UILabel!
    @IBOutlet weak var teleAvgLbl: UILabel!
    @IBOutlet weak var teleAvgScoreLbl: UILabel!
    @IBOutlet weak var autoAvgLbl: UILabel!
    @IBOutlet weak var autoAvgScoreLbl: UILabel!
    @IBOutlet weak var containerLbl: UILabel!
    @IBOutlet weak var containerScoreLbl: UILabel!
    @IBOutlet weak var toteLbl: UILabel!
    @IBOutlet weak var toteScoreLbl: UILabel!
    
    var regional = String()
    
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
