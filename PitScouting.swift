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
    
    //tables
    var buttons = [UIButton]()
    var textFields = [UITextField]()
    
    var textViewOriginalHeight: CGFloat = CGFloat()
    var textViewIsSelected = false
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool{
        switch textField{
        case teamNumberTxt:
            teamNumber = teamNumberTxt.text
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
        case bottomStackerButton,topStackerBtn:
            var btns: [UIButton] = [bottomStackerButton,topStackerBtn]
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
                autoMobility = true
            } else {
                autoMobility = false
                sender.backgroundColor = UIColor.lightGrayColor()
            }
        case moveToteBtn:
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                autoNoneBtn.backgroundColor = UIColor.lightGrayColor()
                autoTote = true
            } else {
                autoTote = false
                sender.backgroundColor = UIColor.lightGrayColor()
            }
        case moveContainerBtn:
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                autoNoneBtn.backgroundColor = UIColor.lightGrayColor()
                autoContainer = true
            } else {
                autoContainer = false
                sender.backgroundColor = UIColor.lightGrayColor()
            }
        case stackTotesBtn:
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                autoNoneBtn.backgroundColor = UIColor.lightGrayColor()
                autoStack = true
            } else {
                autoStack = false
                sender.backgroundColor = UIColor.lightGrayColor()
            }
        case stepContainersBtn:
            if(sender.backgroundColor == UIColor.lightGrayColor()){
                sender.backgroundColor = UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1)
                autoNoneBtn.backgroundColor = UIColor.lightGrayColor()
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
        case noodlesNoneBtn,intoContainerBtn,intoLandFillBtn:
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
            
            let ent = NSEntityDescription.entityForName("PitTeam", inManagedObjectContext: context)
            
            var newPitTeam = PitTeam(entity: ent!, insertIntoManagedObjectContext: context) as PitTeam
            
            
            newPitTeam.uniqueID =  Int(NSDate().timeIntervalSince1970)
            newPitTeam.teamNumber = teamNumber
            newPitTeam.teamName = teamName
            newPitTeam.driveTrain = driveTrain
            newPitTeam.stackTotes = stackTotes
            newPitTeam.stackerType = stackerType
            newPitTeam.heightOfStack = heightOfStack
            newPitTeam.stackContainer = stackContainer
            newPitTeam.containerLevel = containerLevel
            newPitTeam.carryCapacity = carryCapacity
            newPitTeam.withContainer = withContainer
            newPitTeam.autoNone = autoNone
            newPitTeam.autoMobility = autoMobility
            newPitTeam.autoTote = autoTote
            newPitTeam.autoContainer = autoContainer
            newPitTeam.autoStack = autoStack
            newPitTeam.autoStepContainer = autoStepContainer
            newPitTeam.coop = coop
            newPitTeam.noodles = noodles
            newPitTeam.strategy = strategy
            newPitTeam.additionalNotes = additionalNotes
            context.save(nil)
            loadSaved()
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
        buttons = [dropCenterBtn,fourWheelDriveBtn,mecanumBtn,swerveCrabBtn,stackTotesYesBtn,stackTotesNoBtn,bottomStackerButton,topStackerBtn,stackContainerYesBtn,stackContainerNoBtn,carryContainerBtn,autoNoneBtn,mobilityBtn,moveToteBtn,moveContainerBtn,stackTotesBtn,stepContainersBtn,coopNoneBtn,placerBtn,stackerBtn,noodlesNoneBtn,intoContainerBtn,intoLandFillBtn,feederBtn,totePlacerBtn,containerPlacerBtn,toteAndContainerBtn,saveBtn]
        
        textFields = [teamNumberTxt,teamNameTxt,otherDriveTrainTxt,heightOfStackTxt,containerLvlTxt,carryCapacityTxt]
        
        resetPitScouting()
        
        
        textViewOriginalHeight = additionalNotesTxt.frame.origin.y
        
        self.frameView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
