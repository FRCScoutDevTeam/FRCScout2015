//
//  Scoring.swift
//  2015 FRC Scout
//
//  Created by David Swed on 1/9/15.
//  Copyright (c) 2015 David Swed. All rights reserved
//

import UIKit
import CoreData
import MultipeerConnectivity

class Scoring: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate {

    //Sign In View Items
    var grayOutView : UIView!
    var signInView = UIView()
    var initialsTF : UITextField!
    var teamNumTF : UITextField!
    var matchNumTF : UITextField!
    var regionalPicker : UIPickerView!
    var weekSelector : UISegmentedControl!

    let signInLayoutWidth : CGFloat = 120
    let signInLayoutHeight : CGFloat = 40
    let signInLayoutXDiff : CGFloat = 30
    let signInLayoutYDiff : CGFloat = 15
    var scoutPositionBtns = Array<UIButton>()
    var weekSelected : Int!

    //UI header Items
    @IBOutlet weak var instaShareBtn: UIButton!
    @IBOutlet weak var scoutPosLbl: UILabel!
    @IBOutlet weak var matchNumHeaderLbl: UILabel!
    @IBOutlet weak var matchNumberCoverBtn: UIButton!
    @IBOutlet weak var matchNumberTF: UITextField!
    @IBOutlet weak var matchNumTapToEditLbl: UILabel!
    @IBOutlet weak var teamNumHeaderLbl: UILabel!
    @IBOutlet weak var teamNumberCoverBtn: UIButton!
    @IBOutlet weak var teamNumberTF: UITextField!
    @IBOutlet weak var teamNumTapToEditLbl: UILabel!
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
    @IBOutlet weak var toppleStackBtn: UIButton!
    @IBOutlet weak var toppleLbl: UILabel!
    @IBOutlet weak var toppleUndoBtn: UIButton!
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
    
    var postMatchNotesView : UIView!
    var postMatchNotesTextView : UITextView!
    var tempNotes : String?

    @IBOutlet weak var finishMatchBtn: UIButton!

    //array of the buttons in the tote stack UI. Initialized in ViewDidLoad()
    var toteBtns = [UIButton]()
    //array of the buttons in the coop tote stack UI. Initialized in ViewDidLoad()
    var coopBtns = [UIButton]()
    //positions that the top tote insert button moves to
    var toteInsertBtnLocations: [CGFloat] = [722,652,582,512,442,372]
    //positions that the container insert button moves to
    var containerInsertBtnLocations: [CGFloat] = [0,648,578,508,438,368,298]
    //positions that the coop Tote insert button moves to
    var coopInsertBtnLocations: [CGFloat] = [539,469,399,329]
    //x position of the container insert button when it's to the left of the tote stack
    var containerInsertBtnSide: CGFloat = 27
    //x postion of the container insert button when it's in the center of the tote stack
    var containerInsertBtnCenter: CGFloat = 173

    var confirmedSwipe : Bool!

    //Score Variables
    struct ToteStackStruct {
        var totes = [Bool]()
        var containerLvl = 0
    }

    struct CoopStackStruct {
        var totes = [Bool]()
    }

    var scoutPosition : Int!
    var scoutInitials : String!
    var scoutTeamNum : Int!
    var regionalName : String!
    var matchNum : String!
    var teamNum : Int!
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

    //toteStack control variables
    var bottomToteStacking = false
    var topToteStacking = false
    var bottomCoopStacking = false
    var topCoopStacking = false

    override func viewDidLoad() {
        super.viewDidLoad()

        grayOutView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        grayOutView.backgroundColor = UIColor(white: 0.6, alpha: 0.6)

        let tapDismiss = UITapGestureRecognizer(target: self, action: Selector("screenTapped:"))
        self.view.addGestureRecognizer(tapDismiss)

        //Header UI Items
        instaShareBtn.layer.cornerRadius = 5
        instaShareBtn.enabled = false
        instaShareBtn.alpha = 0
        scoutPosLbl.layer.cornerRadius = 5
        scoutPosLbl.clipsToBounds = true
        scoutPosLbl.alpha = 0
        matchNumHeaderLbl.alpha = 0
        matchNumberCoverBtn.alpha = 0
        matchNumberCoverBtn.enabled = false
        matchNumberTF.alpha = 0
        matchNumberTF.enabled = false
        matchNumTapToEditLbl.alpha = 0
        teamNumHeaderLbl.alpha = 0
        teamNumberCoverBtn.alpha = 0
        teamNumberCoverBtn.enabled = false
        teamNumberTF.alpha = 0
        teamNumberTF.enabled = false
        teamNumTapToEditLbl.alpha = 0

        //Auto UI Items
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
        toppleStackBtn.layer.cornerRadius = 5
        toppleUndoBtn.layer.cornerRadius = 5
        toteStackAddBtn.layer.cornerRadius = 5
        toteStackUndoBtn.layer.cornerRadius = 5

        finishMatchBtn.layer.cornerRadius = 5

        toteBtns = [tote1,tote2,tote3,tote4,tote5,tote6]
        coopBtns = [coopTote1,coopTote2,coopTote3,coopTote4]

        resetScoringScreen(false)
        self.view.userInteractionEnabled = true
        self.view.multipleTouchEnabled = true
        swipeGesture.addTarget(self, action: "twoFingerPanDetected:")
        swipeGesture.minimumNumberOfTouches = 2
        self.view.addGestureRecognizer(swipeGesture)

        var robotDrag = UIPanGestureRecognizer(target: self, action: "robotDrag:")
        robotDrag.maximumNumberOfTouches = 1
        robotDrag.minimumNumberOfTouches = 1
        autoZoneRobot.addGestureRecognizer(robotDrag)

        if let swipeConfirm : Bool = NSUserDefaults.standardUserDefaults().objectForKey(SWIPECONFIRMKEY) as? Bool {
            confirmedSwipe = swipeConfirm
        } else {
            confirmedSwipe = false
        }

        weekSelected = NSUserDefaults.standardUserDefaults().integerForKey(WEEKSELECTEDKEY) ?? 0
        regionalPicker = UIPickerView()
        regionalPicker.delegate = self
        regionalPicker.dataSource = self
        
        setUpConnectionUI()
    }

    override func viewDidAppear(animated: Bool) {
        if scoutPosition == nil && !signInView.isDescendantOfView(self.view) {
            self.showSignInView()
        }
    }

    //Shows the Sign In View (should only be called if the scout is not signed in)
    func showSignInView() {
        self.view.addSubview(grayOutView)

        signInView = UIView(frame: CGRect(x: 94, y: 130, width: 580, height: 630))
        signInView.backgroundColor = .whiteColor()
        signInView.layer.cornerRadius = 10
        signInView.transform = CGAffineTransformMakeScale(0.01, 0.01)
        self.view.addSubview(signInView)
        self.view.bringSubviewToFront(signInView)

        let signInTitleLbl = UILabel(frame: CGRect(x: 240, y: 20, width: 100, height: 28))
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
        red1Button.addTarget(self, action: Selector("positionBtnPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        signInView.addSubview(red1Button)
        if !contains(scoutPositionBtns, red1Button){
            scoutPositionBtns.insert(red1Button, atIndex: 0)
        }

        let red2Button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        red2Button.frame = CGRect(x: red1Button.frame.origin.x + red1Button.frame.width + signInLayoutXDiff, y: red1Button.frame.origin.y, width: signInLayoutWidth, height: signInLayoutHeight)
        red2Button.layer.cornerRadius = 5
        red2Button.layer.borderColor = UIColor.redColor().CGColor
        red2Button.layer.borderWidth = 2
        red2Button.backgroundColor = .whiteColor()
        red2Button.setTitle("Red 2", forState: UIControlState.Normal)
        red2Button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        red2Button.addTarget(self, action: Selector("positionBtnPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        signInView.addSubview(red2Button)
        if !contains(scoutPositionBtns, red2Button){
            scoutPositionBtns.insert(red2Button, atIndex: 1)
        }

        let red3Button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        red3Button.frame = CGRect(x: red2Button.frame.origin.x + red2Button.frame.width + signInLayoutXDiff, y: red1Button.frame.origin.y, width: signInLayoutWidth, height: signInLayoutHeight)
        red3Button.layer.cornerRadius = 5
        red3Button.layer.borderColor = UIColor.redColor().CGColor
        red3Button.layer.borderWidth = 2
        red3Button.backgroundColor = .whiteColor()
        red3Button.setTitle("Red 3", forState: UIControlState.Normal)
        red3Button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        red3Button.addTarget(self, action: Selector("positionBtnPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        signInView.addSubview(red3Button)
        if !contains(scoutPositionBtns, red3Button){
            scoutPositionBtns.insert(red3Button, atIndex: 2)
        }

        let blue1Button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        blue1Button.frame = CGRect(x: red1Button.frame.origin.x, y: red1Button.frame.origin.y + red1Button.frame.height + signInLayoutYDiff, width: signInLayoutWidth, height: signInLayoutHeight)
        blue1Button.layer.cornerRadius = 5
        blue1Button.layer.borderColor = UIColor.blueColor().CGColor
        blue1Button.layer.borderWidth = 2
        blue1Button.backgroundColor = .whiteColor()
        blue1Button.setTitle("Blue 1", forState: UIControlState.Normal)
        blue1Button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        blue1Button.addTarget(self, action: Selector("positionBtnPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        signInView.addSubview(blue1Button)
        if !contains(scoutPositionBtns, blue1Button){
            scoutPositionBtns.insert(blue1Button, atIndex: 3)
        }

        let blue2Button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        blue2Button.frame = CGRect(x: blue1Button.frame.origin.x + blue1Button.frame.width + signInLayoutXDiff, y: blue1Button.frame.origin.y, width: signInLayoutWidth, height: signInLayoutHeight)
        blue2Button.layer.cornerRadius = 5
        blue2Button.layer.borderColor = UIColor.blueColor().CGColor
        blue2Button.layer.borderWidth = 2
        blue2Button.backgroundColor = .whiteColor()
        blue2Button.setTitle("Blue 2", forState: UIControlState.Normal)
        blue2Button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        blue2Button.addTarget(self, action: Selector("positionBtnPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        signInView.addSubview(blue2Button)
        if !contains(scoutPositionBtns, blue2Button){
            scoutPositionBtns.insert(blue2Button, atIndex: 4)
        }

        let blue3Button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        blue3Button.frame = CGRect(x: blue2Button.frame.origin.x + blue2Button.frame.width + signInLayoutXDiff, y: blue1Button.frame.origin.y, width: signInLayoutWidth, height: signInLayoutHeight)
        blue3Button.layer.cornerRadius = 5
        blue3Button.layer.borderColor = UIColor.blueColor().CGColor
        blue3Button.layer.borderWidth = 2
        blue3Button.backgroundColor = .whiteColor()
        blue3Button.setTitle("Blue 3", forState: UIControlState.Normal)
        blue3Button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        blue3Button.addTarget(self, action: Selector("positionBtnPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        signInView.addSubview(blue3Button)
        if !contains(scoutPositionBtns, blue3Button){
            scoutPositionBtns.insert(blue3Button, atIndex: 5)
        }

        initialsTF = UITextField(frame: CGRect(x: 80, y: blue1Button.frame.origin.y + blue1Button.frame.height + 50, width: signInLayoutWidth + 10, height: 35))
        initialsTF.font = UIFont.systemFontOfSize(15)
        initialsTF.textAlignment = .Center
        initialsTF.placeholder = "3 Initials"
        initialsTF.borderStyle = .RoundedRect
        initialsTF.autocorrectionType = .No
        initialsTF.autocapitalizationType = .AllCharacters
        initialsTF.returnKeyType = .Next
        initialsTF.addTarget(self, action: Selector("initialsTFReturnPressed:"), forControlEvents: UIControlEvents.EditingDidEndOnExit)
        signInView.addSubview(initialsTF)
        let initialsLbl = UILabel(frame: CGRect(x: initialsTF.frame.origin.x, y: initialsTF.frame.origin.y - 16, width: initialsTF.frame.width, height: 15))
        initialsLbl.font = UIFont.systemFontOfSize(14)
        initialsLbl.text = "YOUR 3 Initials"
        initialsLbl.textAlignment = .Center
        initialsLbl.adjustsFontSizeToFitWidth = true
        signInView.addSubview(initialsLbl)

        teamNumTF = UITextField(frame: CGRect(x: initialsTF.frame.origin.x + initialsTF.frame.width + signInLayoutXDiff - 10, y: initialsTF.frame.origin.y, width: signInLayoutWidth, height: 35))
        teamNumTF.font = UIFont.systemFontOfSize(15)
        teamNumTF.textAlignment = .Center
        teamNumTF.placeholder = "Your Team #"
        teamNumTF.borderStyle = .RoundedRect
        teamNumTF.keyboardType = .NumberPad
        teamNumTF.returnKeyType = .Next
        teamNumTF.addTarget(self, action: Selector("teamNumTFReturnPressed:"), forControlEvents: UIControlEvents.EditingDidEndOnExit)
        signInView.addSubview(teamNumTF)
        let teamNumLbl = UILabel(frame: CGRect(x: teamNumTF.frame.origin.x, y: teamNumTF.frame.origin.y - 16, width: teamNumTF.frame.width, height: 15))
        teamNumLbl.font = UIFont.systemFontOfSize(14)
        teamNumLbl.text = "YOUR Team #"
        teamNumLbl.textAlignment = .Center
        teamNumLbl.adjustsFontSizeToFitWidth = true
        signInView.addSubview(teamNumLbl)

        matchNumTF = UITextField(frame: CGRect(x: teamNumTF.frame.origin.x + teamNumTF.frame.width + signInLayoutXDiff - 10, y: initialsTF.frame.origin.y, width: signInLayoutWidth + 10, height: 35))
        matchNumTF.font = UIFont.systemFontOfSize(15)
        matchNumTF.textAlignment = .Center
        matchNumTF.placeholder = "Current Match #"
        matchNumTF.borderStyle = .RoundedRect
        matchNumTF.keyboardType = .NumberPad
        matchNumTF.returnKeyType = .Done
        matchNumTF.addTarget(self, action: Selector("matchNumTFReturnPressed:"), forControlEvents: UIControlEvents.EditingDidEndOnExit)
        signInView.addSubview(matchNumTF)
        let matchNumLbl = UILabel(frame: CGRect(x: matchNumTF.frame.origin.x, y: matchNumTF.frame.origin.y - 16, width: matchNumTF.frame.width, height: 15))
        matchNumLbl.font = UIFont.systemFontOfSize(14)
        matchNumLbl.text = "Current Match #"
        matchNumLbl.textAlignment = .Center
        matchNumLbl.adjustsFontSizeToFitWidth = true
        signInView.addSubview(matchNumLbl)

        weekSelector = UISegmentedControl(items: ["All", "1", "2", "3", "4", "5", "6", "7+"])
        weekSelector.frame = CGRect(x: -42, y: 397, width: 216, height: 30)
        weekSelector.addTarget(self, action: Selector("weekSelectorChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        signInView.addSubview(weekSelector)
        weekSelector.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2.0))
        for view in weekSelector.subviews {
            for subview in view.subviews {
                if let label = subview as? UILabel {
                    label.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2.0))
                }
            }
        }
        if let selectedWeek = NSUserDefaults.standardUserDefaults().objectForKey(WEEKSELECTEDKEY) as? Int {
            weekSelector.selectedSegmentIndex = selectedWeek
            weekSelected = selectedWeek
        } else {
            weekSelector.selectedSegmentIndex = 0
            weekSelected = 0
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: WEEKSELECTEDKEY)
        }
        let weekSelectorLbl = UILabel(frame: CGRect(x: initialsTF.frame.origin.x - 32, y: initialsTF.frame.origin.y + initialsTF.frame.height + signInLayoutYDiff + 20, width: 36, height: 18))
        weekSelectorLbl.font = UIFont.systemFontOfSize(15)
        weekSelectorLbl.textAlignment = .Center
        weekSelectorLbl.text = "Week"
        weekSelectorLbl.adjustsFontSizeToFitWidth = true
        signInView.addSubview(weekSelectorLbl)

        regionalPicker.frame = CGRect(x: initialsTF.frame.origin.x + 20, y: initialsTF.frame.origin.y + initialsTF.frame.height + signInLayoutYDiff + 40, width: 420, height: 216)
        regionalPicker.showsSelectionIndicator = true
        regionalPicker.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        regionalPicker.layer.cornerRadius = 5
        signInView.addSubview(regionalPicker)
        if let regName = NSUserDefaults.standardUserDefaults().objectForKey(REGIONALSELECTEDKEY) as? String {
            regionalPicker.selectRow(find(allWeekRegionals[weekSelected], regName)!, inComponent: 0, animated: true)
        }
        let regionalPickerLbl = UILabel(frame: CGRect(x: regionalPicker.frame.origin.x, y: regionalPicker.frame.origin.y - 20, width: regionalPicker.frame.width, height: 18))
        regionalPickerLbl.font = UIFont.systemFontOfSize(15)
        regionalPickerLbl.textAlignment = .Center
        regionalPickerLbl.text = "Select Your Regional"
        regionalPickerLbl.adjustsFontSizeToFitWidth = true
        signInView.addSubview(regionalPickerLbl)

        let signInSaveBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        signInSaveBtn.frame = CGRect(x: 250, y: regionalPicker.frame.origin.y + regionalPicker.frame.height + 45, width: 80, height: 35)
        signInSaveBtn.layer.cornerRadius = 5
        signInSaveBtn.backgroundColor = UIColor(red: 37.0/255, green: 149.0/255, blue: 212.0/255, alpha: 1.0)
        signInSaveBtn.titleLabel!.font = UIFont.boldSystemFontOfSize(18)
        signInSaveBtn.setTitle("Save", forState: .Normal)
        signInSaveBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signInSaveBtn.addTarget(self, action: Selector("signInSaveBtnPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        signInView.addSubview(signInSaveBtn)

        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.signInView.transform = CGAffineTransformIdentity
        })
    }

    //All scouting position buttons point to this function and it takes care of changing scout position
    func positionBtnPressed(pressedBtn: UIButton) {
        for btn in scoutPositionBtns {
            if btn != pressedBtn {
                btn.backgroundColor = .whiteColor()
                if find(scoutPositionBtns, btn)! < 3 {
                    btn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                } else {
                    btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
                }
            } else {
                btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                if find(scoutPositionBtns, btn) < 3 {
                    btn.backgroundColor = .redColor()
                } else {
                    btn.backgroundColor = .blueColor()
                }
            }
            scoutPosition = find(scoutPositionBtns, pressedBtn)
        }
    }

    //Sign in text fields (when return is pressed)
    func initialsTFReturnPressed(sender: AnyObject?) { teamNumTF.becomeFirstResponder() }
    func teamNumTFReturnPressed(sender: AnyObject?) { matchNumTF.becomeFirstResponder() }
    func matchNumTFReturnPressed(sender: AnyObject?) { self.view.resignFirstResponder() }

    //Makes there only be one column in the Regional Picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    //Tells the Regional Picker how many rows to display
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allWeekRegionals[weekSelected].count
    }

    //Provides the Regional Picker with resizable labels with the regional names
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var lblView = UILabel()
        lblView.text = allWeekRegionals[weekSelected][row]

        lblView.textAlignment = .Center
        lblView.font = UIFont.systemFontOfSize(20)
        lblView.minimumScaleFactor = 0.2
        lblView.adjustsFontSizeToFitWidth = true

        return lblView
    }

    //If user changes the week they're viewing on the Sign In View
    func weekSelectorChanged(sender: UISegmentedControl) {
        NSUserDefaults.standardUserDefaults().setInteger(sender.selectedSegmentIndex, forKey: WEEKSELECTEDKEY)
        weekSelected = sender.selectedSegmentIndex
        if let selectedLbl = regionalPicker.viewForRow(regionalPicker.selectedRowInComponent(0), forComponent: 0) as? UILabel {
            if contains(allWeekRegionals[weekSelected], selectedLbl.text!) {
                regionalPicker.reloadAllComponents()
                regionalPicker.selectRow(find(allWeekRegionals[weekSelected], selectedLbl.text!)!, inComponent: 0, animated: true)
                return
            }
        }
        regionalPicker.reloadAllComponents()
        regionalPicker.selectRow(0, inComponent: 0, animated: true)
    }

    //When save button is pressed on Sign In View
    func signInSaveBtnPressed(sender: UIButton){
        self.view.resignFirstResponder()
        if scoutPosition == nil {
            let alertController = UIAlertController(title: "No scout position!", message: "Select a scouting position and continue", preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "Aye Aye", style: .Cancel, handler: nil)
            alertController.addAction(confirmAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else if countElements(initialsTF.text) != 3 {
            let alertController = UIAlertController(title: "Three initials weren't entered!", message: "Please enter three initials and continue", preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "Gotcha", style: .Cancel, handler: { (action) -> Void in
                self.initialsTF.becomeFirstResponder()
                return
            })
            alertController.addAction(confirmAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else if teamNumTF.text.toInt() == nil {
            let alertController = UIAlertController(title: "Team number incorrect!", message: "Please your team number correctly", preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "Will do", style: .Cancel, handler: { (action) -> Void in
                self.teamNumTF.becomeFirstResponder()
                return
            })
            alertController.addAction(confirmAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else if matchNumTF.text.toInt() == nil || matchNumTF.text.toInt() < 1 {
            let alertController = UIAlertController(title: "Match number incorrect!", message: "Please correctly input the match number", preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "Affirmative", style: .Cancel, handler: { (action) -> Void in
                self.matchNumTF.becomeFirstResponder()
                return
            })
            alertController.addAction(confirmAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            scoutInitials = initialsTF.text
            scoutTeamNum = teamNumTF.text.toInt()!
            matchNum = matchNumTF.text
            matchNumberCoverBtn.setTitle(matchNumTF.text, forState: .Normal)
            
            regionalName = allWeekRegionals[weekSelected][regionalPicker.selectedRowInComponent(0)]
            NSUserDefaults.standardUserDefaults().setObject(regionalName, forKey: REGIONALSELECTEDKEY)
            switch scoutPosition {
            case 0:
                scoutPosLbl.backgroundColor = .redColor()
                scoutPosLbl.text = "Red 1"
            case 1:
                scoutPosLbl.backgroundColor = .redColor()
                scoutPosLbl.text = "Red 2"
            case 2:
                scoutPosLbl.backgroundColor = .redColor()
                scoutPosLbl.text = "Red 3"
            case 3:
                scoutPosLbl.backgroundColor = .blueColor()
                scoutPosLbl.text = "Blue 1"
            case 4:
                scoutPosLbl.backgroundColor = .blueColor()
                scoutPosLbl.text = "Blue 2"
            case 5:
                scoutPosLbl.backgroundColor = .blueColor()
                scoutPosLbl.text = "Blue 3"
            default:
                scoutPosLbl.backgroundColor = .redColor()
                scoutPosLbl.text = "Red 1"
            }

            self.setUpMultipeer()

            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.signInView.transform = CGAffineTransformMakeScale(0.01, 0.01)
            }, completion: { (completed) -> Void in
                self.signInView.removeFromSuperview()
                self.grayOutView.removeFromSuperview()

                self.instaShareBtn.enabled = true
                
                // FIX FOR TEAM NUMBER //
                self.teamNumberCoverBtn.enabled = false
                self.teamNumberTF.enabled = true
                // YEAH, LIKE HERE //
                
                self.matchNumberCoverBtn.enabled = true
                self.matchNumberTF.enabled = false
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.instaShareBtn.alpha = 1.0
                    self.scoutPosLbl.alpha = 1.0
                    self.teamNumHeaderLbl.alpha = 1.0
                    
                    // FIX FOR TEAM NUMBER //
                    self.teamNumberCoverBtn.alpha = 0
                    self.teamNumberTF.alpha = 1.0
                    // YEAH, LIKE HERE //
                    
                    self.teamNumTapToEditLbl.alpha = 1.0
                    self.matchNumHeaderLbl.alpha = 1.0
                    self.matchNumberCoverBtn.alpha = 1.0
                    self.matchNumTapToEditLbl.alpha = 1.0
                })
            })
        }
    }

    @IBAction func matchNumCoverBtnPressed(sender: UIButton) {
        matchNumberTF.text = sender.titleForState(.Normal)
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.matchNumberCoverBtn.alpha = 0
        }) { (completed) -> Void in
            self.matchNumberCoverBtn.enabled = false
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.matchNumberTF.alpha = 1
            }, completion: { (completed) -> Void in
                self.matchNumberTF.enabled = true
                self.matchNumberTF.becomeFirstResponder()
            })
        }
    }

    @IBAction func teamNumCoverBtnPressed(sender: UIButton) {
        teamNumberTF.text = ""
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.teamNumberCoverBtn.alpha = 0
        }) { (completed) -> Void in
            self.teamNumberCoverBtn.enabled = false
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.teamNumberTF.alpha = 1
            }, completion: { (completed) -> Void in
                    self.teamNumberTF.enabled = true
                    self.teamNumberTF.becomeFirstResponder()
            })
        }
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
            if(!self.bottomCoopStacking) { self.coopToteInsertBtn.enabled = true }
            if(self.currentCoopStack.totes.count != 0 && !self.topCoopStacking) {
                self.coopToteBtmInsertBtn.enabled = true
            } else {
                self.coopToteBtmInsertBtn.enabled = false
            }
            self.toteStackAddBtn.enabled = true
            self.toteStackUndoBtn.enabled = true
            self.tote1.enabled = true
            self.tote2.enabled = true
            self.tote3.enabled = true
            self.tote4.enabled = true
            self.tote5.enabled = true
            self.tote6.enabled = true
            if(!self.bottomToteStacking) { self.toteInsertBtn.enabled = true }
            if(self.currentToteStack.totes.count != 0 && !self.topToteStacking) {
                self.toteBtmInsertBtn.enabled = true
            } else {
                self.toteBtmInsertBtn.enabled = false
            }
            if(self.currentToteStack.totes.count == 0) {
                self.containerInsertBtn.enabled = false
            } else {
                self.containerInsertBtn.enabled = true
            }
            self.toppleStackBtn.enabled = true
            self.toppleUndoBtn.enabled = true

            self.penaltyAddBtn.enabled = true
            self.penaltySubBtn.enabled = true

            self.modeLbl.text = "Teleoperated Scoring Mode"
            self.autoShowing = false

            UIView.animateWithDuration(0.3, animations: { () -> Void in
                if self.numNoodlesInContainer == 10 {
                    self.containerNoodleAddBtn.alpha = 0.7
                    self.containerNoodleAddBtn.enabled = false
                } else {
                    self.containerNoodleAddBtn.alpha = 1.0
                }
                if self.numNoodlesInContainer == 0 {
                    self.containerNoodleSubBtn.alpha = 0.5
                    self.containerNoodleSubBtn.enabled = false
                } else {
                    self.containerNoodleSubBtn.alpha = 1.0
                }
                self.containerNoodleScoreLbl.alpha = 1.0
                self.containerNoodleLbl.alpha = 1.0

                if self.numNoodlesPushedInLandfill == 10 {
                    self.landfillNoodleAddBtn.alpha = 0.7
                    self.landfillNoodleAddBtn.enabled = false
                } else {
                    self.landfillNoodleAddBtn.alpha = 1.0
                }
                if self.numNoodlesPushedInLandfill == 0 {
                    self.landfillNoodleSubBtn.alpha = 0.7
                    self.landfillNoodleSubBtn.enabled = false
                } else {
                    self.landfillNoodleSubBtn.alpha = 1.0
                }
                self.landfillNoodleLbl.alpha = 1.0
                self.landfillNoodleScoreLbl.alpha = 1.0

                self.coopTotesLbl.alpha = 1.0
                self.coopTotesScoreLbl.alpha = 1.0
                var activeCoopExists = false
                for tote in self.currentCoopStack.totes {
                    if tote {
                        activeCoopExists = true
                    }
                }
                if activeCoopExists {
                    self.coopTotesAddBtn.alpha = 1.0
                    self.coopTotesAddBtn.enabled = true
                } else {
                    self.coopTotesAddBtn.alpha = 0.5
                    self.coopTotesAddBtn.enabled = false
                }
                if self.coopStacks.count == 0 && self.coopTotesUndoBtn.titleForState(.Normal) != "Clear Stack" {
                    self.coopTotesUndoBtn.alpha = 0.5
                    self.coopTotesUndoBtn.enabled = false
                } else {
                    self.coopTotesUndoBtn.alpha = 1.0
                }
                self.containerNoodleSubBtn.enabled = false
                self.coopTote1.alpha = 1.0
                self.coopTote2.alpha = 1.0
                self.coopTote3.alpha = 1.0
                self.coopTote4.alpha = 1.0
                self.coopToteInsertBtn.alpha = 1.0
                self.coopToteBtmInsertBtn.alpha = 1.0
                self.toteStackLbl.alpha = 1.0
                self.toteStackScoreLbl.alpha = 1.0

                var activeToteExists = false
                for tote in self.currentToteStack.totes {
                    if tote {
                        activeToteExists = true
                    }
                }
                if activeToteExists {
                    self.toteStackAddBtn.alpha = 1.0
                    self.toteStackAddBtn.enabled = true
                } else {
                    self.toteStackAddBtn.alpha = 0.5
                    self.toteStackAddBtn.enabled = false
                }
                self.toppleStackBtn.alpha = 1.0
                if self.toteStacks.count == 0  && self.toteStackUndoBtn.titleForState(.Normal) != "Clear Stack" {
                    self.toteStackUndoBtn.alpha = 0.5
                    self.toteStackUndoBtn.enabled = false
                } else {
                    self.toteStackUndoBtn.alpha = 1.0
                }
                self.tote1.alpha = 1.0
                self.tote2.alpha = 1.0
                self.tote3.alpha = 1.0
                self.tote4.alpha = 1.0
                self.tote5.alpha = 1.0
                self.tote6.alpha = 1.0
                self.toteInsertBtn.alpha = 1.0
                self.toteBtmInsertBtn.alpha = 1.0
                self.containerInsertBtn.alpha = 1.0
                self.toppleLbl.alpha = 1.0
                if self.numStacksKnockedOver == 0 {
                    self.toppleUndoBtn.alpha = 0.5
                    self.toppleUndoBtn.enabled = false
                } else {
                    self.toppleUndoBtn.alpha = 1.0
                }
                self.penaltyLbl.alpha = 1.0
                self.penaltyValLbl.alpha = 1.0
                self.penaltyAddBtn.alpha = 1.0
                if self.numPenalties == 0 {
                    self.penaltySubBtn.alpha = 0.7
                    self.penaltySubBtn.enabled = false
                } else {
                    self.penaltySubBtn.alpha = 1.0
                }
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
        self.toppleStackBtn.enabled = false
        self.toppleUndoBtn.enabled = false
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
            self.toppleStackBtn.alpha = 0.0
            self.toppleLbl.alpha = 0.0
            self.toppleUndoBtn.alpha = 0.0
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
                    if self.numAutoTotes == 0 {
                        self.autoToteSubBtn.alpha = 0.7
                        self.autoToteSubBtn.enabled = false
                    } else {
                        self.autoToteSubBtn.alpha = 1.0
                    }
                    if self.numAutoTotes == 3 || self.autoStack {
                        self.autoToteAddBtn.alpha = 0.7
                        self.autoToteAddBtn.enabled = false
                    } else {
                        self.autoToteAddBtn.alpha = 1.0
                    }
                    if self.numAutoContainers == 0 {
                        self.autoContainerSubBtn.alpha = 0.7
                        self.autoContainerSubBtn.enabled = false
                    } else {
                        self.autoContainerSubBtn.alpha = 1.0
                    }
                    if self.numAutoContainers == 7 {
                        self.autoContainerAddBtn.alpha = 0.7
                        self.autoContainerAddBtn.enabled = false
                    } else {
                        self.autoContainerAddBtn.alpha = 1.0
                    }
                    self.autoZoneLbl.alpha = 1.0
                    self.autoZoneLine.alpha = 1.0
                    self.autoZoneRobot.alpha = 1.0
                    self.autoStackBtn.alpha = 1.0
                })
        })
    }

    //resets all scores and button positions
    func resetScoringScreen(incrementMatch: Bool){
        //Variables
        numStacks = 0
        numCoopTotes = 0
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
        numPenalties = 0
        tempNotes = nil

        //Auto Items
        autoToteScoreLbl.text = "0"
        autoStackBtn.setBackgroundImage(UIImage(named: "ToteStackOutline"), forState: .Normal)
        autoContainerScoreLbl.text = "0"
        autoZoneRobot.center = CGPoint(x: autoZoneRobot.center.x, y: autoZoneLine.center.y + 65)
        autoZoneLbl.layer.backgroundColor = UIColor.clearColor().CGColor

        //Tele Items
        resetToteStack()
        resetCoopStack()
        containerNoodleScoreLbl.text = "0"
        landfillNoodleScoreLbl.text = "0"
        coopTotesScoreLbl.text = "0"
        toteStackScoreLbl.text = "0"
        penaltyValLbl.text = "0"

        showAuto()

        if !incrementMatch { return }
        
        // TEAM NUMBER FIX FROM SCHEDULE GOES BELOW HERE //
        teamNumberCoverBtn.alpha = 0
        teamNumberCoverBtn.enabled = false
        teamNumberTF.text = ""
        // TEAM NUMBER FIX FROM SCHEDULE GOES ABOVE HERE //
        
        let tempMatchNum = matchNum.toInt()!
        matchNum = "\(tempMatchNum + 1)"
        matchNumberCoverBtn.setTitle(matchNum, forState: .Normal)
        if matchNumberCoverBtn.alpha == 0 {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.matchNumberTF.alpha = 0
            }, completion: { (completed) -> Void in
                self.matchNumberTF.enabled = false
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.matchNumberCoverBtn.alpha = 1
                }, completion: { (completed) -> Void in
                    self.matchNumberCoverBtn.enabled = true
                })
            })
        }
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
        toteInsertBtn.hidden = false
        toteInsertBtn.enabled = true
        containerInsertBtn.hidden = true
        containerInsertBtn.enabled = false
        toteBtmInsertBtn.enabled = false
        toteBtmInsertBtn.hidden = true
        containerInsertBtn.frame = CGRect(x: containerInsertBtn.frame.origin.x, y: containerInsertBtn.frame.origin.y, width: 86, height: 44)
        containerInsertBtn.setBackgroundImage(UIImage(named: "ContainerArrow"), forState: .Normal)
        containerInsertBtn.setTitle("Container", forState: .Normal)
        containerInsertBtn.frame.origin.y = containerInsertBtnLocations[0]
        containerInsertBtn.frame.origin.x = containerInsertBtnSide
        bottomToteStacking = false
        topToteStacking = false
        toteStackAddBtn.enabled = false
        toteStackAddBtn.alpha = 0.5
        if toteStackUndoBtn.titleForState(.Normal) == "Clear Stack" {
            toteStackUndoBtn.setTitle("Undo Save", forState: .Normal)
        }
        if toteStacks.count == 0 {
            toteStackUndoBtn.enabled = false
            toteStackUndoBtn.alpha = 0.5
        }
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
        bottomCoopStacking = false
        topCoopStacking = false
        coopTotesAddBtn.enabled = false
        coopTotesAddBtn.alpha = 0.5
        if coopTotesUndoBtn.titleForState(.Normal) == "Clear Stack" {
            coopTotesUndoBtn.setTitle("Undo Save", forState: .Normal)
        }
        if coopStacks.count == 0 {
            coopTotesUndoBtn.enabled = false
            coopTotesUndoBtn.alpha = 0.5
        }
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
        if numAutoTotes == 0 {
            autoToteSubBtn.enabled = false
            autoToteSubBtn.alpha = 0.7
        }
        if !autoToteAddBtn.enabled {
            autoToteAddBtn.enabled = true
            autoToteAddBtn.alpha = 1.0
        }
    }

    //adds auto totes to score
    @IBAction func autoToteAddBtnPress(sender: AnyObject) {
        //makes sure no more than three auto totes have been scored and there is no autoStack
        if (numAutoTotes < 3 && autoStack == false) {
            numAutoTotes += 1
            autoToteScoreLbl.text = "\(numAutoTotes)"
        }
        if !autoToteSubBtn.enabled {
            autoToteSubBtn.enabled = true
            autoToteSubBtn.alpha = 1.0
        }
        if numAutoTotes == 3 {
            autoToteAddBtn.enabled = false
            autoToteAddBtn.alpha = 0.7
        }
    }

    //removes auto Containers from score
    @IBAction func autoContainerSubBtnPress(sender: AnyObject) {
        //checks to make sure score is greater than 0
        if (numAutoContainers > 0){
            numAutoContainers -= 1
            autoContainerScoreLbl.text = "\(numAutoContainers)"
        }
        if numAutoContainers == 0 {
            autoContainerSubBtn.enabled = false
            autoContainerSubBtn.alpha = 0.7
        }
        if !autoContainerAddBtn.enabled {
            autoContainerAddBtn.enabled = true
            autoContainerAddBtn.alpha = 1.0
        }
    }

    //adds auto Containers to score
    @IBAction func autoContainerAddBtnPress(sender: AnyObject) {
        //checks to make sure no more than 7 containers have been scored
        if (numAutoContainers < 7){
            numAutoContainers += 1
            autoContainerScoreLbl.text = "\(numAutoContainers)"
        }
        if !autoContainerSubBtn.enabled {
            autoContainerSubBtn.enabled = true
            autoContainerSubBtn.alpha = 1.0
        }
        if numAutoContainers == 7 {
            autoContainerAddBtn.enabled = false
            autoContainerAddBtn.alpha = 0.7
        }
    }

    //scores a stack of three auto containers
    @IBAction func autoStackBtnPress(sender: AnyObject) {
        if (autoStack == false){
            autoStack = true
            //set the auto score to zero
            numAutoTotes = 0
            autoToteScoreLbl.text = "0"
            autoToteAddBtn.enabled = false
            autoToteAddBtn.alpha = 0.7
            autoToteSubBtn.enabled = false
            autoToteSubBtn.alpha = 0.7
            autoStackBtn.setBackgroundImage(UIImage(named: "ToteStack"), forState: .Normal)
        } else {
            autoStack = false
            autoStackBtn.setBackgroundImage(UIImage(named: "ToteStackOutline"), forState: .Normal)
            autoToteAddBtn.enabled = true
            autoToteAddBtn.alpha = 1.0
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
        if (numNoodlesInContainer < 10){
            numNoodlesInContainer += 1
            containerNoodleScoreLbl.text = "\(numNoodlesInContainer)"
        }
        if !containerNoodleSubBtn.enabled {
            containerNoodleSubBtn.enabled = true
            containerNoodleSubBtn.alpha = 1.0
        }
        if numNoodlesInContainer == 10 {
            containerNoodleAddBtn.enabled = false
            containerNoodleAddBtn.alpha = 0.7
        }
    }

    //subtracts from number of noodles placed in a container
    @IBAction func noodleContainerSubBtnPress(sender: AnyObject) {
        if( numNoodlesInContainer > 0){
            numNoodlesInContainer -= 1
            containerNoodleScoreLbl.text = "\(numNoodlesInContainer)"
        }
        if !containerNoodleAddBtn.enabled {
            containerNoodleAddBtn.enabled = true
            containerNoodleAddBtn.alpha = 1.0
        }
        if numNoodlesInContainer == 0 {
            containerNoodleSubBtn.enabled = false
            containerNoodleSubBtn.alpha = 0.7
        }
    }

    //adds to number of noodles scored in landfill
    @IBAction func noodleLandfillAddBtnPress(sender: AnyObject) {
        if(numNoodlesPushedInLandfill < 10){
            numNoodlesPushedInLandfill += 1
            landfillNoodleScoreLbl.text = "\(numNoodlesPushedInLandfill)"
        }
        if !landfillNoodleSubBtn.enabled {
            landfillNoodleSubBtn.enabled = true
            landfillNoodleSubBtn.alpha = 1.0
        }
        if numNoodlesPushedInLandfill == 10 {
            landfillNoodleAddBtn.enabled = false
            landfillNoodleAddBtn.alpha = 0.7
        }
    }

    //subtracts from number of noodles scored in landfill
    @IBAction func noodleLandfillSubBtnPress(sender: AnyObject) {
        if(numNoodlesPushedInLandfill > 0){
            numNoodlesPushedInLandfill -= 1
            landfillNoodleScoreLbl.text = "\(numNoodlesPushedInLandfill)"
        }
        if !landfillNoodleAddBtn.enabled {
            landfillNoodleAddBtn.enabled = true
            landfillNoodleAddBtn.alpha = 1.0
        }
        if numNoodlesPushedInLandfill == 0 {
            landfillNoodleSubBtn.enabled = false
            landfillNoodleSubBtn.alpha = 0.7
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
            toteStackAddBtn.enabled = false
            toteStackAddBtn.alpha = 0.5
            toteStackUndoBtn.enabled = true
            toteStackUndoBtn.alpha = 1.0
            resetToteStack()
        }
    }

    //removes the last scored tote stack
    @IBAction func toteStackUndoBtnPress(sender: AnyObject) {
        //If there is a current stack, reset it
        if toteStackUndoBtn.titleForState(.Normal) == "Clear Stack" {
            resetToteStack()
        } else {
            if(toteStacks.count > 0){ //else remove last stack
                toteStacks.removeLast()
                toteStackScoreLbl.text = "\(toteStacks.count)"
            }
        }
        if toteStacks.count == 0 {
            toteStackUndoBtn.enabled = false
            toteStackUndoBtn.alpha = 0.5
        }
    }

    //a tote in the tote stack has been touched. That tote and all of the
    //totes below it will be marked as having been there before
    @IBAction func toteTouch(sender: UIButton) {
        //determine which tote button was pressed
        var toteIndex = find(toteBtns, sender)

        //Special case if the user is trying to reset bottom tote
        if !(toteIndex == 0 && currentToteStack.totes.count == 1){
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
                    if scoutPosition < 3 {
                        toteBtns[i].setBackgroundImage(UIImage(named: "ToteRed"), forState: .Normal)
                    } else {
                        toteBtns[i].setBackgroundImage(UIImage(named: "ToteBlue"), forState: .Normal)
                    }
                }
                else {
                    toteBtns[i].alpha = 1.0
                    toteBtns[i].setBackgroundImage(UIImage(named: "ToteGray"), forState: .Normal)
                }
            }

            if toteStackUndoBtn.titleForState(.Normal) != "Clear Stack" {
                toteStackUndoBtn.setTitle("Clear Stack", forState: .Normal)
                toteStackUndoBtn.enabled = true
                toteStackUndoBtn.alpha = 1.0
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
            bottomToteStacking = true
        } else {
            topToteStacking = true
            currentToteStack.totes.append(true)
        }
        //number of totes in current stack
        var numTotes = currentToteStack.totes.count
        //shows bottom tote insert button and moves top tote insert button,
        //hides insert buttons if there's 6 totes
        if (currentToteStack.totes.count > 1 && currentToteStack.totes.count < 6){
            toteInsertBtn.frame.origin.y = toteInsertBtnLocations[numTotes]
            if(bottomToteStacking){
                toteBtmInsertBtn.enabled = true
                toteBtmInsertBtn.hidden = false
                toteInsertBtn.hidden = true
                toteInsertBtn.enabled = false
            } else {
                toteBtmInsertBtn.enabled = false
                toteBtmInsertBtn.hidden = true
                toteInsertBtn.hidden = false
                toteInsertBtn.enabled = true
            }
        } else if currentToteStack.totes.count == 1 {
            toteInsertBtn.frame.origin.y = toteInsertBtnLocations[numTotes]
            toteBtmInsertBtn.enabled = true
            toteBtmInsertBtn.hidden = false
            toteInsertBtn.enabled = true
            toteInsertBtn.hidden = false
        } else {
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
                if scoutPosition < 3 {
                    toteBtns[i].setBackgroundImage(UIImage(named: "ToteRed"), forState: .Normal)
                } else {
                    toteBtns[i].setBackgroundImage(UIImage(named: "ToteBlue"), forState: .Normal)
                }
            }
            else {
                toteBtns[i].alpha = 1.0
                toteBtns[i].setBackgroundImage(UIImage(named: "ToteGray"), forState: .Normal)
            }
        }
        toteStackAddBtn.enabled = true
        toteStackAddBtn.alpha = 1.0
        if toteStackUndoBtn.titleForState(.Normal) != "Clear Stack" {
            toteStackUndoBtn.setTitle("Clear Stack", forState: .Normal)
            toteStackUndoBtn.enabled = true
            toteStackUndoBtn.alpha = 1.0
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
        toteStackAddBtn.enabled = true
        toteStackAddBtn.alpha = 1.0
        if toteStackUndoBtn.titleForState(.Normal) != "Clear Stack" {
            toteStackUndoBtn.setTitle("Clear Stack", forState: .Normal)
            toteStackUndoBtn.enabled = true
            toteStackUndoBtn.alpha = 1.0
        }
    }

    //adds to number of stacks knocked over
    @IBAction func toppleStackBtnPress(sender: AnyObject) {
        toppleLbl.text = "\(++numStacksKnockedOver)"
        if !toppleUndoBtn.enabled {
            toppleUndoBtn.enabled = true
            toppleUndoBtn.alpha = 1.0
        }
    }

    //subtracts from number of stacks knocked over
    @IBAction func toppleUndoBtnPress(sender: AnyObject) {
        if numStacksKnockedOver > 0 {
            toppleLbl.text = "\(--numStacksKnockedOver)"
        }
        if numStacksKnockedOver == 0 {
            toppleUndoBtn.enabled = false
            toppleUndoBtn.alpha = 0.5
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
            coopTotesAddBtn.enabled = false
            coopTotesAddBtn.alpha = 0.5
            if !coopTotesUndoBtn.enabled {
                coopTotesUndoBtn.enabled = true
                coopTotesUndoBtn.alpha = 1.0
            }
            resetCoopStack()
        }
    }

    //remove last scored coop stack
    @IBAction func coopStackUndoBtnPress(sender: AnyObject) {
        if coopTotesUndoBtn.titleForState(.Normal) == "Clear Stack" {
            resetCoopStack()
        } else {
            if(coopStacks.count > 0){   //check that is a stack to remove
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
        }
        if coopStacks.count == 0 {
            coopTotesUndoBtn.enabled = false
            coopTotesUndoBtn.alpha = 0.5
        }
//        resetCoopStack()
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

            if coopTotesUndoBtn.titleForState(.Normal) != "Clear Stack" {
                coopTotesUndoBtn.setTitle("Clear Stack", forState: .Normal)
                coopTotesUndoBtn.enabled = true
                coopTotesUndoBtn.alpha = 1.0
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
            bottomCoopStacking = true
        } else {
            currentCoopStack.totes.append(true)
        }
        //determines number of totes in the stack
        var numTotes = currentCoopStack.totes.count

        if (numTotes > 1 && numTotes < 4){    //moves top tote insert button and shows bottom insert button
            coopToteInsertBtn.frame.origin.y = coopInsertBtnLocations[numTotes]
            if(bottomCoopStacking){
                coopToteBtmInsertBtn.hidden = false
                coopToteBtmInsertBtn.enabled = true
                coopToteInsertBtn.hidden = true
                coopToteInsertBtn.enabled = false
            } else {
                coopToteBtmInsertBtn.hidden = true
                coopToteBtmInsertBtn.enabled = false
                coopToteInsertBtn.hidden = false
                coopToteInsertBtn.enabled = true
            }
        } else if numTotes == 1 {
            coopToteInsertBtn.frame.origin.y = coopInsertBtnLocations[numTotes]
            coopToteBtmInsertBtn.hidden = false
            coopToteBtmInsertBtn.enabled = true
            coopToteInsertBtn.hidden = false
            coopToteInsertBtn.enabled = true
        } else {      //if at the top of the stack, hide the insert buttons
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
        coopTotesAddBtn.enabled = true
        coopTotesAddBtn.alpha = 1.0
        if coopTotesUndoBtn.titleForState(.Normal) != "Clear Stack" {
            coopTotesUndoBtn.setTitle("Clear Stack", forState: .Normal)
            coopTotesUndoBtn.enabled = true
            coopTotesUndoBtn.alpha = 1.0
        }
    }



    //adds to number of penalties in match
    @IBAction func penaltyAddBtnPress(sender: AnyObject) {
        penaltyValLbl.text = "\(++numPenalties)"
        if !penaltySubBtn.enabled {
            penaltySubBtn.enabled = true
            penaltySubBtn.alpha = 1.0
        }
    }

    //subtracts from number of penalties in match
    @IBAction func penaltySubBtnPress(sender: AnyObject) {
        if numPenalties > 0 {
            numPenalties--
            penaltyValLbl.text = "\(numPenalties)"
        }
        if numPenalties == 0 {
            penaltySubBtn.enabled = false
            penaltySubBtn.alpha = 0.7
        }
    }



    //Hides keyboard for a return press on any UITextField whose delegate is this class
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //Hides keyboard if the screen is tapped
    func screenTapped(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    //Saves match data
    @IBAction func saveMatchButtonPress(sender: AnyObject) {
        if matchNumberCoverBtn.alpha == 1 {
            matchNum = matchNumberCoverBtn.titleForState(UIControlState.Normal)
        } else {
            matchNum = matchNumberTF.text
        }
        if matchNum.toInt() == nil {
            let alertController = UIAlertController(title: "Invalid Match Number!", message: "Please fix the match number before saving again", preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "On it!", style: .Cancel, handler: nil)
            alertController.addAction(confirmAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }

        if teamNumberCoverBtn.alpha == 1 {
            teamNum = teamNumberCoverBtn.titleForState(UIControlState.Normal)!.toInt()
        } else {
            teamNum = teamNumberTF.text.toInt()
        }
        if teamNum == nil {
            let alertController = UIAlertController(title: "Invalid Team Number!", message: "Please fix the team number before saving again", preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "On it!", style: .Cancel, handler: nil)
            alertController.addAction(confirmAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }

        self.showPostMatchNotes()
    }
    
    func showPostMatchNotes() {
        self.view.addSubview(grayOutView)
        
        postMatchNotesView = UIView(frame: CGRect(x: UIScreen.mainScreen().bounds.width/2 - 175, y: 400, width: 350, height: 230))
        postMatchNotesView.backgroundColor = .whiteColor()
        postMatchNotesView.layer.cornerRadius = 10
        
        let dismissNotesViewBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        dismissNotesViewBtn.frame = CGRect(x: postMatchNotesView.frame.width - 60, y: 3, width: 50, height: 25)
        dismissNotesViewBtn.setTitle("Close X", forState: UIControlState.Normal)
        dismissNotesViewBtn.titleLabel!.font = UIFont.systemFontOfSize(14)
        dismissNotesViewBtn.addTarget(self, action: Selector("dismissPostMatchNotes:"), forControlEvents: .TouchUpInside)
        postMatchNotesView.addSubview(dismissNotesViewBtn)
        
        let postMatchNotesViewTitleLbl = UILabel(frame: CGRect(x: postMatchNotesView.frame.width/2 - 100, y: 15, width: 200, height: 25))
        postMatchNotesViewTitleLbl.text = "Add Some Notes!"
        postMatchNotesViewTitleLbl.font = UIFont.boldSystemFontOfSize(19)
        postMatchNotesViewTitleLbl.textAlignment = .Center
        postMatchNotesView.addSubview(postMatchNotesViewTitleLbl)
        
        postMatchNotesTextView = UITextView(frame: CGRect(x: 40, y: 60, width: 270, height: 100))
        postMatchNotesTextView.textAlignment = .Center
        postMatchNotesTextView.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).CGColor
        postMatchNotesTextView.layer.borderWidth = 1
        postMatchNotesTextView.layer.cornerRadius = 8
        postMatchNotesTextView.font = UIFont.systemFontOfSize(14)
        postMatchNotesTextView.text = "Add notes here"
        postMatchNotesTextView.textColor = UIColor.lightGrayColor()
        postMatchNotesTextView.delegate = self
        postMatchNotesView.addSubview(postMatchNotesTextView)
        if tempNotes != nil {
            postMatchNotesTextView.text = tempNotes
            postMatchNotesTextView.textColor = .blackColor()
        }
        
        let saveMatchBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        saveMatchBtn.frame = CGRect(x: postMatchNotesView.frame.width/2 - 55, y: 185, width: 110, height: 30)
        saveMatchBtn.backgroundColor = UIColor(red: 13.0/255, green: 165.0/255, blue: 255.0/255, alpha: 1.0)
        saveMatchBtn.setTitle("Save Match", forState: UIControlState.Normal)
        saveMatchBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        saveMatchBtn.titleLabel!.font = UIFont.boldSystemFontOfSize(16)
        saveMatchBtn.addTarget(self, action: Selector("saveMatchToCoreData"), forControlEvents: .TouchUpInside)
        saveMatchBtn.layer.cornerRadius = 5
        saveMatchBtn.tag = 5
        postMatchNotesView.addSubview(saveMatchBtn)
        
        postMatchNotesView.transform = CGAffineTransformMakeTranslation(0, UIScreen.mainScreen().bounds.height - postMatchNotesView.frame.origin.y)
        self.view.addSubview(postMatchNotesView)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.postMatchNotesView.transform = CGAffineTransformIdentity
        }) { (completed) -> Void in
            self.postMatchNotesTextView.becomeFirstResponder()
            return
        }
    }
    
    func dismissPostMatchNotes(andResetScoring: AnyObject?){
        var resetScoring : Bool?
        if let boolType : Bool = andResetScoring as? Bool{
            resetScoring = boolType
        }
        
        if postMatchNotesTextView.textColor == UIColor.blackColor() {
            tempNotes = postMatchNotesTextView.text
        } else {
            tempNotes = nil
        }
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.postMatchNotesView.transform = CGAffineTransformMakeTranslation(0, UIScreen.mainScreen().bounds.height - self.postMatchNotesView.frame.origin.y)
        }) { (completed) -> Void in
            self.postMatchNotesView.removeFromSuperview()
            self.grayOutView.removeFromSuperview()
            if resetScoring == true {
                self.resetScoringScreen(true)
            }
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView == postMatchNotesTextView {
            if postMatchNotesTextView.text == "Add notes here" && postMatchNotesTextView.textColor == UIColor.lightGrayColor() {
                postMatchNotesTextView.text = ""
                postMatchNotesTextView.textColor = UIColor.blackColor()
            }
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == postMatchNotesTextView {
            if postMatchNotesTextView.text == "" {
                postMatchNotesTextView.text = "Add notes here"
                postMatchNotesTextView.textColor = UIColor.lightGrayColor()
            }
        }
    }
    
    func saveMatchToCoreData() {
        let context : NSManagedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        
        var regionalData = Regional.createRegional(regionalName, context: context)
        var masterTeam = MasterTeam.createMasterTeam(teamNum, context: context)
        var teamData = Team.createTeam(teamNum, regional: regionalData, masterTeam: masterTeam, context: context)
        
        var toteStackData = [ToteStack]()
        var coopStackData = [CoopStack]()
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
            toteStackData.append(newToteStack)
        }
        for stack in coopStacks {
            var numTotes = stack.totes.count
            var newCoopStack: CoopStack = NSEntityDescription.insertNewObjectForEntityForName("CoopStack", inManagedObjectContext: context) as CoopStack
            if(numTotes >= 1) {newCoopStack.tote1 = (stack.totes[0]) ? 2:1} else {newCoopStack.tote1 = 0}
            if(numTotes >= 2) {newCoopStack.tote2 = (stack.totes[1]) ? 2:1} else {newCoopStack.tote2 = 0}
            if(numTotes >= 3) {newCoopStack.tote3 = (stack.totes[2]) ? 2:1} else {newCoopStack.tote3 = 0}
            if(numTotes >= 4) {newCoopStack.tote4 = (stack.totes[3]) ? 2:1} else {newCoopStack.tote4 = 0}
            coopStackData.append(newCoopStack)
        }
        var matchUniqueID =  Int(NSDate().timeIntervalSince1970)
        var matchDict = [
            "autoContainers": numAutoContainers,
            "autoTotes": numAutoTotes,
            "numCoopStacks": numCoopStacks,
            "numStacks": numStacks,
            "noodlesInContainer": numNoodlesInContainer,
            "penalty": numPenalties,
            "stacksKnockedOver": numStacksKnockedOver,
            "noodlesInLandFill": numNoodlesPushedInLandfill,
            "autoDrive": autoDrive,
            "autoStack": autoStack,
            "toteStacks": NSSet(array: toteStackData),
            "coopStacks": NSSet(array: coopStackData),
            "uniqueID": matchUniqueID,
            "matchNum": matchNum,
            "scoutInitials": scoutInitials,
            "scoutPosition": scoutPosition,
            "notes": tempNotes ?? ""]
        
        var match = Match.createMatch(matchDict, team: teamData, context: context)
        
        teamData = dataCalc.calculateAverages(teamData)
        
        
        if session.connectedPeers.count > 0 {
            var sendToteStacks = Array<Array<Int>>()
            for var i = 0; i < toteStacks.count; ++i {
                let stack = toteStacks[i]
                let numTotes = stack.totes.count
                var toteStack = [Int](count: 7, repeatedValue: 0)
                if(numTotes >= 1) {toteStack[0] = (stack.totes[0]) ? 2:1} else {toteStack[0] = 0}
                if(numTotes >= 2) {toteStack[1] = (stack.totes[1]) ? 2:1} else {toteStack[1] = 0}
                if(numTotes >= 3) {toteStack[2] = (stack.totes[2]) ? 2:1} else {toteStack[2] = 0}
                if(numTotes >= 4) {toteStack[3] = (stack.totes[3]) ? 2:1} else {toteStack[3] = 0}
                if(numTotes >= 5) {toteStack[4] = (stack.totes[4]) ? 2:1} else {toteStack[4] = 0}
                if(numTotes >= 6) {toteStack[5] = (stack.totes[5]) ? 2:1} else {toteStack[5] = 0}
                toteStack[6] = stack.containerLvl
                sendToteStacks.append(toteStack)
            }
            
            var sendCoopStacks = Array<Array<Int>>()
            for var i = 0; i < coopStacks.count; ++i {
                let stack = coopStacks[i]
                let numTotes = stack.totes.count
                var coopStack = [Int](count: 4, repeatedValue: 0)
                if(numTotes >= 1) {coopStack[0] = (stack.totes[0]) ? 2:1} else {coopStack[0] = 0}
                if(numTotes >= 2) {coopStack[1] = (stack.totes[1]) ? 2:1} else {coopStack[1] = 0}
                if(numTotes >= 3) {coopStack[2] = (stack.totes[2]) ? 2:1} else {coopStack[2] = 0}
                if(numTotes >= 4) {coopStack[3] = (stack.totes[3]) ? 2:1} else {coopStack[3] = 0}
                sendCoopStacks.append(coopStack)
            }
            
            var sendMatchDict = [
                "autoContainers": numAutoContainers,
                "autoTotes": numAutoTotes,
                "numCoopStacks": numCoopStacks,
                "numStacks": numStacks,
                "noodlesInContainer": numNoodlesInContainer,
                "penalty": numPenalties,
                "stacksKnockedOver": numStacksKnockedOver,
                "noodlesInLandFill": numNoodlesPushedInLandfill,
                "autoDrive": autoDrive,
                "autoStack": autoStack,
                "toteStacks": sendToteStacks,
                "coopStacks": sendCoopStacks,
                "uniqueID": matchUniqueID,
                "matchNum": matchNum,
                "scoutInitials": scoutInitials,
                "scoutPosition": scoutPosition,
                "notes": tempNotes ?? ""]
            
            var instaShareDict = [
                "regionalName": regionalName,
                "masterTeamNum": teamNum,
                "matchDict" : sendMatchDict
            ]
            
            var instaShareData = NSKeyedArchiver.archivedDataWithRootObject(instaShareDict)
            
            var sendErr : NSError?
            session.sendData(instaShareData, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: &sendErr)
        }
        
        var saveErr : NSError?
        if !context.save(&saveErr) {
            println(saveErr!.localizedDescription)
            return
        } else {
            var alertController = UIAlertController(title: "Save Success!", message: nil, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Sweet", style: .Cancel, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        dismissPostMatchNotes(true)
    }
    

    // ********************************************** //
    // *********** Multipeer Connectivity *********** //
    // ********************************************** //

    let serviceType = "FRCScout"

    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID : MCPeerID!

    var instaShareControlView : UIView!
    var inviteToPartyBtn : UIButton!
    var visibilitySwitch : UISwitch!

    var isBrowsing = false
    var isVisible = true
    
    @IBOutlet weak var red1ConnectedLbl: UILabel!
    @IBOutlet weak var red2ConnectedLbl: UILabel!
    @IBOutlet weak var red3ConnectedLbl: UILabel!
    @IBOutlet weak var blue1ConnectedLbl: UILabel!
    @IBOutlet weak var blue2ConnectedLbl: UILabel!
    @IBOutlet weak var blue3ConnectedLbl: UILabel!
    
    
    func setUpConnectionUI() {
        red1ConnectedLbl.clipsToBounds = true
        red1ConnectedLbl.layer.cornerRadius = 5
        red2ConnectedLbl.clipsToBounds = true
        red2ConnectedLbl.layer.cornerRadius = 5
        red3ConnectedLbl.clipsToBounds = true
        red3ConnectedLbl.layer.cornerRadius = 5
        blue1ConnectedLbl.clipsToBounds = true
        blue1ConnectedLbl.layer.cornerRadius = 5
        blue2ConnectedLbl.clipsToBounds = true
        blue2ConnectedLbl.layer.cornerRadius = 5
        blue3ConnectedLbl.clipsToBounds = true
        blue3ConnectedLbl.layer.cornerRadius = 5
    }
    func setUpMultipeer() {

        peerID = MCPeerID(displayName: "\(scoutPosLbl.text!) - \(scoutTeamNum)")
        session = MCSession(peer: peerID)
        session.delegate = self

        browser = MCBrowserViewController(serviceType: serviceType, session: session)
        browser.delegate = self
        
        if red1ConnectedLbl.text == "You" {
            red1ConnectedLbl.text = "Red 1"
            red1ConnectedLbl.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        }
        if red2ConnectedLbl.text == "You" {
            red2ConnectedLbl.text = "Red 2"
            red2ConnectedLbl.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        }
        if red3ConnectedLbl.text == "You" {
            red3ConnectedLbl.text = "Red 3"
            red3ConnectedLbl.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        }
        if blue1ConnectedLbl.text == "You" {
            blue1ConnectedLbl.text = "Blue 1"
            blue1ConnectedLbl.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        }
        if blue2ConnectedLbl.text == "You" {
            blue2ConnectedLbl.text = "Blue 2"
            blue2ConnectedLbl.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        }
        if blue3ConnectedLbl.text == "You" {
            blue3ConnectedLbl.text = "Blue 3"
            blue3ConnectedLbl.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        }
        
        switch scoutPosition {
            case 0:
                red1ConnectedLbl.text = "You"
                red1ConnectedLbl.backgroundColor = .redColor()
            
            case 1:
                red2ConnectedLbl.text = "You"
                red2ConnectedLbl.backgroundColor = .redColor()
                
            case 2:
                red3ConnectedLbl.text = "You"
                red3ConnectedLbl.backgroundColor = .redColor()
                
            case 3:
                blue1ConnectedLbl.text = "You"
                blue1ConnectedLbl.backgroundColor = .blueColor()
                
            case 4:
                blue2ConnectedLbl.text = "You"
                blue2ConnectedLbl.backgroundColor = .blueColor()
                
            case 5:
                blue3ConnectedLbl.text = "You"
                blue3ConnectedLbl.backgroundColor = .blueColor()
                
            default:
                break
        }
        
    }

    @IBAction func instaShareBtnPressed(sender: AnyObject) {
        self.view.addSubview(grayOutView)

        instaShareControlView = UIView(frame: CGRect(x: (UIScreen.mainScreen().bounds.width - 400)/2, y: 375, width: 400, height: 150))
        instaShareControlView.backgroundColor = .whiteColor()
        instaShareControlView.layer.cornerRadius = 10
        self.view.addSubview(instaShareControlView)

        let instaShareCloseBtn = UIButton.buttonWithType(.System) as UIButton
        instaShareCloseBtn.frame = CGRect(x: 336, y: 5, width: 60, height: 20)
        instaShareCloseBtn.setTitle("Close X", forState: .Normal)
        instaShareCloseBtn.titleLabel!.font = UIFont.systemFontOfSize(13)
        instaShareCloseBtn.addTarget(self, action: Selector("instaShareCloseBtnPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        instaShareControlView.addSubview(instaShareCloseBtn)

        let instaShareTitleLbl = UILabel(frame: CGRect(x: instaShareControlView.frame.width/2 - 150, y: 20, width: 300, height: 20))
        instaShareTitleLbl.text = "Insta-Share Control Panel"
        instaShareTitleLbl.textAlignment = .Center
        instaShareTitleLbl.font = UIFont.boldSystemFontOfSize(19)
        instaShareTitleLbl.textColor = UIColor(red: 13.0/255, green: 165.0/255, blue: 255.0/255, alpha: 1.0)
        instaShareControlView.addSubview(instaShareTitleLbl)
        
        inviteToPartyBtn = UIButton.buttonWithType(.System) as UIButton
        inviteToPartyBtn.frame = CGRect(x: 45, y: 75, width: 115, height: 31)
        inviteToPartyBtn.setTitle("Invite to Party", forState: .Normal)
        inviteToPartyBtn.backgroundColor = UIColor(red: 13.0/255, green: 165.0/255, blue: 255.0/255, alpha: 1.0)
        inviteToPartyBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        inviteToPartyBtn.layer.cornerRadius = 5
        inviteToPartyBtn.titleLabel!.font = UIFont.boldSystemFontOfSize(16)
        inviteToPartyBtn.addTarget(self, action: Selector("inviteToPartyBtnPressed:"), forControlEvents: .TouchUpInside)
        instaShareControlView.addSubview(inviteToPartyBtn)

        visibilitySwitch = UISwitch(frame: CGRect(x: 269, y: inviteToPartyBtn.frame.origin.y, width: 0, height: 0))
        visibilitySwitch.setOn(false, animated: false)
        visibilitySwitch.addTarget(self, action: Selector("visibilitySwitchChanged:"), forControlEvents: .ValueChanged)
        instaShareControlView.addSubview(visibilitySwitch)
        let visibilitySwitchLbl = UILabel(frame: CGRect(x: visibilitySwitch.frame.origin.x - 5, y: visibilitySwitch.frame.origin.y - 17, width: visibilitySwitch.frame.width + 10, height: 15))
        visibilitySwitchLbl.text = "Visibility"
        visibilitySwitchLbl.textAlignment = .Center
        visibilitySwitchLbl.font = UIFont.systemFontOfSize(14)
        visibilitySwitchLbl.textColor = UIColor(white: 0.2, alpha: 1.0)
        instaShareControlView.addSubview(visibilitySwitchLbl)


        instaShareControlView.transform = CGAffineTransformMakeTranslation(0, -(instaShareControlView.frame.origin.y + instaShareControlView.frame.height))
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.instaShareControlView.transform = CGAffineTransformIdentity
        }) { (completed) -> Void in
            self.visibilitySwitch.setOn(self.isVisible, animated: true)
            self.visibilitySwitchChanged(self.visibilitySwitch)
            self.inviteToPartyBtn.enabled = self.isVisible
        }
    }
    
    
    
    func instaShareCloseBtnPressed(sender: UIButton) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.instaShareControlView.transform = CGAffineTransformMakeTranslation(0, -(self.instaShareControlView.frame.origin.y + self.instaShareControlView.frame.height))
        }) { (completed) -> Void in
            self.instaShareControlView.removeFromSuperview()
            self.grayOutView.removeFromSuperview()
        }
    }
    
    func inviteToPartyBtnPressed(sender: UIButton) {
        self.presentViewController(browser, animated: true, completion: nil)
        isBrowsing = true
    }

    func visibilitySwitchChanged(sender: UISwitch) {
        isVisible = sender.on
        inviteToPartyBtn.enabled = sender.on
        if sender.on {
            if assistant == nil {
                assistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: session)
                assistant.start()
            }
            inviteToPartyBtn.alpha = 1.0
        } else {
            if assistant != nil {
                session.disconnect()
                assistant.stop()
                assistant = nil
            }
            inviteToPartyBtn.alpha = 0.5
        }
    }

    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        isBrowsing = false
    }

    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        isBrowsing = false
    }

    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            println("SUCCESS!! RECEIVED \(data.length) BITS OF DATA!!!")
            let receivedMatchDict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as [String: AnyObject]
            println(receivedMatchDict)
        })
    }

    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        switch state {
        case .Connected:
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if peerID.displayName.rangeOfString(self.scoutPosLbl.text!) != nil {
                    if self.isBrowsing {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    let duplicateAlertController = UIAlertController(title: "Uh oh!", message: "You just connected to another \(self.scoutPosLbl.text!)! \nOne of you needs to disconnect from the party.", preferredStyle: .Alert)
                    let leaveAction = UIAlertAction(title: "I'll Leave", style: .Default, handler: { (action) -> Void in
                        self.visibilitySwitch.setOn(false, animated: true)
                        self.visibilitySwitchChanged(self.visibilitySwitch)
                    })
                    duplicateAlertController.addAction(leaveAction)
                    let stayAction = UIAlertAction(title: "I'm Staying", style: .Cancel, handler: nil)
                    duplicateAlertController.addAction(stayAction)
                    self.presentViewController(duplicateAlertController, animated: true, completion: nil)
                    return
                }
                if !self.isBrowsing {
                    let connectedAlertController = UIAlertController(title: "Connected!", message: "You've connected to \(peerID.displayName)!", preferredStyle: .Alert)
                    let confirmAction = UIAlertAction(title: "Cool", style: .Cancel, handler: nil)
                    connectedAlertController.addAction(confirmAction)
                    self.presentViewController(connectedAlertController, animated: true, completion: nil)
                }
                if peerID.displayName.rangeOfString("Red 1") != nil { self.red1ConnectedLbl.backgroundColor = .redColor() }
                else if peerID.displayName.rangeOfString("Red 2") != nil { self.red2ConnectedLbl.backgroundColor = .redColor() }
                else if peerID.displayName.rangeOfString("Red 3") != nil { self.red3ConnectedLbl.backgroundColor = .redColor() }
                else if peerID.displayName.rangeOfString("Blue 1") != nil { self.blue1ConnectedLbl.backgroundColor = .blueColor() }
                else if peerID.displayName.rangeOfString("Blue 2") != nil { self.blue2ConnectedLbl.backgroundColor = .blueColor() }
                else if peerID.displayName.rangeOfString("Blue 3") != nil { self.blue3ConnectedLbl.backgroundColor = .blueColor() }
            })

        case .NotConnected:
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if !self.isBrowsing {
                    let notConnectedAlertController = UIAlertController(title: "Disconnected!", message: "You've disconnected from \(peerID.displayName)!", preferredStyle: .Alert)
                    let confirmAction = UIAlertAction(title: "Aww man! Ok...", style: .Cancel, handler: nil)
                    notConnectedAlertController.addAction(confirmAction)
                    self.presentViewController(notConnectedAlertController, animated: true, completion: nil)
                }
                if peerID.displayName.rangeOfString(self.scoutPosLbl.text!) == nil {
                    if peerID.displayName.rangeOfString("Red 1") != nil { self.red1ConnectedLbl.backgroundColor = UIColor(white: 0.8, alpha: 1.0) }
                    else if peerID.displayName.rangeOfString("Red 2") != nil { self.red2ConnectedLbl.backgroundColor = UIColor(white: 0.8, alpha: 1.0) }
                    else if peerID.displayName.rangeOfString("Red 3") != nil { self.red3ConnectedLbl.backgroundColor = UIColor(white: 0.8, alpha: 1.0) }
                    else if peerID.displayName.rangeOfString("Blue 1") != nil { self.blue1ConnectedLbl.backgroundColor = UIColor(white: 0.8, alpha: 1.0) }
                    else if peerID.displayName.rangeOfString("Blue 2") != nil { self.blue2ConnectedLbl.backgroundColor = UIColor(white: 0.8, alpha: 1.0) }
                    else if peerID.displayName.rangeOfString("Blue 3") != nil { self.blue3ConnectedLbl.backgroundColor = UIColor(white: 0.8, alpha: 1.0) }
                }
            })

        default:
            return
        }
    }




    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        // Dumb required function
    }
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        // Another dumb required function
    }
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        // Third and final dumb required function
    }


}


