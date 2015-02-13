//
//  Scoring.swift
//  2015 FRC Scout
//
//  Created by David Swed on 1/9/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit
import CoreData

class Scoring: UIViewController {

    var grayOutView : UIView!
    var signInView : UIView!
    
    let signInLayoutWidth : CGFloat = 120
    let signInLayoutHeight : CGFloat = 40
    let signInLayoutXDiff : CGFloat = 30
    let signInLayoutYDiff : CGFloat = 15
    
    //UI header Items
    @IBOutlet weak var scoutPosLbl: UILabel!
    @IBOutlet weak var matchNumberLbl: UITextField!
    @IBOutlet weak var teamNumberLbl: UITextField!
    @IBOutlet weak var modeLbl: UILabel!
    
    //Auto UI Items
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
    @IBOutlet weak var penaltyLbl: UILabel!
    @IBOutlet weak var penaltyValLbl: UILabel!
    @IBOutlet weak var penaltyAddBtn: UIButton!
    @IBOutlet weak var penaltySubBtn: UIButton!
    
    
    @IBOutlet weak var finishMatchBtn: UIButton!
    
    //array of the buttons in the tote stack UI. Initialized in ViewDidLoad()
    var toteBtns = [UIButton]()
    //array of the buttons in the coop tote stack UI. Initialized in ViewDidLoad()
    var coopBtns = [UIButton]()
    //positions that the top tote insert button moves to
    var toteInsertBtnLocations: [CGFloat] = [707,637,567,497,427,357]
    //positions that the container insert button moves to
    var containerInsertBtnLocations: [CGFloat] = [0,634,564,494,424,354,284]
    //positions that the coop Tote insert button moves to
    var coopInsertBtnLocations: [CGFloat] = [522,452,382,312]
    //x position of the container insert button when it's to the left of the tote stack
    var containerInsertBtnSide: CGFloat = 27
    //x postion of the container insert button when it's in the center of the tote stack
    var containerInsertBtnCenter: CGFloat = 173
    
    
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
    
    //Variable stores if Autonomous mode is showing. false if in teleop mode
    var autoShowing = true
    //recognizes if the user has swiped to change between modes
    var swipeGesture = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Auto UI items
        autoToteAddBtn.layer.cornerRadius = 5
        autoToteSubBtn.layer.cornerRadius = 5
        autoContainerAddBtn.layer.cornerRadius = 5
        autoContainerSubBtn.layer.cornerRadius = 5
        autoStackBtn.layer.cornerRadius = 5
        
        //Teleop UI Items
        containerNoodleAddBtn.layer.cornerRadius = 5
        containerNoodleSubBtn.layer.cornerRadius = 5
        landfillNoodleAddBtn.layer.cornerRadius = 5
        landfillNoodleSubBtn.layer.cornerRadius = 5
        coopTotesAddBtn.layer.cornerRadius = 5
        coopTotesUndoBtn.layer.cornerRadius = 5
        stackKilledBtn.layer.cornerRadius = 5
        toteStackAddBtn.layer.cornerRadius = 5
        toteStackUndoBtn.layer.cornerRadius = 5
        
        finishMatchBtn.layer.cornerRadius = 5
        
        toteBtns = [tote1,tote2,tote3,tote4,tote5,tote6]
        coopBtns = [coopTote1,coopTote2,coopTote3,coopTote4]
        
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
        
//        self.showSignInView()
    }
    
    func showSignInView() {
        grayOutView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        grayOutView.backgroundColor = UIColor(white: 0.6, alpha: 0.6)
        self.view.addSubview(grayOutView)
        
        let tapDismiss = UITapGestureRecognizer(target: self, action: Selector("screenTapped:"))
        self.view.addGestureRecognizer(tapDismiss)
        
        signInView = UIView(frame: CGRect(x: 94, y: 130, width: 580, height: 660))
        signInView.backgroundColor = .whiteColor()
        signInView.layer.cornerRadius = 10
        self.view.addSubview(signInView)
        self.view.bringSubviewToFront(signInView)
        
        let signInTitleLbl = UILabel(frame: CGRect(x: signInView.frame.width/2 - 50, y: 20, width: 100, height: 28))
        signInTitleLbl.textAlignment = .Center
        signInTitleLbl.text = "Sign In"
        signInTitleLbl.font = UIFont.boldSystemFontOfSize(25)
        signInView.addSubview(signInTitleLbl)
        
        let red1Button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        red1Button.frame = CGRect(x: 80, y: signInTitleLbl.frame.origin.y + signInTitleLbl.frame.height + 20, width: signInLayoutWidth, height: signInLayoutHeight)
        red1Button.layer.cornerRadius = 5
        red1Button.layer.borderColor = UIColor.redColor().CGColor
        red1Button.layer.borderWidth = 2
        red1Button.backgroundColor = .whiteColor()
        red1Button.setTitle("Red 1", forState: UIControlState.Normal)
        red1Button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        signInView.addSubview(red1Button)
        
        let red2Button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        red2Button.frame = CGRect(x: red1Button.frame.origin.x + red1Button.frame.width + signInLayoutXDiff, y: red1Button.frame.origin.y, width: signInLayoutWidth, height: signInLayoutHeight)
        red2Button.layer.cornerRadius = 5
        red2Button.layer.borderColor = UIColor.redColor().CGColor
        red2Button.layer.borderWidth = 2
        red2Button.backgroundColor = .whiteColor()
        red2Button.setTitle("Red 2", forState: UIControlState.Normal)
        red2Button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        signInView.addSubview(red2Button)
        
        let red3Button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        red3Button.frame = CGRect(x: red2Button.frame.origin.x + red2Button.frame.width + signInLayoutXDiff, y: red1Button.frame.origin.y, width: signInLayoutWidth, height: signInLayoutHeight)
        red3Button.layer.cornerRadius = 5
        red3Button.layer.borderColor = UIColor.redColor().CGColor
        red3Button.layer.borderWidth = 2
        red3Button.backgroundColor = .whiteColor()
        red3Button.setTitle("Red 3", forState: UIControlState.Normal)
        red3Button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        signInView.addSubview(red3Button)
        
        let blue1Button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        blue1Button.frame = CGRect(x: red1Button.frame.origin.x, y: red1Button.frame.origin.y + red1Button.frame.height + signInLayoutYDiff, width: signInLayoutWidth, height: signInLayoutHeight)
        blue1Button.layer.cornerRadius = 5
        blue1Button.layer.borderColor = UIColor.blueColor().CGColor
        blue1Button.layer.borderWidth = 2
        blue1Button.backgroundColor = .whiteColor()
        blue1Button.setTitle("Blue 1", forState: UIControlState.Normal)
        blue1Button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        signInView.addSubview(blue1Button)
        
        let blue2Button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        blue2Button.frame = CGRect(x: blue1Button.frame.origin.x + blue1Button.frame.width + signInLayoutXDiff, y: blue1Button.frame.origin.y, width: signInLayoutWidth, height: signInLayoutHeight)
        blue2Button.layer.cornerRadius = 5
        blue2Button.layer.borderColor = UIColor.blueColor().CGColor
        blue2Button.layer.borderWidth = 2
        blue2Button.backgroundColor = .whiteColor()
        blue2Button.setTitle("Blue 2", forState: UIControlState.Normal)
        blue2Button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        signInView.addSubview(blue2Button)
        
        let blue3Button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        blue3Button.frame = CGRect(x: blue2Button.frame.origin.x + blue2Button.frame.width + signInLayoutXDiff, y: blue1Button.frame.origin.y, width: signInLayoutWidth, height: signInLayoutHeight)
        blue3Button.layer.cornerRadius = 5
        blue3Button.layer.borderColor = UIColor.blueColor().CGColor
        blue3Button.layer.borderWidth = 2
        blue3Button.backgroundColor = .whiteColor()
        blue3Button.setTitle("Blue 3", forState: UIControlState.Normal)
        blue3Button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        signInView.addSubview(blue3Button)
        
        let initialsTF = UITextField(frame: CGRect(x: 80, y: blue1Button.frame.origin.y + blue1Button.frame.height + 50, width: signInLayoutWidth + 10, height: 35))
        initialsTF.font = UIFont.systemFontOfSize(15)
        initialsTF.textAlignment = .Center
        initialsTF.placeholder = "3 Initials"
        initialsTF.borderStyle = .RoundedRect
        initialsTF.returnKeyType = .Next
        signInView.addSubview(initialsTF)
        let initialsLbl = UILabel(frame: CGRect(x: initialsTF.frame.origin.x, y: initialsTF.frame.origin.y - 16, width: initialsTF.frame.width, height: 15))
        initialsLbl.font = UIFont.systemFontOfSize(14)
        initialsLbl.text = "YOUR 3 Initials"
        initialsLbl.textAlignment = .Center
        initialsLbl.adjustsFontSizeToFitWidth = true
        signInView.addSubview(initialsLbl)
        
        let teamNumTF = UITextField(frame: CGRect(x: initialsTF.frame.origin.x + initialsTF.frame.width + signInLayoutXDiff - 10, y: initialsTF.frame.origin.y, width: signInLayoutWidth, height: 35))
        teamNumTF.font = UIFont.systemFontOfSize(15)
        teamNumTF.textAlignment = .Center
        teamNumTF.placeholder = "Your Team #"
        teamNumTF.borderStyle = .RoundedRect
        teamNumTF.keyboardType = .NumberPad
        teamNumTF.returnKeyType = .Next
        signInView.addSubview(teamNumTF)
        let teamNumLbl = UILabel(frame: CGRect(x: teamNumTF.frame.origin.x, y: teamNumTF.frame.origin.y - 16, width: teamNumTF.frame.width, height: 15))
        teamNumLbl.font = UIFont.systemFontOfSize(14)
        teamNumLbl.text = "YOUR Team #"
        teamNumLbl.textAlignment = .Center
        teamNumLbl.adjustsFontSizeToFitWidth = true
        signInView.addSubview(teamNumLbl)
        
        let matchNumTF = UITextField(frame: CGRect(x: teamNumTF.frame.origin.x + teamNumTF.frame.width + signInLayoutXDiff - 10, y: initialsTF.frame.origin.y, width: signInLayoutWidth + 10, height: 35))
        matchNumTF.font = UIFont.systemFontOfSize(15)
        matchNumTF.textAlignment = .Center
        matchNumTF.placeholder = "Current Match #"
        matchNumTF.borderStyle = .RoundedRect
        matchNumTF.keyboardType = .NumberPad
        matchNumTF.returnKeyType = .Done
        signInView.addSubview(matchNumTF)
        let matchNumLbl = UILabel(frame: CGRect(x: matchNumTF.frame.origin.x, y: matchNumTF.frame.origin.y - 16, width: matchNumTF.frame.width, height: 15))
        matchNumLbl.font = UIFont.systemFontOfSize(14)
        matchNumLbl.text = "Current Match #"
        matchNumLbl.textAlignment = .Center
        matchNumLbl.adjustsFontSizeToFitWidth = true
        signInView.addSubview(matchNumLbl)
    }
    
    func screenTapped(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //function to display all teleop UI items and hide auto UI
    func showTeleop(){
        //Auto Items
        autoToteAddBtn.enabled = false
        autoToteSubBtn.enabled = false
        autoContainerAddBtn.enabled = false
        autoContainerSubBtn.enabled = false
        autoZoneRobot.userInteractionEnabled = false
        autoStackBtn.enabled = false
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.autoToteLbl.alpha = 0.0
            self.autoToteScoreLbl.alpha = 0.0
            self.autoContainerScoreLbl.alpha = 0.0
            self.autoContainerLbl.alpha = 0.0
            self.autoToteAddBtn.alpha = 0.0
            self.autoToteSubBtn.alpha = 0.0
            self.autoContainerAddBtn.alpha = 0.0
            self.autoContainerSubBtn.alpha = 0.0
            self.autoZoneLbl.alpha = 0.0
            self.autoZoneLine.alpha = 0.0
            self.autoZoneRobot.alpha = 0.0
            self.autoStackBtn.alpha = 0.0
        }) { (completed) -> Void in
            self.containerNoodleAddBtn.enabled = true
            self.containerNoodleSubBtn.enabled = true
            self.landfillNoodleAddBtn.enabled = true
            self.landfillNoodleSubBtn.enabled = true
            self.coopTotesAddBtn.enabled = true
            self.coopTotesUndoBtn.enabled = true
            self.coopTote1.enabled = true
            self.coopTote2.enabled = true
            self.coopTote3.enabled = true
            self.coopTote4.enabled = true
            self.coopToteInsertBtn.enabled = true
            self.coopToteBtmInsertBtn.enabled = false
            self.toteStackAddBtn.enabled = true
            self.toteStackUndoBtn.enabled = true
            self.tote1.enabled = true
            self.tote2.enabled = true
            self.tote3.enabled = true
            self.tote4.enabled = true
            self.tote5.enabled = true
            self.tote6.enabled = true
            self.toteInsertBtn.enabled = true
            self.toteBtmInsertBtn.enabled = false
            self.containerInsertBtn.enabled = false
            self.stackKilledBtn.enabled = true
            self.penaltyAddBtn.enabled = true
            self.penaltySubBtn.enabled = true
            
            self.modeLbl.text = "Teleoperated Scoring Mode"
            self.autoShowing = false
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.containerNoodleAddBtn.alpha = 1.0
                self.containerNoodleSubBtn.alpha = 1.0
                self.containerNoodleScoreLbl.alpha = 1.0
                self.containerNoodleLbl.alpha = 1.0
                self.landfillNoodleLbl.alpha = 1.0
                self.landfillNoodleScoreLbl.alpha = 1.0
                self.landfillNoodleAddBtn.alpha = 1.0
                self.landfillNoodleSubBtn.alpha = 1.0
                self.coopTotesLbl.alpha = 1.0
                self.coopTotesScoreLbl.alpha = 1.0
                self.coopTotesAddBtn.alpha = 1.0
                self.coopTotesUndoBtn.alpha = 1.0
                self.coopTote1.alpha = 1.0
                self.coopTote2.alpha = 1.0
                self.coopTote3.alpha = 1.0
                self.coopTote4.alpha = 1.0
                self.coopToteInsertBtn.alpha = 1.0
                self.coopToteBtmInsertBtn.alpha = 1.0
                self.toteStackLbl.alpha = 1.0
                self.toteStackScoreLbl.alpha = 1.0
                self.toteStackAddBtn.alpha = 1.0
                self.toteStackUndoBtn.alpha = 1.0
                self.tote1.alpha = 1.0
                self.tote2.alpha = 1.0
                self.tote3.alpha = 1.0
                self.tote4.alpha = 1.0
                self.tote5.alpha = 1.0
                self.tote6.alpha = 1.0
                self.toteInsertBtn.alpha = 1.0
                self.toteBtmInsertBtn.alpha = 1.0
                self.containerInsertBtn.alpha = 1.0
                self.stackKilledBtn.alpha = 1.0
                self.penaltyLbl.alpha = 1.0
                self.penaltyValLbl.alpha = 1.0
                self.penaltyAddBtn.alpha = 1.0
                self.penaltySubBtn.alpha = 1.0
            })
        }
        
        
    }
    
    //function to display all auto UI items and hide teleop UI
    func showAuto(){
        //Tele Items
        self.containerNoodleAddBtn.enabled = false
        self.containerNoodleSubBtn.enabled = false
        self.landfillNoodleAddBtn.enabled = false
        self.landfillNoodleSubBtn.enabled = false
        self.coopTotesAddBtn.enabled = false
        self.coopTotesUndoBtn.enabled = false
        self.coopTote1.enabled = false
        self.coopTote2.enabled = false
        self.coopTote3.enabled = false
        self.coopTote4.enabled = false
        self.coopToteInsertBtn.enabled = false
        self.coopToteBtmInsertBtn.enabled = false
        self.toteStackAddBtn.enabled = false
        self.toteStackUndoBtn.enabled = false
        self.tote1.enabled = false
        self.tote2.enabled = false
        self.tote3.enabled = false
        self.tote4.enabled = false
        self.tote5.enabled = false
        self.tote6.enabled = false
        self.toteInsertBtn.enabled = false
        self.toteBtmInsertBtn.enabled = false
        self.containerInsertBtn.enabled = false
        self.stackKilledBtn.enabled = false
        self.penaltyAddBtn.enabled = false
        self.penaltySubBtn.enabled = false
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.containerNoodleAddBtn.alpha = 0.0
            self.containerNoodleSubBtn.alpha = 0.0
            self.containerNoodleScoreLbl.alpha = 0.0
            self.containerNoodleLbl.alpha = 0.0
            self.landfillNoodleLbl.alpha = 0.0
            self.landfillNoodleScoreLbl.alpha = 0.0
            self.landfillNoodleAddBtn.alpha = 0.0
            self.landfillNoodleSubBtn.alpha = 0.0
            self.coopTotesLbl.alpha = 0.0
            self.coopTotesScoreLbl.alpha = 0.0
            self.coopTotesAddBtn.alpha = 0.0
            self.coopTotesUndoBtn.alpha = 0.0
            self.coopTote1.alpha = 0.0
            self.coopTote2.alpha = 0.0
            self.coopTote3.alpha = 0.0
            self.coopTote4.alpha = 0.0
            self.coopToteInsertBtn.alpha = 0.0
            self.coopToteBtmInsertBtn.alpha = 0.0
            self.toteStackLbl.alpha = 0.0
            self.toteStackScoreLbl.alpha = 0.0
            self.toteStackAddBtn.alpha = 0.0
            self.toteStackUndoBtn.alpha = 0.0
            self.tote1.alpha = 0.0
            self.tote2.alpha = 0.0
            self.tote3.alpha = 0.0
            self.tote4.alpha = 0.0
            self.tote5.alpha = 0.0
            self.tote6.alpha = 0.0
            self.toteInsertBtn.alpha = 0.0
            self.toteBtmInsertBtn.alpha = 0.0
            self.containerInsertBtn.alpha = 0.0
            self.stackKilledBtn.alpha = 0.0
            self.penaltyLbl.alpha = 0.0
            self.penaltyValLbl.alpha = 0.0
            self.penaltyAddBtn.alpha = 0.0
            self.penaltySubBtn.alpha = 0.0
            }, completion: { (completed) -> Void in
                self.autoToteAddBtn.enabled = true
                self.autoToteSubBtn.enabled = true
                self.autoContainerAddBtn.enabled = true
                self.autoContainerSubBtn.enabled = true
                self.autoZoneRobot.userInteractionEnabled = true
                self.autoStackBtn.enabled = true
                
                self.modeLbl.text = "Autonomous Scoring Mode"
                self.autoShowing = true
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    //Auto Items
                    self.autoToteLbl.alpha = 1.0
                    self.autoToteScoreLbl.alpha = 1.0
                    self.autoContainerScoreLbl.alpha = 1.0
                    self.autoContainerLbl.alpha = 1.0
                    self.autoToteAddBtn.alpha = 1.0
                    self.autoToteSubBtn.alpha = 1.0
                    self.autoContainerAddBtn.alpha = 1.0
                    self.autoContainerSubBtn.alpha = 1.0
                    self.autoZoneLbl.alpha = 1.0
                    self.autoZoneLine.alpha = 1.0
                    self.autoZoneRobot.alpha = 1.0
                    self.autoStackBtn.alpha = 1.0
                })
        })
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
        containerInsertBtn.frame = CGRect(x: containerInsertBtn.frame.origin.x, y: containerInsertBtn.frame.origin.y, width: 86, height: 44)
        containerInsertBtn.setBackgroundImage(UIImage(named: "ContainerArrow"), forState: .Normal)
        containerInsertBtn.setTitle("Container", forState: .Normal)
        containerInsertBtn.frame.origin.y = containerInsertBtnLocations[0]
        containerInsertBtn.frame.origin.x = containerInsertBtnSide
    }
    
    //resets the coop stack
    func resetCoopStack(){
        for btn in coopBtns {
            btn.setBackgroundImage(UIImage(named: "ToteYellowOutline"), forState: .Normal)
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
        if currentToteStack.containerLvl > 0 {
            containerInsertBtn.frame.origin.y -= 35
        }
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
        if currentToteStack.containerLvl == 0 {
            containerInsertBtn.frame = CGRect(x: containerInsertBtn.frame.origin.x, y: containerInsertBtn.frame.origin.y - 35, width: 80, height: 80)
            containerInsertBtn.center.x = containerInsertBtnCenter
            containerInsertBtn.setBackgroundImage(UIImage(named: "Container"), forState: .Normal)
            containerInsertBtn.setTitle("", forState: .Normal)
            currentToteStack.containerLvl = currentToteStack.totes.count
            for (var i = 5; i >= currentToteStack.totes.count; i -= 1 ){
                toteBtns[i].hidden = true
                toteBtns[i].enabled = false
            }
        }
    }
    
    //adds to number of stacks knocked over
    @IBAction func knockStackBtnPress(sender: AnyObject) {
        numStacksKnockedOver++
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
                coopBtns[i].setBackgroundImage(UIImage(named: "ToteYellowGray"), forState: .Normal)
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
    
    //inserts a coop tote into the bottom of the stack
    @IBAction func coopBtmInsertBtnPress(sender: AnyObject) {
        insertCoopTote(true)
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
                coopBtns[i].setBackgroundImage(UIImage(named: "ToteYellowGray"), forState: .Normal)
            }
            else {
                coopBtns[i].alpha = 1.0
                coopBtns[i].setBackgroundImage(UIImage(named: "ToteYellow"), forState: .Normal)
            }
        }
    }
    
    //adds to number of penalties in match
    @IBAction func penaltyAddBtnPress(sender: AnyObject) {
        numPenalties++
        penaltyValLbl.text = "\(numPenalties)"
    }
    
    @IBAction func penaltySubBtnPress(sender: AnyObject) {
        if numPenalties > 0 {
            numPenalties--
            penaltyValLbl.text = "\(numPenalties)"
        }
    }
    
    //Saves match data
    @IBAction func saveMatchButtonPress(sender: AnyObject) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
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
        
        
        
        
        context.save(nil)
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
