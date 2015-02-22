//
//  ViewPitTeams.swift
//  FRC Scout
//
//  Created by David Swed on 2/9/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit
import CoreData

class ViewPitTeams: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var data = [PitTeam]()
    
    //views
    var grayOutView = UIView()
    var detailView = UIView()
    var grayOutColor = UIColor(white: 0.5, alpha: 0.5)
    
    
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
        let entity = NSEntityDescription.entityForName("PitTeam", inManagedObjectContext: managedObjectContext!)
        let sort = NSSortDescriptor(key: "teamNumber", ascending: true)
        let req = NSFetchRequest()
        req.entity = entity
        req.sortDescriptors = [sort]
        
        /* NSFetchedResultsController initialization
        a `nil` `sectionNameKeyPath` generates a single section */
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: req, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
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
        
        let tapDismiss = UITapGestureRecognizer(target: self, action: Selector("screenTapped:"))
        self.view.addGestureRecognizer(tapDismiss)
        
    }
    
    //Hides keyboard if the screen is tapped
    func screenTapped(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var selectedData: PitTeam = self.fetchedResultsController.objectAtIndexPath(indexPath) as PitTeam
        var stackTotes: String = (selectedData.stackTotes == true) ? "Yes" : "No"
        var info: [String] = [selectedData.driveTrain,stackTotes,selectedData.stackerType,"\(selectedData.heightOfStack)","\(selectedData.containerLevel)",selectedData.coop,selectedData.noodles,selectedData.strategy]
        if(selectedData.withContainer == true){
            info.append("\(selectedData.carryCapacity)" + " with Container")
        } else {
            info.append("\(selectedData.carryCapacity)")
        }
        var titles: [String] = ["Drive Train","Stack Totes", "Stacker Type", "Height of Stack", "Container Level", "Coop","Noodles","Strategy","Carry Capacity"]
        //temp variables for screen size
        var screenW: CGFloat = UIScreen.mainScreen().bounds.width
        var screenH: CGFloat = UIScreen.mainScreen().bounds.height
        
        var detailViewWidth: CGFloat = screenW*0.75
        var detailViewHeight: CGFloat = screenH*0.55
        var detailViewX: CGFloat = (screenW/2) - (detailViewWidth/2)
        var detailViewY: CGFloat = (screenH/2) - (detailViewHeight/2)
        
        var closeBtnWidth: CGFloat = (detailViewWidth * 0.15)
        var closeBtnHeight: CGFloat = 35
        
        var headerWidth: CGFloat = 150
        var headerHeight: CGFloat = 25
        
        var firstColumnX: CGFloat = detailViewWidth * 0.20
        var row1Y: CGFloat = 175
        tableView.userInteractionEnabled = false
        
        //gray out back ground
        grayOutView = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        grayOutView.backgroundColor = grayOutColor
        self.view.addSubview(grayOutView)
        
        //create detail view
        detailView = UIView(frame: CGRect(x: detailViewX, y: detailViewY, width: detailViewWidth, height: detailViewHeight))
        detailView.backgroundColor = UIColor.whiteColor()
        detailView.layer.cornerRadius = 5
        grayOutView.addSubview(detailView)
        
        
        var closeBtn = UIButton(frame: CGRect(x: detailViewWidth - closeBtnWidth - 5, y: 5, width: closeBtnWidth, height:closeBtnHeight))
        //var closeBtn = UIButton(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        closeBtn.addTarget(nil, action: Selector("closeDetailView"), forControlEvents: UIControlEvents.TouchUpInside)
        closeBtn.setTitle("Close X", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        closeBtn.setTitleColor(UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1),forState: UIControlState.Normal)
        closeBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        detailView.addSubview(closeBtn)
        
        //Team Number
        var teamNumberLbl = UILabel(frame: CGRect(x: detailViewWidth*0.75 - 50, y: detailViewHeight*0.1, width: 100, height: 40))
        teamNumberLbl.text = "\(selectedData.teamNumber)"
        teamNumberLbl.font = UIFont(name: "Futura-CondensedExtraBold", size: 35)
        teamNumberLbl.textAlignment = NSTextAlignment.Center
        detailView.addSubview(teamNumberLbl)
        
        //Team Name
        var teamNameLbl = UILabel(frame: CGRect(x: detailViewWidth*0.75-80, y: detailViewHeight*0.1 + 43, width: 160, height: 25))
        teamNameLbl.text = selectedData.teamName
        teamNameLbl.font = UIFont(name: "Heiti SC", size: 15)
        teamNameLbl.textAlignment = NSTextAlignment.Center
        detailView.addSubview(teamNameLbl)
        
        
        var counter = 0
        for var x:CGFloat = 0; x < 3; ++x {
            for var y:CGFloat = 0; y < 3; ++y {
                var xAdjust: CGFloat = detailViewWidth * (0.3 * x)
                var yAdjust: CGFloat = (headerHeight * 2.5 * y)
                var header = UILabel(frame: CGRect(x: (firstColumnX + xAdjust) - (headerWidth/2), y: row1Y + yAdjust, width: headerWidth, height: headerHeight))
                header.text = titles[counter]
                header.font = UIFont.boldSystemFontOfSize(15)
                header.textAlignment = NSTextAlignment.Center
                detailView.addSubview(header)
                
                var infoLbl = UILabel(frame: CGRect(x: (firstColumnX + xAdjust) - (headerWidth/2), y: row1Y + headerHeight + 3 + yAdjust, width: headerWidth, height: headerHeight))
                infoLbl.text = info[counter]
                infoLbl.adjustsFontSizeToFitWidth = true
                infoLbl.textAlignment = NSTextAlignment.Center
                infoLbl.layer.cornerRadius = 5
                infoLbl.backgroundColor = UIColor.lightGrayColor()
                infoLbl.font = UIFont(name: "Heiti SC", size: 15)
                infoLbl.clipsToBounds = true
                detailView.addSubview(infoLbl)
                ++counter
            }
        }
        
        //Display Auto Info
        var autoModes = [String]()
        if (selectedData.autoMobility == true) { autoModes.append("Mobility")}
        if (selectedData.autoTote == true) { autoModes.append("Move Tote")}
        if (selectedData.autoContainer == true) { autoModes.append("Move Container")}
        if (selectedData.autoStack == true) { autoModes.append("Stack Totes")}
        if (selectedData.autoStepContainer == true) { autoModes.append("Step Containers")}
        if (selectedData.autoNone == true) { autoModes.append("None")}
        
        var header = UILabel(frame: CGRect(x: detailViewWidth*0.5-50, y: row1Y + (headerHeight * 7.5), width: 100, height: headerHeight))
        header.text = "Auto Modes"
        header.font = UIFont.boldSystemFontOfSize(15)
        header.textAlignment = NSTextAlignment.Center
        detailView.addSubview(header)
        
        for  var i: CGFloat = 0; i < CGFloat(autoModes.count); ++i {
            var infoLbl = UILabel(frame: CGRect(x: detailViewWidth*0.5-55 - 57.5*(CGFloat(autoModes.count)-1) + 115*i, y: row1Y + (headerHeight * 8.5), width: 110, height: headerHeight))
            infoLbl.text = autoModes[Int(i)]
            infoLbl.adjustsFontSizeToFitWidth = true
            infoLbl.textAlignment = NSTextAlignment.Center
            infoLbl.layer.cornerRadius = 5
            infoLbl.backgroundColor = UIColor.lightGrayColor()
            infoLbl.font = UIFont(name: "Heiti SC", size: 15)
            infoLbl.clipsToBounds = true
            detailView.addSubview(infoLbl)
        }
        
        var notesView = UITextView(frame: CGRect(x: detailViewWidth*0.5-175, y: row1Y + (headerHeight * 11), width: 350, height: 90))
        notesView.text = (selectedData.additionalNotes != "") ? selectedData.additionalNotes : "No Notes"
        notesView.textAlignment = NSTextAlignment.Center
        notesView.layer.borderColor = UIColor.lightGrayColor().CGColor
        notesView.layer.borderWidth = 1
        notesView.layer.cornerRadius = 5
        notesView.font = UIFont(name: "Heiti SC", size: 15)
        notesView.clipsToBounds = true
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //return data.count
        let info = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return info.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: PitTeamCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as PitTeamCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: PitTeamCell, indexPath: NSIndexPath) {
        let team = self.fetchedResultsController.objectAtIndexPath(indexPath) as PitTeam
        cell.teamNumberLbl.text = "\(team.teamNumber)"
        cell.teamNameLbl.text = team.teamName
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
                let cell = self.tableView.cellForRowAtIndexPath(indexPath) as PitTeamCell
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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == ""){
            _fetchedResultsController?.fetchRequest.predicate = NSPredicate(value: true)
        } else if((searchText.toInt()) != nil) {
             _fetchedResultsController?.fetchRequest.predicate = NSPredicate(format: "teamNumber contains %@", searchText)
        } else {
            _fetchedResultsController?.fetchRequest.predicate = NSPredicate(format: "teamName contains %@", searchText)
        }
        
        _fetchedResultsController?.performFetch(nil)
        tableView.reloadData()
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        return true
    }
    
    
    
    
}
