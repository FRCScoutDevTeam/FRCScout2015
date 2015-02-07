//
//  Scoring.swift
//  2015 FRC Scout
//
//  Created by David Swed on 1/9/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit

class Scoring: UIViewController {

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
    @IBOutlet weak var autoDriveBtn: UIButton!
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
    @IBOutlet weak var coopTotesSubBtn: UIButton!
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
    @IBOutlet weak var toteStackSubBtn: UIButton!
    @IBOutlet weak var toteStackScoreLbl: UILabel!
    @IBOutlet weak var coopTote4: UIButton!
    @IBOutlet weak var coopTote3: UIButton!
    @IBOutlet weak var coopTote2: UIButton!
    @IBOutlet weak var coopTote1: UIButton!
    @IBOutlet weak var coopToteInsertBtn: UIButton!
    @IBOutlet weak var coopToteBtmInsertBtn: UIButton!
    
    //array of the buttons in the tote stack UI. Initialized in ViewDidLoad()
    var toteBtns = [UIButton]()
    //array of the buttons in the coop tote stack UI. Initialized in ViewDidLoad()
    var coopBtns = [UIButton]()
    //positions that the top tote insert button moves to
    var toteInsertBtnLocations: [CGFloat] = [779,697,609,526,442,358]
    //positions that the container insert button moves to
    var containerInsertBtnLocations: [CGFloat] = [0,702,614,531,447,363,281]
    //positions that the coop Tote insert button moves to
    var coopInsertBtnLocations: [CGFloat] = [598,516,429,344]
    //x position of the container insert button when it's to the left of the tote stack
    var containerInsertBtnSide: CGFloat = 27
    //x postion of the container insert button when it's in the center of the tote stack
    var containerInsertBtnCenter: CGFloat = 141
    //Score Variables
    struct ToteStack {
        var totes = [Bool]()
        var containerLvl = 0
    }
    
    struct CoopStack {
        var totes = [Bool]()
    }
    
    var numStacks = 0
    var numCoopStacks = 0
    var numNoodlesInContainer = 0
    var numNoodlesPushedInLandfill = 0
    var numStacksKnockedOver = 0
    var toteStacks = [ToteStack]()
    var coopStacks = [CoopStack]()
    var numAutoTotes = 0
    var numAutoContainers = 0
    var autoDrive = false
    var autoStack = false
    var currentToteStack = ToteStack()
    var currentCoopStack = CoopStack()
    var numCoopTotes = 0
    
    //Variable stores if Autonomous mode is showing. false if in teleop mode
    var autoShowing = true
    //recognizes if the user has swiped to change between modes
    var swipeGesture = UIPanGestureRecognizer()
    
    //function to display all teleop UI items and hide auto UI
    func showTeleop(){
        //Auto Items
        autoToteLbl.enabled = false
        autoToteLbl.hidden = true
        autoToteScoreLbl.enabled = false
        autoToteScoreLbl.hidden = true
        autoContainerScoreLbl.enabled = false
        autoContainerScoreLbl.hidden = true
        autoContainerLbl.enabled = false
        autoContainerLbl.hidden = true
        autoToteAddBtn.enabled = false
        autoToteAddBtn.hidden = true
        autoToteSubBtn.enabled = false
        autoToteSubBtn.hidden = true
        autoContainerAddBtn.enabled = false
        autoContainerAddBtn.hidden = true
        autoContainerSubBtn.enabled = false
        autoContainerSubBtn.hidden = true
        autoDriveBtn.enabled = false
        autoDriveBtn.hidden = true
        autoStackBtn.enabled = false
        autoStackBtn.hidden = true
        
        //Tele Items
        containerNoodleAddBtn.enabled = true
        containerNoodleAddBtn.hidden = false
        containerNoodleSubBtn.enabled = true
        containerNoodleSubBtn.hidden = false
        containerNoodleScoreLbl.enabled = true
        containerNoodleScoreLbl.hidden = false
        containerNoodleLbl.enabled = true
        containerNoodleLbl.hidden = false
        landfillNoodleLbl.enabled = true
        landfillNoodleLbl.hidden = false
        landfillNoodleScoreLbl.enabled = true
        landfillNoodleScoreLbl.hidden = false
        landfillNoodleAddBtn.enabled = true
        landfillNoodleAddBtn.hidden = false
        landfillNoodleSubBtn.enabled = true
        landfillNoodleSubBtn.hidden = false
        coopTotesLbl.enabled = true
        coopTotesLbl.hidden = false
        coopTotesScoreLbl.enabled = true
        coopTotesScoreLbl.hidden = false
        coopTotesAddBtn.enabled = true
        coopTotesAddBtn.hidden = false
        coopTotesSubBtn.enabled = true
        coopTotesSubBtn.hidden = false
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
        toteStackLbl.enabled = true
        toteStackLbl.hidden = false
        toteStackScoreLbl.enabled = true
        toteStackScoreLbl.hidden = false
        toteStackAddBtn.enabled = true
        toteStackAddBtn.hidden = false
        toteStackSubBtn.enabled = true
        toteStackSubBtn.hidden = false
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
        modeLbl.text = "Teleoperated Scoring Mode"
        autoShowing = false
    }
    
    //function to display all auto UI items and hide teleop UI
    func showAuto(){
        //Auto Items
        autoToteLbl.enabled = true
        autoToteLbl.hidden = false
        autoToteScoreLbl.enabled = true
        autoToteScoreLbl.hidden = false
        autoContainerScoreLbl.enabled = true
        autoContainerScoreLbl.hidden = false
        autoContainerLbl.enabled = true
        autoContainerLbl.hidden = false
        autoToteAddBtn.enabled = true
        autoToteAddBtn.hidden = false
        autoToteSubBtn.enabled = true
        autoToteSubBtn.hidden = false
        autoContainerAddBtn.enabled = true
        autoContainerAddBtn.hidden = false
        autoContainerSubBtn.enabled = true
        autoContainerSubBtn.hidden = false
        autoDriveBtn.enabled = true
        autoDriveBtn.hidden = false
        autoStackBtn.enabled = true
        autoStackBtn.hidden = false
        
        //Tele Items
        containerNoodleAddBtn.enabled = false
        containerNoodleAddBtn.hidden = true
        containerNoodleSubBtn.enabled = false
        containerNoodleSubBtn.hidden = true
        containerNoodleScoreLbl.enabled = false
        containerNoodleScoreLbl.hidden = true
        containerNoodleLbl.enabled = false
        containerNoodleLbl.hidden = true
        landfillNoodleLbl.enabled = false
        landfillNoodleLbl.hidden = true
        landfillNoodleScoreLbl.enabled = false
        landfillNoodleScoreLbl.hidden = true
        landfillNoodleAddBtn.enabled = false
        landfillNoodleAddBtn.hidden = true
        landfillNoodleSubBtn.enabled = false
        landfillNoodleSubBtn.hidden = true
        coopTotesLbl.enabled = false
        coopTotesLbl.hidden = true
        coopTotesScoreLbl.enabled = false
        coopTotesScoreLbl.hidden = true
        coopTotesAddBtn.enabled = false
        coopTotesAddBtn.hidden = true
        coopTotesSubBtn.enabled = false
        coopTotesSubBtn.hidden = true
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
        toteStackLbl.enabled = false
        toteStackLbl.hidden = true
        toteStackScoreLbl.enabled = false
        toteStackScoreLbl.hidden = true
        toteStackAddBtn.enabled = false
        toteStackAddBtn.hidden = true
        toteStackSubBtn.enabled = false
        toteStackSubBtn.hidden = true
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
        toteStacks = [ToteStack]()
        coopStacks = [CoopStack]()
        numAutoTotes = 0
        numAutoContainers = 0
        autoDrive = false
        autoStack = false
        
        //Auto Items
        autoDriveBtn.alpha = 0.5
        autoStackBtn.alpha = 0.5
        autoToteScoreLbl.text = "0"
        autoContainerScoreLbl.text = "0"
        
        //Tele Items
        resetToteStack()
        resetCoopStack()
        containerNoodleScoreLbl.text = "0"
        landfillNoodleScoreLbl.text = "0"
        coopTotesScoreLbl.text = "0"
        toteStackScoreLbl.text = "0"
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
            autoStackBtn.alpha = 1.0
        } else {
            autoStack = false
            autoStackBtn.alpha = 0.5
        }
    }
    
    //scores the auto bonus for ending in auto zone
    @IBAction func autoDriveBtnPress(sender: AnyObject) {
        if (autoDrive == false){
            autoDrive = true
            autoDriveBtn.alpha = 1.0
        } else {
            autoDrive = false
            autoDriveBtn.alpha = 0.5
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
    @IBAction func toteStackSubBtnPress(sender: AnyObject) {
        //check to make sure there is a toteStack scored
        if(toteStacks.count > 0){
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
    @IBAction func coopStackSubBtnPress(sender: AnyObject) {
        //subtract from number of used coop totes
        var newToteInStack = false
        for tote in coopStacks[coopStacks.count-1].totes {
            if (tote == true) {
                newToteInStack = true
                numCoopTotes--
            }
        }
        resetCoopStack()
        //check that is a stack to remove
        if(coopStacks.count > 0){
            coopStacks.removeLast()
            coopTotesScoreLbl.text = "\(coopStacks.count)"
        }
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
                    toteBtns[i].backgroundColor = UIColor.cyanColor()
                }
                else {
                    toteBtns[i].alpha = 1.0
                    toteBtns[i].backgroundColor = UIColor.darkGrayColor()
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
                toteBtns[i].backgroundColor = UIColor.cyanColor()
            }
            else {
                toteBtns[i].alpha = 1.0
                toteBtns[i].backgroundColor = UIColor.darkGrayColor()
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
    
    //resets the UI for the tote stack
    func resetToteStack(){
        for btn in toteBtns {
            btn.alpha = 0.5
            btn.backgroundColor = UIColor.darkGrayColor()
            btn.enabled = true
            btn.hidden = false
        }
        currentToteStack = ToteStack()
        toteInsertBtn.frame.origin.y = toteInsertBtnLocations[0]
        containerInsertBtn.hidden = true
        containerInsertBtn.enabled = false
        toteBtmInsertBtn.enabled = false
        toteBtmInsertBtn.hidden = true
        containerInsertBtn.frame.origin.y = containerInsertBtnLocations[0]
        containerInsertBtn.frame.origin.x = containerInsertBtnSide
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
    
    //resets the coop stack
    func resetCoopStack(){
        for btn in coopBtns {
            btn.alpha = 0.5
            btn.backgroundColor = UIColor.yellowColor()
            btn.enabled = true
            btn.hidden = false
        }
        currentCoopStack = CoopStack()
        coopToteInsertBtn.frame.origin.y = coopInsertBtnLocations[0]
        if(numCoopTotes < 3){
            coopToteInsertBtn.hidden = false
            coopToteInsertBtn.enabled = true
        }
        coopToteBtmInsertBtn.hidden = true
        coopToteBtmInsertBtn.enabled = false
    }
    
    //inserts a coop tote into the bottom of the stack
    @IBAction func coopBtmInsertBtnPress(sender: AnyObject) {
        insertCoopTote(true)
    }
    
    //switchs between auto and tele scorring mode
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
