//
//  TeamList.swift
//  FRC Scout
//
//  Created by David Swed on 2/11/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit
import CoreData

class TeamList: UIViewController,UITableViewDataSource, UITableViewDelegate {
    //Items
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    //Control Variables
    var viewingRegional = false //false for regional list, true for all list
    
    //data
    var data = [Team]()
    
    func loadData() {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Team")
        request.returnsObjectsAsFaults = false
        
        var results: NSArray = context.executeFetchRequest(request, error: nil)!
        data = [Team]()
        for res in results{
            var newTeam = res as Team
            data.append(newTeam)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        loadData()
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: TeamListCell = tableView.dequeueReusableCellWithIdentifier("TeamCell", forIndexPath: indexPath) as TeamListCell
        var team = data[indexPath.row] as Team
        cell.teamNumberLbl.text = team.teamNumber
        cell.rankLbl.text = "#"+String(indexPath.row+1)
        cell.autoAvgScoreLbl.text = "\(team.autoStrength)"
        cell.teleAvgScoreLbl.text = "\(team.teleAvg)"
        cell.containerScoreLbl.text = "\(team.containerAvg)"
        cell.toteScoreLbl.text = "\(team.toteAvg)"
        return cell
    }
}
