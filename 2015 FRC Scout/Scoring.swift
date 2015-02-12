//
//  Scoring.swift
//  2015 FRC Scout
//
//  Created by David Swed on 1/9/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit
import CoreData

class Scoring: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scoutPosLbl: UILabel!
    @IBOutlet weak var matchNumberLbl: UITextField!
    @IBOutlet weak var teamNumberLbl: UITextField!
    @IBOutlet weak var modeLbl: UILabel!
    
    //Auto UI items
    @IBOutlet weak var autoToteLbl: UILabel!
    @IBOutlet weak var autoToteScoreLbl: UILabel!
    @IBOutlet weak var autoContainerLbl: UILabel!
    @IBOutlet weak var autoContainerScoreLbl: UILabel!
    @IBOutlet weak var autoToteAddBtn: UIButton!
    @IBOutlet weak var autoToteSubBtn: UIButton!
    @IBOutlet weak var autoContainerAddBtn: UIButton!
    @IBOutlet weak var autoContainerSubBtn: UIButton!
    @IBOutlet weak var autoZoneLbl: UILabel!
    @IBOutlet weak var autoZoneLine: UIView!
    @IBOutlet weak var autoZoneRobot: UIImageView!
    @IBOutlet weak var autoStackBtn: UIButton!
    
    //Teleop UI Items
    @IBOutlet weak var containerNoodleLbl: UILabel!
    @IBOutlet weak var containerNoodleScoreLbl: UILabel!
    @IBOutlet weak var containerNoodleAddBtn: UIButton!
    @IBOutlet weak var containerNoodleSubBtn: UIButton!
    @IBOutlet weak var landfillNoodleLbl: UILabel!
    @IBOutlet weak var landfillNoodleScoreLbl: UILabel!
    @IBOutlet weak var landfillNoodleAddBtn: UIButton!
    @IBOutlet weak var landfillNoodleSubBtn: UIButton!
    @IBOutlet weak var coopTotesLbl: UILabel!
    @IBOutlet weak var coopTotesScoreLbl: UILabel!
    @IBOutlet weak var coopTotesAddBtn: UIButton!
    @IBOutlet weak var coopTotesUndoBtn: UIButton!
    @IBOutlet weak var stackKilledBtn: UIButton!
    @IBOutlet weak var toteStackLbl: UILabel!
    @IBOutlet weak var tote1: UIButton!
    @IBOutlet weak var tote2: UIButton!
    @IBOutlet weak var tote3: UIButton!
    @IBOutlet weak var tote4: UIButton!
    @IBOutlet weak var tote5: UIButton!
    @IBOutlet weak var tote6: UIButton!
    @IBOutlet weak var toteInsertBtn: UIButton!
    @IBOutlet weak var toteBtmInsertBtn: UIButton!
    @IBOutlet weak var containerInsertBtn: UIButton!
    @IBOutlet weak var toteStackAddBtn: UIButton!
    @IBOutlet weak var toteStackUndoBtn: UIButton!
    @IBOutlet weak var toteStackScoreLbl: UILabel!
    @IBOutlet weak var coopTote4: UIButton!
    @IBOutlet weak var coopTote3: UIButton!
    @IBOutlet weak var coopTote2: UIButton!
    @IBOutlet weak var coopTote1: UIButton!
    @IBOutlet weak var coopToteInsertBtn: UIButton!
    @IBOutlet weak var coopToteBtmInsertBtn: UIButton!
    @IBOutlet weak var penaltyBtn: UIButton!
    
    //array of the buttons in the tote stack UI. Initialized in ViewDidLoad()
    var toteBtns = [UIButton]()
    //array of the buttons in the coop tote stack UI. Initialized in ViewDidLoad()
    var coopBtns = [UIButton]()
    //positions that the top tote insert button moves to
    var toteInsertBtnLocations: [CGFloat] = [662,592,522,452,382,312]
    //positions that the container insert button moves to
    var containerInsertBtnLocations: [CGFloat] = [0,589,519,449,379,309,239]
    //positions that the coop Tote insert button moves to
    var coopInsertBtnLocations: [CGFloat] = [598,516,429,344]
    //x position of the container insert button when it's to the left of the tote stack
    var containerInsertBtnSide: CGFloat = 27
    //x postion of the container insert button when it's in the center of the tote stack
    var containerInsertBtnCenter: CGFloat = 141
    
    
    //Score Variables
    struct ToteStackStruct {
        var totes = [Bool]()
        var containerLvl = 0
    }
    
    struct CoopStackStruct {
        var totes = [Bool]()
    }
    
    var numStacks = 0
    var numCoopStacks = 0
    var numNoodlesInContainer = 0
    var numNoodlesPushedInLandfill = 0
    var numStacksKnockedOver = 0
    var toteStacks = [ToteStackStruct]()
    var coopStacks = [CoopStackStruct]()
    var numAutoTotes = 0
    var numAutoContainers = 0
    var autoDrive = false
    var autoStack = false
    var currentToteStack = ToteStackStruct()
    var currentCoopStack = CoopStackStruct()
    var numCoopTotes = 0
    var numPenalties = 0
    
    //Regional
    var regional = "Week Zero"
    
    //Variable stores if Autonomous mode is showing. false if in teleop mode
    var autoShowing = true
    //recognizes if the user has swiped to change between modes
    var swipeGesture = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        toteBtns = [tote1,tote2,tote3,tote4,tote5,tote6]
        coopBtns = [coopTote1,coopTote2,coopTote3,coopTote4]
        super.viewDidLoad()
        resetScoringScreen()
        showAuto()
        self.view.userInteractionEnabled = true
        self.view.multipleTouchEnabled = true
        swipeGesture.addTarget(self, action: "twoFingerPanDetected:")
        swipeGesture.minimumNumberOfTouches = 2
        self.view.addGestureRecognizer(swipeGesture)
        
        var robotDrag = UIPanGestureRecognizer(target: self, action: "robotDrag:")
        robotDrag.maximumNumberOfTouches = 1
        robotDrag.minimumNumberOfTouches = 1
        autoZoneRobot.addGestureRecognizer(robotDrag)
    }
    
    //function to display all teleop UI items and hide auto UI
    func showTeleop(){
        //Auto Items
        autoToteLbl.hidden = true
        autoToteScoreLbl.hidden = true
        autoContainerScoreLbl.hidden = true
        autoContainerLbl.hidden = true
        autoToteAddBtn.enabled = false
        autoToteAddBtn.hidden = true
        autoToteSubBtn.enabled = false
        autoToteSubBtn.hidden = true
        autoContainerAddBtn.enabled = false
        autoContainerAddBtn.hidden = true
        autoContainerSubBtn.enabled = false
        autoContainerSubBtn.hidden = true
        autoZoneLbl.hidden = true
        autoZoneLine.hidden = true
        autoZoneRobot.userInteractionEnabled = false
        autoZoneRobot.hidden = true
        autoStackBtn.enabled = false
        autoStackBtn.hidden = true
        
        //Tele Items
        containerNoodleAddBtn.enabled = true
        containerNoodleAddBtn.hidden = false
        containerNoodleSubBtn.enabled = true
        containerNoodleSubBtn.hidden = false
        containerNoodleScoreLbl.hidden = false
        containerNoodleLbl.hidden = false
        landfillNoodleLbl.hidden = false
        landfillNoodleScoreLbl.hidden = false
        landfillNoodleAddBtn.enabled = true
        landfillNoodleAddBtn.hidden = false
        landfillNoodleSubBtn.enabled = true
        landfillNoodleSubBtn.hidden = false
        coopTotesLbl.hidden = false
        coopTotesScoreLbl.hidden = false
        coopTotesAddBtn.enabled = true
        coopTotesAddBtn.hidden = false
        coopTotesUndoBtn.enabled = true
        coopTotesUndoBtn.hidden = false
        coopTote1.enabled = true
        coopTote1.hidden = false
        coopTote2.enabled = true
        coopTote2.hidden = false
        coopTote3.enabled = true
        coopTote3.hidden = false
        coopTote4.enabled = true
        coopTote4.hidden = false
        coopToteInsertBtn.enabled = true
        coopToteInsertBtn.hidden = false
        coopToteBtmInsertBtn.enabled = false
        coopToteBtmInsertBtn.hidden = true
        toteStackLbl.hidden = false
        toteStackScoreLbl.hidden = false
        toteStackAddBtn.enabled = true
        toteStackAddBtn.hidden = false
        toteStackUndoBtn.enabled = true
        toteStackUndoBtn.hidden = false
        tote1.enabled = true
        tote1.hidden = false
        tote2.enabled = true
        tote2.hidden = false
        tote3.enabled = true
        tote3.hidden = false
        tote4.enabled = true
        tote4.hidden = false
        tote5.enabled = true
        tote5.hidden = false
        tote6.enabled = true
        tote6.hidden = false
        toteInsertBtn.enabled = true
        toteInsertBtn.hidden = false
        toteBtmInsertBtn.enabled = false
        toteBtmInsertBtn.hidden = true
        containerInsertBtn.enabled = false
        containerInsertBtn.hidden = true
        stackKilledBtn.enabled = true
        stackKilledBtn.hidden = false
        penaltyBtn.enabled = true
        penaltyBtn.hidden = false
        modeLbl.text = "Teleoperated Scoring Mode"
        autoShowing = false
    }
    
    //function to display all auto UI items and hide teleop UI
    func showAuto(){
        //Auto Items
        autoToteLbl.hidden = false
        autoToteScoreLbl.hidden = false
        autoContainerScoreLbl.hidden = false
        autoContainerLbl.hidden = false
        autoToteAddBtn.enabled = true
        autoToteAddBtn.hidden = false
        autoToteSubBtn.enabled = true
        autoToteSubBtn.hidden = false
        autoContainerAddBtn.enabled = true
        autoContainerAddBtn.hidden = false
        autoContainerSubBtn.enabled = true
        autoContainerSubBtn.hidden = false
        autoZoneLbl.hidden = false
        autoZoneLine.hidden = false
        autoZoneRobot.userInteractionEnabled = true
        autoZoneRobot.hidden = false
        autoStackBtn.enabled = true
        autoStackBtn.hidden = false
        
        //Tele Items
        containerNoodleAddBtn.enabled = false
        containerNoodleAddBtn.hidden = true
        containerNoodleSubBtn.enabled = false
        containerNoodleSubBtn.hidden = true
        containerNoodleScoreLbl.hidden = true
        containerNoodleLbl.hidden = true
        landfillNoodleLbl.hidden = true
        landfillNoodleScoreLbl.hidden = true
        landfillNoodleAddBtn.enabled = false
        landfillNoodleAddBtn.hidden = true
        landfillNoodleSubBtn.enabled = false
        landfillNoodleSubBtn.hidden = true
        coopTotesLbl.hidden = true
        coopTotesScoreLbl.hidden = true
        coopTotesAddBtn.enabled = false
        coopTotesAddBtn.hidden = true
        coopTotesUndoBtn.enabled = false
        coopTotesUndoBtn.hidden = true
        coopTote1.enabled = false
        coopTote1.hidden = true
        coopTote2.enabled = false
        coopTote2.hidden = true
        coopTote3.enabled = false
        coopTote3.hidden = true
        coopTote4.enabled = false
        coopTote4.hidden = true
        coopToteInsertBtn.enabled = false
        coopToteInsertBtn.hidden = true
        coopToteBtmInsertBtn.enabled = false
        coopToteBtmInsertBtn.hidden = true
        toteStackLbl.hidden = true
        toteStackScoreLbl.hidden = true
        toteStackAddBtn.enabled = false
        toteStackAddBtn.hidden = true
        toteStackUndoBtn.enabled = false
        toteStackUndoBtn.hidden = true
        tote1.enabled = false
        tote1.hidden = true
        tote2.enabled = false
        tote2.hidden = true
        tote3.enabled = false
        tote3.hidden = true
        tote4.enabled = false
        tote4.hidden = true
        tote5.enabled = false
        tote5.hidden = true
        tote6.enabled = false
        tote6.hidden = true
        toteInsertBtn.enabled = false
        toteInsertBtn.hidden = true
        toteBtmInsertBtn.enabled = false
        toteBtmInsertBtn.hidden = true
        containerInsertBtn.enabled = false
        containerInsertBtn.hidden = true
        stackKilledBtn.enabled = false
        stackKilledBtn.hidden = true
        penaltyBtn.enabled = false
        penaltyBtn.hidden = true
        modeLbl.text = "Autonomous Scoring Mode"
        autoShowing = true
    }
    
    //resets all scores and button positions
    func resetScoringScreen(){
        //Variables
        numStacks = 0
        numCoopStacks = 0
        numNoodlesInContainer = 0
        numNoodlesPushedInLandfill = 0
        numStacksKnockedOver = 0
        toteStacks = [ToteStackStruct]()
        coopStacks = [CoopStackStruct]()
        numAutoTotes = 0
        numAutoContainers = 0
        autoDrive = false
        autoStack = false
        
        //Auto Items
//        autoDriveBtn.alpha = 0.5
        autoToteScoreLbl.text = "0"
        autoContainerScoreLbl.text = "0"
        autoZoneRobot.center = CGPoint(x: autoZoneRobot.center.x, y: autoZoneLine.center.y + 65)
        
        //Tele Items
        resetToteStack()
        resetCoopStack()
        containerNoodleScoreLbl.text = "0"
        landfillNoodleScoreLbl.text = "0"
        coopTotesScoreLbl.text = "0"
        toteStackScoreLbl.text = "0"
    }
    
    //resets the UI for the tote stack
    func resetToteStack(){
        for btn in toteBtns {
            btn.setBackgroundImage(UIImage(named: "ToteOutline"), forState: .Normal)
            btn.enabled = true
            btn.hidden = false
        }
        currentToteStack = ToteStackStruct()
        toteInsertBtn.frame.origin.y = toteInsertBtnLocations[0]
        containerInsertBtn.hidden = true
        containerInsertBtn.enabled = false
        toteBtmInsertBtn.enabled = false
        toteBtmInsertBtn.hidden = true
        containerInsertBtn.frame.origin.y = containerInsertBtnLocations[0]
        containerInsertBtn.frame.origin.x = containerInsertBtnSide
    }
    
    //resets the coop stack
    func resetCoopStack(){
        for btn in coopBtns {
            btn.enabled = true
            btn.hidden = false
        }
        currentCoopStack = CoopStackStruct()
        coopToteInsertBtn.frame.origin.y = coopInsertBtnLocations[0]
        if(numCoopTotes < 3){
            coopToteInsertBtn.hidden = false
            coopToteInsertBtn.enabled = true
        }
        coopToteBtmInsertBtn.hidden = true
        coopToteBtmInsertBtn.enabled = false
    }
    
    //switches between auto and tele scorring mode
    func twoFingerPanDetected(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if (  recognizer.state == UIGestureRecognizerState.Ended){
            if( autoShowing && translation.y > 50){
                showTeleop()
            } else if(translation.y < -50) {
                showAuto()
            }
        }
    }
    
    //removes auto totes from score
    @IBAction func autoToteSubBtnPress(sender: AnyObject) {
        //checks to see if there are auto totes scored
        if (numAutoTotes > 0) {
            numAutoTotes -= 1
            autoToteScoreLbl.text = "\(numAutoTotes)"
        }
    }
    
    //adds auto totes to score
    @IBAction func autoToteAddBtnPress(sender: AnyObject) {
        //makes sure no more than three auto totes have been scored and there is no autoStack
        if (numAutoTotes < 3 && autoStack == false) {
            numAutoTotes += 1
            autoToteScoreLbl.text = "\(numAutoTotes)"
        }
    }
    
    //removes auto Containers from score
    @IBAction func autoContainerSubBtnPress(sender: AnyObject) {
        //checks to make sure score is greater than 0
        if (numAutoContainers > 0){
            numAutoContainers -= 1
            autoContainerScoreLbl.text = "\(numAutoContainers)"
        }
    }
    
    //adds auto Containers to score
    @IBAction func autoContainerAddBtnPress(sender: AnyObject) {
        //checks to make sure no more than 7 containers have been scored
        if (numAutoContainers < 7){
            numAutoContainers += 1
            autoContainerScoreLbl.text = "\(numAutoContainers)"
        }
    }
    
    //scores a stack of three auto containers
    @IBAction func autoStackBtnPress(sender: AnyObject) {
        if (autoStack == false){
            autoStack = true
            //set the auto score to zero
            numAutoTotes = 0
            autoToteScoreLbl.text = "0"
            autoStackBtn.setBackgroundImage(UIImage(named: "ToteStack"), forState: .Normal)
        } else {
            autoStack = false
            autoStackBtn.setBackgroundImage(UIImage(named: "ToteStackOutline"), forState: .Normal)
        }
    }
    
    //listens for Robot Drag and handles what to do with it
    var startY : CGFloat = 0
    func robotDrag(sender: UIPanGestureRecognizer) {
        var robotView = sender.view!
        var recognizerState = sender.state
        
        let moveDiff : CGFloat = 65
        
        switch recognizerState{
            case .Began:
                startY = robotView.center.y
            case .Changed:
                var translation = sender.translationInView(self.view)
                robotView.center = CGPoint(x: robotView.center.x, y: robotView.center.y + translation.y)
                if robotView.center.y < autoZoneLine.center.y - moveDiff {
                    robotView.center = CGPoint(x: robotView.center.x, y: autoZoneLine.center.y - moveDiff)
                } else if robotView.center.y > autoZoneLine.center.y + moveDiff {
                    robotView.center = CGPoint(x: robotView.center.x, y: autoZoneLine.center.y + moveDiff)
                }
                sender.setTranslation(CGPoint(x: 0, y: 0), inView: self.view)
                
            case .Ended:
                if robotView.center.y < autoZoneLine.center.y - 10 {
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        robotView.center = CGPoint(x: robotView.center.x, y: self.autoZoneLine.center.y - moveDiff)
                    })
                } else if robotView.center.y > autoZoneLine.center.y + 10 {
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        robotView.center = CGPoint(x: robotView.center.x, y: self.autoZoneLine.center.y + moveDiff)
                    })
                } else {
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        robotView.center = CGPoint(x: robotView.center.x, y: self.startY)
                    })
                }
            
                if robotView.center.y == autoZoneLine.center.y - moveDiff {
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.autoZoneLbl.layer.backgroundColor = UIColor(red: 3.0/255, green: 200.0/255, blue: 4.0/255, alpha: 1.0).CGColor
                        self.autoZoneLbl.layer.borderColor = UIColor.whiteColor().CGColor
                        self.autoDrive = true
                    })
                } else {
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.autoZoneLbl.layer.backgroundColor = UIColor.whiteColor().CGColor
                        self.autoZoneLbl.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).CGColor
                        self.autoDrive = false
                    })
                }
            default:
                return
        }
    }
    
    //adds to number of noodles placed into a container
    @IBAction func noodleContainerAddBtnPress(sender: AnyObject) {
        if( numNoodlesInContainer < 10){
            numNoodlesInContainer += 1
            containerNoodleScoreLbl.text = "\(numNoodlesInContainer)"
        }
    }
    
    //subtracts from number of noodles placed in a container
    @IBAction func noodleContainerSubBtnPress(sender: AnyObject) {
        if( numNoodlesInContainer > 0){
            numNoodlesInContainer -= 1
            containerNoodleScoreLbl.text = "\(numNoodlesInContainer)"
        }
    }
    
    //adds to number of noodles scored in landfill
    @IBAction func noodleLandfillAddBtnPress(sender: AnyObject) {
        if(numNoodlesPushedInLandfill < 10){
            numNoodlesPushedInLandfill += 1
            landfillNoodleScoreLbl.text = "\(numNoodlesPushedInLandfill)"
        }
    }
    
    //subtracts from number of noodles scored in landfill
    @IBAction func noodleLandfillSubBtnPress(sender: AnyObject) {
        if(numNoodlesPushedInLandfill > 0){
            numNoodlesPushedInLandfill -= 1
            landfillNoodleScoreLbl.text = "\(numNoodlesPushedInLandfill)"
        }
    }
    
    //adds the currentToteStack to the scored tote stacks
    @IBAction func toteStackAddBtnPress(sender: AnyObject) {
        //determine if there is a new tote in the current stack
        var newToteInStack = false
        for tote in currentToteStack.totes {
            if (tote == true) {
                newToteInStack = true
            }
        }
        
        //checks to make sure there are totes in the current stack and that either there are new totes
        //or that there is a container scored
        if(currentToteStack.totes.count > 0 && (newToteInStack || currentToteStack.containerLvl > 0)){
            toteStacks.append(currentToteStack)
            toteStackScoreLbl.text = "\(toteStacks.count)"
            resetToteStack()
        }
    }
    
    //removes the last scored tote stack
    @IBAction func toteStackUndoBtnPress(sender: AnyObject) {
        //If there is a current stack, reset it
        if(currentToteStack.totes.count > 0){
            resetToteStack()
        }
        else if(toteStacks.count > 0){ //else remove last stack
            toteStacks.removeLast()
            toteStackScoreLbl.text = "\(toteStacks.count)"
        }
    }
    
    //adds the currentCoopStack to scored coop Stacks
    @IBAction func coopStackAddBtnPress(sender: AnyObject) {
        //determine if there is a new tote in the stack
        var newToteInStack = false
        for tote in currentCoopStack.totes {
            if (tote == true) {
                newToteInStack = true
                numCoopTotes++
            }
        }
        //check if there are totes in the stack if any are new
        if(currentCoopStack.totes.count > 0 && newToteInStack){
            coopStacks.append(currentCoopStack)
            coopTotesScoreLbl.text = "\(coopStacks.count)"
            resetCoopStack()
        }
    }
    
    //remove last scored coop stack
    @IBAction func coopStackUndoBtnPress(sender: AnyObject) {
        
        
        if(coopStacks.count > 0 && currentCoopStack.totes.count==0){   //check that is a stack to remove
            //subtract from number of used coop totes
            var newToteInStack = false
            for tote in coopStacks[coopStacks.count-1].totes {
                if (tote == true) {
                    newToteInStack = true
                    numCoopTotes--
                }
            }
            coopStacks.removeLast()
            coopTotesScoreLbl.text = "\(coopStacks.count)"
        }
        resetCoopStack()
    }
    
    //a tote in the tote stack has been touched. That tote and all of the
    //totes below it will be marked as having been there before
    @IBAction func toteTouch(sender: UIButton) {
        //determine which tote button was pressed
        var toteIndex = find(toteBtns,sender)
        
        //Special case if the user is trying to reset bottom tote
        if ((toteIndex == 0 && currentToteStack.totes.count == 1) == false){
            resetToteStack()
            //hide the containerInsertBtn and bottom tote insert tote button
            containerInsertBtn.hidden = false
            containerInsertBtn.enabled = true
            toteBtmInsertBtn.enabled = true
            toteBtmInsertBtn.hidden = false
            //move the container to be right above top tote
            containerInsertBtn.frame.origin.y = containerInsertBtnLocations[toteIndex!+1]
            //check to make sure the toteButton that was pressed was identified and not top tote button
            if (toteIndex != nil && toteIndex < 5){
                toteInsertBtn.hidden = false    //show and move tote insert button
                toteInsertBtn.enabled = true
                toteInsertBtn.frame.origin.y = toteInsertBtnLocations[toteIndex!+1]
            } else if (toteIndex == 5){     //hide toteInsertButtons if top tote is pressed
                toteInsertBtn.hidden = true
                toteInsertBtn.enabled = false
                toteBtmInsertBtn.enabled = false
                toteBtmInsertBtn.hidden = true
            }
            //add touched tote and totes below to current stack
            for var i = 0;i <= toteIndex; ++i {
                currentToteStack.totes.append(false)
            }
            //change color of totes based on whether they're old or new
            for var i = 0; i < currentToteStack.totes.count; ++i{
                if (currentToteStack.totes[i] == false){
                    toteBtns[i].alpha = 1.0
                    toteBtns[i].setBackgroundImage(UIImage(named: "ToteRed"), forState: .Normal)
                }
                else {
                    toteBtns[i].alpha = 1.0
                    toteBtns[i].setBackgroundImage(UIImage(named: "ToteGray"), forState: .Normal)
                }
            }
        }
        else {
            resetToteStack()
        }
        
    }
    
    //adds a tote to top of current tote stack
    @IBAction func toteInsertBtnPress(sender: AnyObject) {
        insertTote(false)
    }
    
    //adds a tote to bottom of current tote stack
    @IBAction func toteBtmInsertBtnPress(sender: AnyObject) {
        insertTote(true)
    }
    
    //inserts a tote into the stack
    func insertTote(fromBottom: Bool) {
        //adds to bottom if true, adds to top if false
        if (fromBottom){
            currentToteStack.totes.insert(true, atIndex: 0)
        } else {
            currentToteStack.totes.append(true)
        }
        //number of totes in current stack
        var numTotes = currentToteStack.totes.count
        //shows bottom tote insert button and moves top tote insert button,
        //hides insert buttons if there's 6 totes
        if (currentToteStack.totes.count<6){
            toteInsertBtn.frame.origin.y = toteInsertBtnLocations[numTotes]
            toteBtmInsertBtn.enabled = true
            toteBtmInsertBtn.hidden = false
        }
        else {
            toteInsertBtn.hidden = true
            toteInsertBtn.enabled = false
            toteBtmInsertBtn.enabled = false
            toteBtmInsertBtn.hidden = true
        }
        //shows and moves container insert button
        containerInsertBtn.hidden = false
        containerInsertBtn.enabled = true
        containerInsertBtn.frame.origin.y = containerInsertBtnLocations[numTotes]
        //shows and adds color to totes based on if they're new or old
        for var i = 0; i < currentToteStack.totes.count; ++i{
            toteBtns[i].hidden = false
            toteBtns[i].enabled = true
            if (currentToteStack.totes[i] == false){
                toteBtns[i].alpha = 1.0
                toteBtns[i].setBackgroundImage(UIImage(named: "ToteRed"), forState: .Normal)
            }
            else {
                toteBtns[i].alpha = 1.0
                toteBtns[i].setBackgroundImage(UIImage(named: "ToteGray"), forState: .Normal)
            }
        }
    }
    
    //adds a container to top of stack and hides the unused totes above it
    @IBAction func containerInsertBtnPress(sender: AnyObject) {
        containerInsertBtn.frame.origin.x = containerInsertBtnCenter
        currentToteStack.containerLvl = currentToteStack.totes.count
        for (var i = 5; i >= currentToteStack.totes.count; i -= 1 ){
            toteBtns[i].hidden = true
            toteBtns[i].enabled = false
        }
        
    }
    
    //a coop totes in the stack UI has been touched. That coop tote
    //and those below it will be marked as having been there before
    @IBAction func coopTouch(sender: UIButton) {
        var toteIndex = find(coopBtns,sender)
        //Special case if the user is trying to reset bottom tote
        if ((toteIndex == 0 && currentCoopStack.totes.count == 1) == false){
            resetCoopStack()
            //checks that the tote button was identified and not the top tote
            if (toteIndex != nil && toteIndex < 3){     //show insert buttons
                coopToteInsertBtn.hidden = false
                coopToteInsertBtn.enabled = true
                coopToteBtmInsertBtn.hidden = false
                coopToteBtmInsertBtn.enabled = true
                coopToteInsertBtn.frame.origin.y = coopInsertBtnLocations[toteIndex!+1]
            } else if (toteIndex == 3){     //hide insert buttons
                coopToteInsertBtn.hidden = true
                coopToteInsertBtn.enabled = false
                coopToteBtmInsertBtn.hidden = true
                coopToteBtmInsertBtn.enabled = false
            }
            //adds old totes to currentCoopStack and colors them
            for var i = 0;i <= toteIndex; ++i {
                coopBtns[i].alpha = 1.0
                coopBtns[i].backgroundColor = UIColor.cyanColor()
                currentCoopStack.totes.append(false)
            }
            if(numCoopTotes >= 3){
                coopToteInsertBtn.hidden = true
                coopToteInsertBtn.enabled = false
                coopToteBtmInsertBtn.hidden = true
                coopToteBtmInsertBtn.enabled = false
            }
        }
        else {
            resetCoopStack()
        }
        
    }
    
    //adds to number of stacks knocked over
    @IBAction func knockStackBtnPress(sender: AnyObject) {
        numStacksKnockedOver++
    }
    
    //adds to number of penalties in match
    @IBAction func penaltyBtnPress(sender: AnyObject) {
        numPenalties++
    }
    
    //adds coop tote to top of currentCoopStack
    @IBAction func coopInsertBtnPress(sender: AnyObject) {
        insertCoopTote(false)
    }
    
    //inserts a tote into the stack
    func insertCoopTote(fromBottom: Bool){
        //if true then adds a tote to the the bottom, else adds to the bottom
        if(fromBottom){
            currentCoopStack.totes.insert(true, atIndex: 0)
        } else {
            currentCoopStack.totes.append(true)
        }
        //determines number of totes in the stack
        var numTotes = currentCoopStack.totes.count
        
        if (numTotes<4){    //moves top tote insert button and shows bottom insert button
            coopToteInsertBtn.frame.origin.y = coopInsertBtnLocations[numTotes]
            coopToteBtmInsertBtn.hidden = false
            coopToteBtmInsertBtn.enabled = true
        }
        else {      //if at the top of the stack, hide the insert buttons
            coopToteInsertBtn.hidden = true
            coopToteInsertBtn.enabled = false
            coopToteBtmInsertBtn.hidden = true
            coopToteBtmInsertBtn.enabled = false
        }
        //determines number of alliance totes in stack
        var numAllianceTotes = 0
        for x in currentCoopStack.totes {
            if (x){
                numAllianceTotes += 1
            }
        }
        //hides the insert buttons if there are 3 alliance totes
        if((numAllianceTotes+numCoopTotes) >= 3){
            coopToteInsertBtn.hidden = true
            coopToteInsertBtn.enabled = false
            coopToteBtmInsertBtn.hidden = true
            coopToteBtmInsertBtn.enabled = false
        }
        //colors the totes based on if they're old or new
        for var i = 0; i < currentCoopStack.totes.count; ++i{
            if (currentCoopStack.totes[i] == false){
                coopBtns[i].alpha = 1.0
                coopBtns[i].backgroundColor = UIColor.cyanColor()
            }
            else {
                coopBtns[i].alpha = 1.0
                coopBtns[i].backgroundColor = UIColor.darkGrayColor()
            }
        }
    }
    
    //inserts a coop tote into the bottom of the stack
    @IBAction func coopBtmInsertBtnPress(sender: AnyObject) {
        insertCoopTote(true)
    }
    
    
    //Saves match data
    @IBAction func saveMatchButtonPress(sender: AnyObject) {
        println("save press")
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var regionalData: Regional?
        var teamData: Team?
        var request = NSFetchRequest(entityName: "Regional")
        request.predicate = NSPredicate(format: "name = %@", regional)
        var results = context.executeFetchRequest(request, error: nil) as [Regional]!
        if (results.count > 0){
            regionalData = results.first! as Regional!
            println("Regional Found!")
        } else {
            regionalData = NSEntityDescription.insertNewObjectForEntityForName("Regional", inManagedObjectContext: context) as? Regional
            regionalData?.name = regional
            println("Regional created")
        }
        
        var teamRequest = NSFetchRequest(entityName: "Team")
        var p1: NSPredicate = NSPredicate(format: "teamNumber = %@", teamNumberLbl.text)!
        var p2: NSPredicate = NSPredicate(format: "regional.name = %@", regional)!
        teamRequest.predicate = NSCompoundPredicate.andPredicateWithSubpredicates([p1,p2])
        var teamResults = context.executeFetchRequest(teamRequest, error: nil) as [Team]!
        if (teamResults?.count > 0) {
            teamData = teamResults.first
            println("team found")
        } else {
            var newTeam = NSEntityDescription.insertNewObjectForEntityForName("Team", inManagedObjectContext: context) as Team
            regionalData?.addTeam(newTeam)
            newTeam.regional = regionalData!
            newTeam.teamNumber = teamNumberLbl.text
            teamData = newTeam
            println("team created")
        }
        
        var requestMasterTeam = NSFetchRequest(entityName: "MasterTeam")
        requestMasterTeam.predicate = NSPredicate(format: "teamNumber = %@", teamNumberLbl.text)
        var resultsMasterTeam = context.executeFetchRequest(requestMasterTeam, error: nil) as [MasterTeam]!
        if (resultsMasterTeam.count > 0){
            teamData?.masterTeam = resultsMasterTeam.first! as MasterTeam
            println("Master Team found")
        } else {
            var newMasterTeam = NSEntityDescription.insertNewObjectForEntityForName("MasterTeam", inManagedObjectContext: context) as MasterTeam
            teamData?.masterTeam = newMasterTeam
            newMasterTeam.teamNumber = teamNumberLbl.text
            newMasterTeam.addTeam(teamData!)
            println("Master Team Created")
        }
        let ent = NSEntityDescription.entityForName("Match", inManagedObjectContext: context)
        
        var newMatch = Match(entity: ent!, insertIntoManagedObjectContext: context) as Match
        
        newMatch.autoContainers = numAutoContainers
        newMatch.autoTotes = numAutoTotes
        newMatch.numCoopStacks = numCoopStacks
        newMatch.numStacks = numStacks
        newMatch.noodlesInContainer = numNoodlesInContainer
        newMatch.penalty = numPenalties
        newMatch.stacksKnockedOver = numStacksKnockedOver
        newMatch.noodlesInLandfill = numNoodlesPushedInLandfill
        newMatch.uniqueID =  Int(NSDate().timeIntervalSince1970)
        //Match number
        //Match type
        //Totes
        //Recording team
        newMatch.autoDrive = autoDrive
        newMatch.autoStack = autoStack
        for stack in toteStacks {
            var numTotes = stack.totes.count
            var newToteStack: ToteStack = NSEntityDescription.insertNewObjectForEntityForName("ToteStack", inManagedObjectContext: context) as ToteStack
            if(numTotes >= 1) {newToteStack.tote1 = (stack.totes[0]) ? 2:1} else {newToteStack.tote1 = 0}
            if(numTotes >= 2) {newToteStack.tote2 = (stack.totes[1]) ? 2:1} else {newToteStack.tote2 = 0}
            if(numTotes >= 3) {newToteStack.tote3 = (stack.totes[2]) ? 2:1} else {newToteStack.tote3 = 0}
            if(numTotes >= 4) {newToteStack.tote4 = (stack.totes[3]) ? 2:1} else {newToteStack.tote4 = 0}
            if(numTotes >= 5) {newToteStack.tote5 = (stack.totes[4]) ? 2:1} else {newToteStack.tote5 = 0}
            if(numTotes >= 6) {newToteStack.tote6 = (stack.totes[5]) ? 2:1} else {newToteStack.tote6 = 0}
            newToteStack.containerLvl = stack.containerLvl
            newMatch.addToteStack(newToteStack)
        }
        for stack in coopStacks {
            var numTotes = stack.totes.count
            var newCoopStack: CoopStack = NSEntityDescription.insertNewObjectForEntityForName("CoopStack", inManagedObjectContext: context) as CoopStack
            if(numTotes >= 1) {newCoopStack.tote1 = (stack.totes[0]) ? 2:1} else {newCoopStack.tote1 = 0}
            if(numTotes >= 2) {newCoopStack.tote2 = (stack.totes[1]) ? 2:1} else {newCoopStack.tote2 = 0}
            if(numTotes >= 3) {newCoopStack.tote3 = (stack.totes[2]) ? 2:1} else {newCoopStack.tote3 = 0}
            if(numTotes >= 4) {newCoopStack.tote4 = (stack.totes[3]) ? 2:1} else {newCoopStack.tote4 = 0}
            newMatch.addCoopStack(newCoopStack)
        }
        
        teamData?.addMatch(newMatch)
        teamData = dataCalc.calculateAverages(teamData!)
        
        context.save(nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    /*func loadSaved() {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Match")
        request.returnsObjectsAsFaults = false
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        for res in results{
            
            var newMatch = res as Match
            for stack in newMatch.coopStacks {
                
                var newStack = stack as CoopStack
                //println("tote1 \(newStack.tote1)")
            }
        }
    }*/
    
}
