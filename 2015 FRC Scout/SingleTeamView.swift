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
    var matches = [Match]()
    
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var teamNameLbl: UILabel!
    @IBOutlet weak var autoStrengthScoreLbl: UILabel!
    @IBOutlet weak var teleScoreLbl: UILabel!
    @IBOutlet weak var toteScoreLbl: UILabel!
    @IBOutlet weak var containerScoreLbl: UILabel!
    @IBOutlet weak var autoBackGround: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        titleBar.title = teamNumber
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadData(){
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
        }
        else {
            teamNameLbl.text = "No Pit Scouting Name"
        }
        
        autoStrengthScoreLbl.text = "\(team.autoStrength)"
        teleScoreLbl.text = "\(team.teleAvg)"
        toteScoreLbl.text = "\(team.toteAvg)"
        containerScoreLbl.text = "\(team.containerAvg)"
        
        
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
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
}
