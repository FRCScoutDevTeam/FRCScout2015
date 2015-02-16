//
//  PitScouting.swift
//  2015 FRC Scout
//
//  Created by David Swed on 1/9/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit
import CoreData

class PitScouting: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    var frameView: UIView!
    //UI Items
    @IBOutlet weak var captureImageLbl: UILabel!
    @IBOutlet weak var captureImageButton: UIButton!

    @IBOutlet weak var teamNumberLbl: UILabel!
    @IBOutlet weak var teamNumberTxt: UITextField!

    @IBOutlet weak var teamNameLbl: UILabel!
    @IBOutlet weak var teamNameTxt: UITextField!

    @IBOutlet weak var driveTrainLbl: UILabel!
    @IBOutlet weak var dropCenterBtn: UIButton!
    @IBOutlet weak var fourWheelDriveBtn: UIButton!
    @IBOutlet weak var mecanumBtn: UIButton!
    @IBOutlet weak var swerveCrabBtn: UIButton!
    @IBOutlet weak var otherDriveTrainTxt: UITextField!

    @IBOutlet weak var stackTotesLbl: UILabel!
    @IBOutlet weak var stackTotesYesBtn: UIButton!
    @IBOutlet weak var stackTotesNoBtn: UIButton!

    @IBOutlet weak var stackerTypeLbl: UILabel!
    @IBOutlet weak var bottomStackerButton: UIButton!
    @IBOutlet weak var topStackerBtn: UIButton!
    @IBOutlet weak var nABtn: UIButton!

    @IBOutlet weak var heightOfStackLbl: UILabel!
    @IBOutlet weak var heightOfStackTxt: UITextField!

    @IBOutlet weak var stackContainerLbl: UILabel!
    @IBOutlet weak var stackContainerYesBtn: UIButton!
    @IBOutlet weak var stackContainerNoBtn: UIButton!

    @IBOutlet weak var containerLvlLbl: UILabel!
    @IBOutlet weak var containerLvlTxt: UITextField!

    @IBOutlet weak var carryCapacityLbl: UILabel!
    @IBOutlet weak var carryCapacityTxt: UITextField!
    @IBOutlet weak var carryContainerBtn: UIButton!

    @IBOutlet weak var autoModesLbl: UILabel!
    @IBOutlet weak var autoNoneBtn: UIButton!
    @IBOutlet weak var mobilityBtn: UIButton!
    @IBOutlet weak var moveToteBtn: UIButton!
    @IBOutlet weak var moveContainerBtn: UIButton!
    @IBOutlet weak var stackTotesBtn: UIButton!
    @IBOutlet weak var stepContainersBtn: UIButton!

    @IBOutlet weak var coopLbl: UILabel!
    @IBOutlet weak var coopNoneBtn: UIButton!
    @IBOutlet weak var placerBtn: UIButton!
    @IBOutlet weak var stackerBtn: UIButton!

    @IBOutlet weak var noodlesLbl: UILabel!
    @IBOutlet weak var noodlesNoneBtn: UIButton!
    @IBOutlet weak var intoContainerBtn: UIButton!
    @IBOutlet weak var intoLandFillBtn: UIButton!

    @IBOutlet weak var strategyLbl: UILabel!
    @IBOutlet weak var feederBtn: UIButton!
    @IBOutlet weak var totePlacerBtn: UIButton!
    @IBOutlet weak var containerPlacerBtn: UIButton!
    @IBOutlet weak var toteAndContainerBtn: UIButton!

    @IBOutlet weak var additionalNotesTxt: UITextView!
    @IBOutlet weak var saveBtn: UIButton!

    //Variables
    var teamNumber = String()
    var teamName = String()
    var driveTrain = String()
    var stackTotes = String()
    var stackerType = String()
    var heightOfStack = String()
    var stackContainer = String()
    var containerLevel = String()
    var carryCapacity = String()
    var withContainer = false
    var autoNone = false
    var autoMobility = false
    var autoTote = false
    var autoContainer = false
    var autoStack = false
    var autoStepContainer = false
    var coop = String()
    var noodles = String()
    var strategy = String()
    var additionalNotes = String()

    //Extra variables for noodles
    var intoContainer = false
    var intoLandfill = false

    //tables
    var buttons = [UIButton]()
    var textFields = [UITextField]()

    var textViewOriginalHeight: CGFloat = CGFloat()
    var textViewIsSelected = false

    //Variable to tell if editing preexisting data
    var editingOldData = false


    func textFieldShouldEndEditing(textField: UITextField) -> Bool{
        switch textField{
        case teamNumberTxt:
            teamNumber = teamNumberTxt.text
            checkForTeam()
        case teamNameTxt:
            teamName = teamNameTxt.text
        case otherDriveTrainTxt:
            driveTrain = otherDriveTrainTxt.text
            var btns: [UIButton] = [dropCenterBtn, fourWheelDriveBtn ,mecanumBtn, swerveCrabBtn]
            for btn in btns {
                btn.backgroundColor = UIColor.lightGrayColor()
            }
        case heightOfStackTxt:
            heightOfStack = heightOfStackTxt.text
        case containerLvlTxt:
            containerLevel = containerLvlTxt.text
        case carryCapacityTxt:
            carryCapacity = carryCapacityTxt.text
        default:
            return true
        }
        return true
    }

    func displayLoadedData(loadedData: PitTeam) {
        resetPitScouting()

        teamNumber = "\(loadedData.teamNumber)"
        teamName = loadedData.teamName
        driveTrain = loadedData.driveTrain
        stackTotes = loadedData.stackTotes
        stackerType = loadedData.stackerType
        heightOfStack = loadedData.heightOfStack
        stackContainer = loadedData.stackContainer
        containerLevel = loadedData.containerLevel
        carryCapacity = loadedData.carryCapacity
        withContainer = (loadedData.withContainer == true)
        autoNone = (loadedData.autoNone == true)
        autoMobility = (loadedData.autoMobility == true)
        autoTote = (loadedData.autoTote == true)
        autoContainer = (loadedData.autoContainer == true)
        autoStack = (loadedData.autoStack == true)
        autoStepContainer = (loadedData.autoStepContainer == true)
        coop = loadedData.coop
        noodles = loadedData.noodles
        strategy = loadedData.strategy
        additionalNotes = loadedData.additionalNotes

        var infoStrings: [String] = [driveTrain,stackTotes,stackerType,coop,strategy]
        var driveTrainSet = false
        for s in infoStrings {
            for b: UIButton in buttons {
                if (b.titleLabel?.text == s){
                    b.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                    if(s == driveTrain){ driveTrainSet = true }
                }
            }
        }
        if(!driveTrainSet) { otherDriveTrainTxt.text = driveTrain }
        additionalNotes = additionalNotesTxt.text
        if additionalNotesTxt.text.isEmpty {
            additionalNotesTxt.text = "Additional Notes"
            additionalNotesTxt.textColor = UIColor.lightGrayColor()
        }

        heightOfStackTxt.text = heightOfStack
        containerLvlTxt.text = containerLevel
        carryCapacityTxt.text = carryCapacity

        if(withContainer){ carryContainerBtn.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1) }
        if(autoNone){ autoNoneBtn.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1) }
        if(autoMobility){ mobilityBtn.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1) }
        if(autoTote){ moveToteBtn.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1) }
        if(autoContainer){ moveContainerBtn.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1) }
        if(autoStack){ stackTotesBtn.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1) }
        if(autoStepContainer){ stepContainersBtn.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1) }

        teamNameTxt.text = teamName
        teamNumberTxt.text = teamNumber
    }

    func checkForTeam() {
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "PitTeam")
        request.predicate = NSPredicate(format: "teamNumber = %@", teamNumber)
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        if(results.count > 0){
            displayLoadedData(results[0] as PitTeam)
            editingOldData = true
        }
        else {
            editingOldData = false
        }
    }

    @IBAction func scoutButtonPress(sender: UIButton){
        switch sender {
        case dropCenterBtn, fourWheelDriveBtn ,mecanumBtn, swerveCrabBtn:
            var btns: [UIButton] = [dropCenterBtn, fourWheelDriveBtn ,mecanumBtn, swerveCrabBtn]
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                driveTrain = sender.titleLabel!.text!
            } else {
                driveTrain = String()
                sender.backgroundColor = UIColor.lightGrayColor()
            }
            for btn in btns {
                if(btn != sender){
                    btn.backgroundColor = UIColor.lightGrayColor()
                }
            }
            otherDriveTrainTxt.text = ""
        case stackTotesYesBtn, stackTotesNoBtn:
            var btns: [UIButton] = [stackTotesYesBtn, stackTotesNoBtn]
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                stackTotes = sender.titleLabel!.text!
            } else {
                stackTotes = String()
                sender.backgroundColor = UIColor.lightGrayColor()
            }
            for btn in btns {
                if(btn != sender){
                    btn.backgroundColor = UIColor.lightGrayColor()
                }
            }
        case bottomStackerButton,topStackerBtn, nABtn:
            var btns: [UIButton] = [bottomStackerButton,topStackerBtn, nABtn]
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                stackerType = sender.titleLabel!.text!
            } else {
                stackerType = String()
                sender.backgroundColor = UIColor.lightGrayColor()
            }
            for btn in btns {
                if(btn != sender){
                    btn.backgroundColor = UIColor.lightGrayColor()
                }
            }
        case stackContainerYesBtn,stackContainerNoBtn:
            var btns: [UIButton] = [stackContainerYesBtn,stackContainerNoBtn]
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                stackContainer = sender.titleLabel!.text!
            } else {
                stackContainer = String()
                sender.backgroundColor = UIColor.lightGrayColor()
            }
            for btn in btns {
                if(btn != sender){
                    btn.backgroundColor = UIColor.lightGrayColor()
                }
            }
        case carryContainerBtn:
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                withContainer = true
            } else {
                withContainer = false
                sender.backgroundColor = UIColor.lightGrayColor()
            }
        case autoNoneBtn:
            var btns = [autoNoneBtn,mobilityBtn,moveToteBtn,moveContainerBtn,stackTotesBtn,stepContainersBtn]
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                autoNone = true
            } else {
                autoNone = false
                sender.backgroundColor = UIColor.lightGrayColor()
            }
            for btn in btns {
                if(btn != sender){
                    btn.backgroundColor = UIColor.lightGrayColor()
                }
            }
        case mobilityBtn:
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                autoNoneBtn.backgroundColor = UIColor.lightGrayColor()
                autoNone = false
                autoMobility = true
            } else {
                autoMobility = false
                sender.backgroundColor = UIColor.lightGrayColor()
            }
        case moveToteBtn:
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                autoNoneBtn.backgroundColor = UIColor.lightGrayColor()
                autoNone = false
                autoTote = true
            } else {
                autoTote = false
                sender.backgroundColor = UIColor.lightGrayColor()
            }
        case moveContainerBtn:
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                autoNoneBtn.backgroundColor = UIColor.lightGrayColor()
                autoNone = false
                autoContainer = true
            } else {
                autoContainer = false
                sender.backgroundColor = UIColor.lightGrayColor()
            }
        case stackTotesBtn:
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                autoNoneBtn.backgroundColor = UIColor.lightGrayColor()
                autoNone = false
                autoStack = true
            } else {
                autoStack = false
                sender.backgroundColor = UIColor.lightGrayColor()
            }
        case stepContainersBtn:
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                autoNoneBtn.backgroundColor = UIColor.lightGrayColor()
                autoNone = false
                autoStepContainer = true
            } else {
                autoStepContainer = false
                sender.backgroundColor = UIColor.lightGrayColor()
            }
        case coopNoneBtn,placerBtn,stackerBtn:
            var btns: [UIButton] = [coopNoneBtn,placerBtn,stackerBtn]
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                coop = sender.titleLabel!.text!
            } else {
                coop = String()
                sender.backgroundColor = UIColor.lightGrayColor()
            }
            for btn in btns {
                if(btn != sender){
                    btn.backgroundColor = UIColor.lightGrayColor()
                }
            }
        case noodlesNoneBtn:
            var btns: [UIButton] = [noodlesNoneBtn,intoContainerBtn,intoLandFillBtn]
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                noodles = sender.titleLabel!.text!
            } else {
                noodles = String()
                sender.backgroundColor = UIColor.lightGrayColor()
            }
            for btn in btns {
                if(btn != sender){
                    btn.backgroundColor = UIColor.lightGrayColor()
                }
            }
        case intoContainerBtn:
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                noodlesNoneBtn.backgroundColor = UIColor.lightGrayColor()
                autoNone = false
                intoContainer = true
            } else {
                intoContainer = false
                sender.backgroundColor = UIColor.lightGrayColor()
            }
            noodles = String()
            if(intoContainer) {
                noodles = "Container "
            }
            else if(intoLandfill && intoContainer) {
                noodles = "Container, Landfill"
            }
            else if(intoLandfill){
                noodles = "Landfill"
            }
        case intoLandFillBtn:
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                noodlesNoneBtn.backgroundColor = UIColor.lightGrayColor()
                autoNone = false
                intoLandfill = true
            } else {
                intoLandfill = false
                sender.backgroundColor = UIColor.lightGrayColor()
            }
            noodles = String()
            if(intoContainer) {
                noodles = "Container "
            }
            else if(intoLandfill && intoContainer) {
                noodles = "Container, Landfill"
            }
            else if(intoLandfill){
                noodles = "Landfill"
            }
        case feederBtn,totePlacerBtn,containerPlacerBtn,toteAndContainerBtn:
            var btns: [UIButton] = [feederBtn,totePlacerBtn,containerPlacerBtn,toteAndContainerBtn]
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                strategy = sender.titleLabel!.text!
            } else {
                strategy = String()
                sender.backgroundColor = UIColor.lightGrayColor()
            }
            for btn in btns {
                if(btn != sender){
                    btn.backgroundColor = UIColor.lightGrayColor()
                }
            }
        default:
            return
        }
    }

    @IBAction func saveBtnPress(sender: AnyObject) {
        if(checkData()) {
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext!
            var newPitTeam : PitTeam?
            if(editingOldData){
                var request = NSFetchRequest(entityName: "PitTeam")
                request.predicate = NSPredicate(format: "teamNumber = %@", teamNumber)
                var results = context.executeFetchRequest(request, error: nil) as [PitTeam]!
                if (results.count > 0){
                    newPitTeam = results.first! as PitTeam!
                }

            } else {
                let ent = NSEntityDescription.entityForName("PitTeam", inManagedObjectContext: context)
                newPitTeam = PitTeam(entity: ent!, insertIntoManagedObjectContext: context) as PitTeam!
                newPitTeam!.uniqueID =  Int(NSDate().timeIntervalSince1970)
            }
            editingOldData = false
            newPitTeam!.teamNumber = teamNumber.toInt()!
            newPitTeam!.teamName = teamName
            newPitTeam!.driveTrain = driveTrain
            newPitTeam!.stackTotes = stackTotes
            newPitTeam!.stackerType = stackerType
            newPitTeam!.heightOfStack = heightOfStack
            newPitTeam!.stackContainer = stackContainer
            newPitTeam!.containerLevel = containerLevel
            newPitTeam!.carryCapacity = carryCapacity
            newPitTeam!.withContainer = withContainer
            newPitTeam!.autoNone = autoNone
            newPitTeam!.autoMobility = autoMobility
            newPitTeam!.autoTote = autoTote
            newPitTeam!.autoContainer = autoContainer
            newPitTeam!.autoStack = autoStack
            newPitTeam!.autoStepContainer = autoStepContainer
            newPitTeam!.coop = coop
            newPitTeam!.noodles = noodles
            newPitTeam!.strategy = strategy
            newPitTeam!.additionalNotes = additionalNotes

            var requestMasterTeam = NSFetchRequest(entityName: "MasterTeam")
            requestMasterTeam.predicate = NSPredicate(format: "teamNumber = %@", teamNumber)
            var resultsMasterTeam = context.executeFetchRequest(requestMasterTeam, error: nil) as [MasterTeam]!
            if (resultsMasterTeam.count > 0){
                newPitTeam!.masterTeam = resultsMasterTeam.first! as MasterTeam
                println("Master Team found")
            } else {
                var newMasterTeam = NSEntityDescription.insertNewObjectForEntityForName("MasterTeam", inManagedObjectContext: context) as MasterTeam
                newPitTeam!.masterTeam = newMasterTeam
                newMasterTeam.teamNumber = teamNumber.toInt()!
                println("Master Team Created")
            }
            context.save(nil)
            let alertController = UIAlertController(title: "Save Complete!", message: "", preferredStyle: .Alert)

            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)

            presentViewController(alertController, animated: true, completion: nil)
            resetPitScouting()
        }

    }

    func loadSaved() {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!

        let request = NSFetchRequest(entityName: "PitTeam")
        request.returnsObjectsAsFaults = false

        var results:NSArray = context.executeFetchRequest(request, error: nil)!

        for res in results{

            var newPitTeam = res as PitTeam
            println(newPitTeam.driveTrain)

        }
    }

    func checkData() -> Bool{
        if(teamNumber.toInt() == nil){
            createInputAlert("Invalid Team Number")
            return false
        }
        if(teamName == ""){
            createInputAlert("No Team Name")
            return false
        }
        if(driveTrain == ""){
            createInputAlert("Please Enter A Drive Train")
            return false
        }
        if(stackTotes == ""){
            createInputAlert("Please Enter Information For Stack Totes")
            return false
        }
        if(stackerType == ""){
            createInputAlert("Please Enter A Stacker Type")
            return false
        }
        if(heightOfStack.toInt() == nil){
            createInputAlert("Invalid Stack Height")
            return false
        }
        if(stackContainer == ""){
            createInputAlert("Please Enter Information For Stack Container")
            return false
        }
        if(containerLevel.toInt() == nil){
            createInputAlert("Invalid Container Level")
            return false
        }
        if(containerLevel.toInt() > 6){
            createInputAlert("Container Level Is Higher Than 6")
            return false
        }
        if(carryCapacity.toInt() == nil){
            createInputAlert("Invalid Carry Capacity")
            return false
        }
        if(!autoNone && !autoMobility && !autoTote && !autoContainer && !autoStack && !autoStepContainer){
            createInputAlert("Please Enter Information For Auto Modes")
            return false
        }
        if(coop == ""){
            createInputAlert("Please Enter Information For Coop")
            return false
        }
        if(noodles == ""){
            createInputAlert("Please Enter Information For Noodles")
            return false
        }
        if(strategy == ""){
            createInputAlert("Please Enter Information For Strategy")
            return false
        }
        return true
    }

    func createInputAlert(message: String){
        let alertController = UIAlertController(title: "Input Error!", message: message, preferredStyle: .Alert)

        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)

        presentViewController(alertController, animated: true, completion: nil)
    }

    func resetPitScouting(){
        teamNumber = String()
        teamName = String()
        driveTrain = String()
        stackTotes = String()
        stackerType = String()
        heightOfStack = String()
        stackContainer = String()
        containerLevel = String()
        carryCapacity = String()
        withContainer = false
        autoNone = false
        autoMobility = false
        autoTote = false
        autoContainer = false
        autoStack = false
        autoStepContainer = false
        coop = String()
        noodles = String()
        strategy = String()
        additionalNotes = String()

        for button in buttons {
            button.layer.cornerRadius = 5
            if(button != saveBtn){
                button.backgroundColor = UIColor.lightGrayColor()
            }
        }

        for txt in textFields {
            txt.text = ""
        }

        additionalNotesTxt.layer.borderWidth = 1
        additionalNotesTxt.layer.borderColor = UIColor.lightGrayColor().CGColor
        additionalNotesTxt.layer.cornerRadius = 5
        additionalNotesTxt.text = "Additional Notes"
        additionalNotesTxt.textColor = UIColor.lightGrayColor()


    }


    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buttons = [dropCenterBtn,fourWheelDriveBtn,mecanumBtn,swerveCrabBtn,stackTotesYesBtn,stackTotesNoBtn,bottomStackerButton,topStackerBtn, nABtn,stackContainerYesBtn,stackContainerNoBtn,carryContainerBtn,autoNoneBtn,mobilityBtn,moveToteBtn,moveContainerBtn,stackTotesBtn,stepContainersBtn,coopNoneBtn,placerBtn,stackerBtn,noodlesNoneBtn,intoContainerBtn,intoLandFillBtn,feederBtn,totePlacerBtn,containerPlacerBtn,toteAndContainerBtn,saveBtn]

        textFields = [teamNumberTxt,teamNameTxt,otherDriveTrainTxt,heightOfStackTxt,containerLvlTxt,carryCapacityTxt]

        resetPitScouting()


        textViewOriginalHeight = additionalNotesTxt.frame.origin.y

        self.frameView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))


    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        resetPitScouting()
        editingOldData = false
        // Keyboard stuff.
        var center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        textViewIsSelected = true
        if additionalNotesTxt.textColor == UIColor.lightGrayColor() {
            additionalNotesTxt.text = nil
            additionalNotesTxt.textColor = UIColor.blackColor()
        }
        return true
    }

    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        textViewIsSelected = false
        additionalNotes = additionalNotesTxt.text
        if additionalNotesTxt.text.isEmpty {
            additionalNotesTxt.text = "Additional Notes"
            additionalNotesTxt.textColor = UIColor.lightGrayColor()
        }
        return true
    }



    func keyboardWillShow(notification: NSNotification) {
        if(textViewIsSelected){
            var info:NSDictionary = notification.userInfo!
            var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()

            var keyboardHeight:CGFloat = keyboardSize.height

            var animationDuration:CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as CGFloat

            self.view.bringSubviewToFront(additionalNotesTxt)

            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.additionalNotesTxt.frame = CGRect(x: self.additionalNotesTxt.frame.origin.x, y: UIScreen.mainScreen().bounds.height - keyboardHeight - self.additionalNotesTxt.frame.height, width: self.additionalNotesTxt.frame.width, height: self.additionalNotesTxt.frame.height)
            }, completion: nil)
        }

    }

    func keyboardWillHide(notification: NSNotification) {
        var info:NSDictionary = notification.userInfo!
        var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()

        var keyboardHeight:CGFloat = keyboardSize.height

        var animationDuration:CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as CGFloat

        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.additionalNotesTxt.frame = CGRect(x: self.additionalNotesTxt.frame.origin.x, y: self.textViewOriginalHeight, width: self.additionalNotesTxt.frame.width, height: self.additionalNotesTxt.frame.height)
            }, completion: nil)

    }


}
