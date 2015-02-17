//
//  TeamList.swift
//  FRC Scout
//
//  Created by David Swed on 2/11/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit
import CoreData

class TeamList: UIViewController,UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    //Items
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    //Control Variables
    var viewingRegional = false //false for regional list, true for all list
    
    /* `NSFetchedResultsController`
    lazily initialized
    fetches the displayed domain model */
    var fetchedResultsController: NSFetchedResultsController {
        // return if already initialized
        if self._fetchedResultsController != nil {
            return self._fetchedResultsController!
        }
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedObjectContext: NSManagedObjectContext? = appDel.managedObjectContext!
        
        /* `NSFetchRequest` config
        fetch all `Item`s
        order them alphabetically by name
        at least one sort order _is_ required */
        let entity = NSEntityDescription.entityForName("Team", inManagedObjectContext: managedObjectContext!)
        let sort = NSSortDescriptor(key: "teamNumber", ascending: true)
        let req = NSFetchRequest()
        req.entity = entity
        req.sortDescriptors = [sort]
        
        /* NSFetchedResultsController initialization
        a `nil` `sectionNameKeyPath` generates a single section */
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: req, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        self._fetchedResultsController = aFetchedResultsController
        
        // perform initial model fetch
        var e: NSError?
        if !self._fetchedResultsController!.performFetch(&e) {
            println("fetch error: \(e!.localizedDescription)")
            abort();
        }
        
        return self._fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.borderWidth = 2
        tableView.layer.cornerRadius = 5
        tableView.layer.borderColor = UIColor(white: 0.75, alpha: 0.7).CGColor
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "OpenSingleTeamView"){
            let destination = segue.destinationViewController as SingleTeamView
            let sendingCell = sender as TeamListCell
            destination.teamNumber = sendingCell.teamNumberLbl.text!
            destination.regional = sendingCell.regional
            destination.uniqueID = sendingCell.uniqueID
        }
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
        let info = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return info.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: TeamListCell = tableView.dequeueReusableCellWithIdentifier("TeamCell", forIndexPath: indexPath) as TeamListCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    //configure table cell
    func configureCell(cell: TeamListCell, indexPath: NSIndexPath) {
        let team: Team = self.fetchedResultsController.objectAtIndexPath(indexPath) as Team
        cell.teamNumberLbl.text = "\(team.teamNumber)"
        cell.teamNumberLbl.text = "\(team.teamNumber)"
        cell.rankLbl.text = "#"+String(indexPath.row+1)
        cell.autoAvgScoreLbl.text = "\(team.autoStrength)"
        cell.teleAvgScoreLbl.text = "\(team.teleAvg)"
        cell.containerScoreLbl.text = "\(team.containerAvg)"
        cell.toteScoreLbl.text = "\(team.toteAvg)"
        cell.regional = team.regional.name
        cell.uniqueID = team.uniqueID.intValue
        println(team.uniqueID)
    }
    
    // fetched results controller delegate
    
    /* called first
    begins update to `UITableView`
    ensures all updates are animated simultaneously */
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    /* called:
    - when a new model is created
    - when an existing model is updated
    - when an existing model is deleted */
    func controller(controller: NSFetchedResultsController,
        didChangeObject object: AnyObject,
        atIndexPath indexPath: NSIndexPath,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath) {
            switch type {
            case .Insert:
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            case .Update:
                let cell = self.tableView.cellForRowAtIndexPath(indexPath) as TeamListCell
                self.configureCell(cell, indexPath: indexPath)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            case .Move:
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                return
            }
    }
    
    /* called last
    tells `UITableView` updates are complete */
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}
