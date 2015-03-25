//
//  SingleTeamView.swift
//  FRC Scout
//
//  Created by David Swed on 2/12/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit
import CoreData

class SingleTeamView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //info to pass through seque
    var teamNumber = String()
    var regional = String()
    var uniqueID = Int32()
    var matches = [Match]()
    
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var teamNameLbl: UILabel!
    @IBOutlet weak var teamPicView: UIImageView!
    @IBOutlet weak var autoStrengthScoreLbl: UILabel!
    @IBOutlet weak var teleScoreLbl: UILabel!
    @IBOutlet weak var toteScoreLbl: UILabel!
    @IBOutlet weak var containerScoreLbl: UILabel!
    @IBOutlet weak var autoBackGround: UIView!
    @IBOutlet var tableView: UITableView!
    
    //Detail View
    var grayOutView = UIView()
    var detailView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autoBackGround.layer.cornerRadius = 5
        autoBackGround.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).CGColor
        tableView.layer.borderWidth = 2
        tableView.layer.cornerRadius = 5
        tableView.layer.borderColor = UIColor(white: 0.75, alpha: 0.7).CGColor
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        titleBar.title = "Team " + teamNumber
        loadData()
        //tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadData(){
        matches = [Match]()
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Team")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "teamNumber = %@ AND regional.name = %@", teamNumber, regional)
        
        var results: NSArray = context.executeFetchRequest(request, error: nil)! as [Team]
        
        var team = results.firstObject as Team
        for match in team.matches{
            var newMatch = match as Match
            matches.append(newMatch)
        }
        let pitTeamRequest = NSFetchRequest(entityName: "PitTeam")
        pitTeamRequest.returnsObjectsAsFaults = false
        pitTeamRequest.predicate = NSPredicate(format: "teamNumber = %@ ", teamNumber)
        var pitTeamResults: NSArray = context.executeFetchRequest(pitTeamRequest, error: nil) as [PitTeam]
        if(pitTeamResults.count > 0){
            var pitTeam = pitTeamResults[0] as PitTeam
            teamNameLbl.text = pitTeam.teamName
            if let picture = UIImage(data: pitTeam.picture) {
                teamPicView.image = picture
            }
        }
        else {
            teamNameLbl.text = "No Pit Scouting Name"
        }
        var formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        autoStrengthScoreLbl.text = formatter.stringFromNumber(team.autoStrength)
        teleScoreLbl.text = formatter.stringFromNumber(team.teleAvg)
        toteScoreLbl.text = formatter.stringFromNumber(team.toteAvg)
        containerScoreLbl.text = formatter.stringFromNumber(team.containerAvg)
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var match = matches[indexPath.row]
        var autoData: [String] = ["\(match.autoContainers)" , "\(match.autoTotes)"]
        if( match.autoDrive == true){
            autoData.append("Yes")
        }
        else {
            autoData.append("No")
        }
        if( match.autoStack == true) {
            autoData.append("Yes")
        }
        else {
            autoData.append("No")
        }
        var autoLbls: [String] = ["Containers:","Totes:","Mobility:","Auto Stack:"]
        var matchCalcData = dataCalc.singleMatchScores(match)
        var teleData: [String] = ["\(matchCalcData.numTotes)","\(matchCalcData.numContainers)","\(match.stacksKnockedOver)","\(match.noodlesInContainer)","\(match.noodlesInLandfill)","\(match.penalty)"]
        var teleLbls: [String] = ["Totes:","Containers:","Stacks Disrupted:","Container Noodles:", "Landfill Noodles:", "Penalties:"]
        
        var screenW: CGFloat = UIScreen.mainScreen().bounds.width
        var screenH: CGFloat = UIScreen.mainScreen().bounds.height
        
        var detailViewWidth: CGFloat = screenW*0.75
        var detailViewHeight: CGFloat = screenH*0.55
        var detailViewX: CGFloat = (screenW/2) - (detailViewWidth/2)
        var detailViewY: CGFloat = (screenH/2) - (detailViewHeight/2)
        
        var closeBtnWidth: CGFloat = (detailViewWidth * 0.15)
        var closeBtnHeight: CGFloat = 35
        
        var lblWidth: CGFloat = 150
        var lblHeight: CGFloat = 25
        var scoreWidth: CGFloat = 40
        var scoreHeight: CGFloat = 25
        
        var cX: CGFloat = detailViewWidth * 0.35
        var rY: CGFloat = 80
        var trY: CGFloat = 230
        tableView.userInteractionEnabled = false
        var grayOutColor = UIColor(white: 0.5, alpha: 0.5)
        var autoColor = AUTOCOLOR
        var teleColor = UIColor(red: 0.55, green: 0.4, blue: 0.25, alpha: 0.3)
        
        //gray out back ground
        grayOutView = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        grayOutView.backgroundColor = grayOutColor
        self.view.addSubview(grayOutView)
        
        //create detail view
        detailView = UIView(frame: CGRect(x: detailViewX, y: detailViewY, width: detailViewWidth, height: detailViewHeight))
        detailView.backgroundColor = UIColor.whiteColor()
        detailView.layer.cornerRadius = 5
        grayOutView.addSubview(detailView)
        
        //MatchNumber
        var matchNumberLbl = UILabel(frame: CGRect(x: detailViewWidth/2 - 150, y: 5, width: 300, height: 40))
        matchNumberLbl.text = "Match " + match.matchNum
        matchNumberLbl.font = UIFont(name: "Futura-CondensedExtraBold", size: 35)
        matchNumberLbl.textAlignment = NSTextAlignment.Center
        matchNumberLbl.adjustsFontSizeToFitWidth = true
        detailView.addSubview(matchNumberLbl)
        
        //auto Stat box
        var autoBox = UIView(frame: CGRect(x: detailViewWidth * 0.05, y: 50, width: detailViewWidth * 0.9, height: detailViewHeight  * 0.20))
        autoBox.backgroundColor = autoColor
        autoBox.layer.cornerRadius = 5
        detailView.addSubview(autoBox)
        
        //auto lbl
        var autoLbl = UILabel(frame: CGRect(x: detailViewWidth*0.5 - 50, y: 55, width: 100, height: 25))
        autoLbl.text = "Autonomous"
        autoLbl.textAlignment = NSTextAlignment.Center
        autoLbl.font = UIFont(name: "System", size: 15)
        detailView.addSubview(autoLbl)
        var count = 0
        for var x:CGFloat = 0; x < 2; ++x {
            for var y: CGFloat = 0; y < 2; ++y {
                var lbl = UILabel(frame: CGRect(x: cX - lblWidth + (x * detailViewWidth * 0.42) , y: rY + lblHeight * y, width: lblWidth , height: lblHeight))
                lbl.text = autoLbls[count]
                lbl.textAlignment = NSTextAlignment.Right
                lbl.font = UIFont(name: "System", size: 15)
                detailView.addSubview(lbl)
                
                var score = UILabel(frame: CGRect(x: cX + 3 + (x * detailViewWidth * 0.42) , y: rY + lblHeight * y, width: scoreWidth , height: scoreHeight))
                score.text = autoData[count]
                score.textAlignment = NSTextAlignment.Left
                score.font = UIFont(name: "System", size: 15)
                detailView.addSubview(score)
                
                
                count++
            }
        }
        
        var teleBox = UIView(frame: CGRect(x: detailViewWidth * 0.05, y: detailViewHeight * 0.35, width: detailViewWidth * 0.9, height: detailViewHeight * 0.40))
        teleBox.backgroundColor = teleColor
        teleBox.layer.cornerRadius = 5
        detailView.addSubview(teleBox)
        
        //code to display stacks
        var imageCodes = [String]()
        for stack in match.toteStacks.allObjects as [ToteStack] {
            var code: String = ""
            code += "\(stack.tote1)"
            code += "\(stack.tote2)"
            code += "\(stack.tote3)"
            code += "\(stack.tote4)"
            code += "\(stack.tote5)"
            code += "\(stack.tote6)"
            if(stack.containerLvl as Int > 0){
                code += "c"
            }
            println(code)
            imageCodes.append(code)
        }
        
        for var i: CGFloat = 0; i < CGFloat(imageCodes.count); ++i {
            var image = UIImage(named: imageCodes[Int(i)])
            var imageView = UIImageView(frame: CGRect(x: 35 + 40 * i, y: detailViewHeight * 0.75 - 70, width: 21, height: 60))
            imageView.image = image
            detailView.addSubview(imageView)
        }
        
        //tele lbl
        var teleLbl = UILabel(frame: CGRect(x: detailViewWidth*0.5 - 50, y: detailViewHeight * 0.35 + 5, width: 100, height: 25))
        teleLbl.text = "Teleoperated"
        teleLbl.font = UIFont(name: "System", size: 15)
        teleLbl.textAlignment = NSTextAlignment.Center
        detailView.addSubview(teleLbl)
        
        count = 0
        for var x:CGFloat = 0; x < 2; ++x {
            for var y: CGFloat = 0; y < 3; ++y {
                var lbl = UILabel(frame: CGRect(x: cX - lblWidth + (x * detailViewWidth * 0.42) , y: trY + lblHeight * y, width: lblWidth , height: lblHeight))
                lbl.text = teleLbls[count]
                lbl.textAlignment = NSTextAlignment.Right
                lbl.font = UIFont(name: "System", size: 15)
                detailView.addSubview(lbl)
                
                var score = UILabel(frame: CGRect(x: cX + 3 + (x * detailViewWidth * 0.42) , y: trY + lblHeight * y, width: scoreWidth , height: scoreHeight))
                score.text = teleData[count]
                score.textAlignment = NSTextAlignment.Left
                score.font = UIFont(name: "System Bold", size: 15)
                detailView.addSubview(score)
                
                
                count++
            }
        }
        
        
        var closeBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        closeBtn.frame = CGRect(x: detailViewWidth - closeBtnWidth - 5, y: 5, width: closeBtnWidth, height:closeBtnHeight)
        closeBtn.addTarget(nil, action: Selector("closeDetailView"), forControlEvents: UIControlEvents.TouchUpInside)
        closeBtn.setTitle("Close X", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        closeBtn.setTitleColor(UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1),forState: UIControlState.Normal)
        closeBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        detailView.addSubview(closeBtn)
        
        var notesLbl = UILabel(frame: CGRect(x: detailViewWidth/2 - 50 , y: detailViewHeight - 130, width: 100 , height: 25))
        notesLbl.text = "Notes"
        notesLbl.textAlignment = NSTextAlignment.Center
        notesLbl.font = UIFont(name: "System", size: 15)
        detailView.addSubview(notesLbl)
        
        var notesView = UITextView(frame: CGRect(x: detailViewWidth/2 - 125, y: detailViewHeight - 105, width: 250, height: 90))
        notesView.text = match.notes
        notesView.textAlignment = NSTextAlignment.Center
        notesView.layer.borderColor = UIColor.lightGrayColor().CGColor
        notesView.layer.borderWidth = 1
        notesView.layer.cornerRadius = 5
        notesView.font = UIFont(name: "Heiti SC", size: 15)
        notesView.clipsToBounds = true
        notesView.userInteractionEnabled = false
        detailView.addSubview(notesView)
    }
    
    func closeDetailView(){
        for view:AnyObject in detailView.subviews {
            view.removeFromSuperview()
        }
        detailView.removeFromSuperview()
        grayOutView.removeFromSuperview()
        tableView.userInteractionEnabled = true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return matches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: MatchCell = tableView.dequeueReusableCellWithIdentifier("MatchCell", forIndexPath: indexPath) as MatchCell
        var match = matches[indexPath.row] as Match
        var matchData = dataCalc.singleMatchScores(match)
        cell.autoScoreLbl.text = "\(matchData.autoScore)"
        cell.teleScoreLbl.text = "\(matchData.teleScore)"
        cell.toteScoreLbl.text = "\(matchData.numTotes)"
        cell.containerScoreLbl.text = "\(matchData.numContainers)"
        cell.matchNumber.text = match.matchNum
        
        //code to display stacks
        var imageCodes = [String]()
        for stack in match.toteStacks.allObjects as [ToteStack] {
            var code: String = ""
            code += "\(stack.tote1)"
            code += "\(stack.tote2)"
            code += "\(stack.tote3)"
            code += "\(stack.tote4)"
            code += "\(stack.tote5)"
            code += "\(stack.tote6)"
            if(stack.containerLvl as Int > 0){
                code += "c"
            }
            imageCodes.append(code)
        }
        
        for var i: CGFloat = 0; i < CGFloat(imageCodes.count); ++i {
            var image = UIImage(named: imageCodes[Int(i)])
            var imageView = UIImageView(frame: CGRect(x: 30 + 35 * i, y: cell.bounds.height * 0.4, width: 16, height: 60))
            imageView.image = image
            cell.addSubview(imageView)
        }
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
}
