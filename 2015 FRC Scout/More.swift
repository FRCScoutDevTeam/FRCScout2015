//
//  more.swift
//  2015 FRC Scout
//
//  Created by David Swed on 1/9/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit
import CoreData
import MultipeerConnectivity

class More: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate {
    
    //Regional selection View Items
    var grayOutView : UIView!
    var regionalView = UIView()
    var regionalPicker : UIPickerView!
    var weekSelector : UISegmentedControl!
    
    let signInLayoutWidth : CGFloat = 120
    let signInLayoutHeight : CGFloat = 40
    let signInLayoutXDiff : CGFloat = 30
    let signInLayoutYDiff : CGFloat = 15
    var weekSelected : Int!

    //share matches view items
    var shareView = UIView()
    var shareFrame = CGRect(x: 94, y: 130, width: 580, height: 400)
    var visibleLbl : UILabel!
    var visibleSwitch : UISwitch!
    var picsSwitch : UISwitch!
    var justRegionalSwitch : UISwitch!
    var inviteBtn : UIButton!
    var picsLbl : UILabel!
    var justRegionalLbl : UILabel!
    var shareBtn : UIButton!
    var nameTxt : UITextField!
    var numberTxt : UITextField!
    
    
    @IBOutlet weak var changeRegionalBtn: UIButton!
    @IBOutlet weak var shareMatchesBtn: UIButton!
    @IBOutlet weak var deleteAllMatchesBtn: UIButton!
    var regionalName : String!
    
    var scoutFirstName : String?
    var scoutTeamNum : String?
    var isSharingVisible = false
    var isSharePics = true
    var isJustThisRegional = true

    override func viewDidLoad() {
        super.viewDidLoad()
        changeRegionalBtn.layer.cornerRadius = 10
        shareMatchesBtn.layer.cornerRadius = 10
        deleteAllMatchesBtn.layer.cornerRadius = 10
        
        grayOutView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        grayOutView.backgroundColor = UIColor(white: 0.6, alpha: 0.6)
        
        weekSelected = NSUserDefaults.standardUserDefaults().integerForKey(WEEKSELECTEDKEY) ?? 0
        regionalPicker = UIPickerView()
        regionalPicker.delegate = self
        regionalPicker.dataSource = self
        
        let tapDismiss = UITapGestureRecognizer(target: self, action: Selector("screenTapped:"))
        self.view.addGestureRecognizer(tapDismiss)
        
    }
    
    //Hides keyboard if the screen is tapped
    func screenTapped(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareBtnPress(sender: AnyObject) {
        
        var shareFrame = CGRect(x: 159, y: 230, width: 450, height: 400)
        var xC1: CGFloat = shareFrame.width * 0.3   //center x of the first column of items
        var xC2: CGFloat = shareFrame.width * 0.7   //center x of the second column of items
        var yStart: CGFloat = shareFrame.height * 0.15   //starting height of first row
        var ySpacing: CGFloat = 30
        var labelWidth: CGFloat = 120
        var labelHeight: CGFloat = 25
        var txtWidth: CGFloat = 110
        var txtHeight: CGFloat = 30
        var switchWidth: CGFloat = 51
        var switchHeight: CGFloat = 31
        
        self.view.addSubview(grayOutView)
        shareView = UIView(frame: shareFrame)
        shareView.backgroundColor = .whiteColor()
        shareView.layer.cornerRadius = 10
        
        var closeBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        closeBtn.frame = CGRect(x: shareView.layer.frame.width - 60, y: 5, width: 50, height:20)
        closeBtn.addTarget(nil, action: Selector("closeShareView"), forControlEvents: .TouchUpInside)
        closeBtn.setTitle("Close X", forState: UIControlState.Normal)
        closeBtn.titleLabel!.font = UIFont.systemFontOfSize(14)
        shareView.addSubview(closeBtn)
        
        let shareLbl = UILabel(frame: CGRect(x: shareFrame.width/2 - 100, y: 15, width: 200, height: 30))
        shareLbl.font = UIFont.boldSystemFontOfSize(23)
        shareLbl.textAlignment = .Center
        shareLbl.text = "Share Matches"
        shareView.addSubview(shareLbl)
        
        let nameLbl = UILabel(frame: CGRect(x: xC1 - labelWidth/2, y: yStart, width: labelWidth, height: labelHeight))
        nameLbl.font = UIFont.boldSystemFontOfSize(15)
        nameLbl.textAlignment = .Center
        nameLbl.text = "First Name"
        nameLbl.adjustsFontSizeToFitWidth = true
        shareView.addSubview(nameLbl)
        
        nameTxt = UITextField(frame: CGRect(x: xC1 - txtWidth/2, y: yStart + ySpacing - 5, width: txtWidth, height: txtHeight))
        nameTxt.font = UIFont.systemFontOfSize(15)
        nameTxt.textAlignment = .Center
        nameTxt.placeholder = "First Name"
        nameTxt.returnKeyType = .Next
        nameTxt.delegate = self
        nameTxt.borderStyle = UITextBorderStyle.RoundedRect
        shareView.addSubview(nameTxt)
        if scoutFirstName != nil {
            nameTxt.text = scoutFirstName
        }
        
        let numberLbl = UILabel(frame: CGRect(x: xC2 - labelWidth/2, y: yStart, width: labelWidth, height: labelHeight))
        numberLbl.font = UIFont.boldSystemFontOfSize(15)
        numberLbl.textAlignment = .Center
        numberLbl.text = "Team Number"
        numberLbl.adjustsFontSizeToFitWidth = true
        shareView.addSubview(numberLbl)
        
        numberTxt = UITextField(frame: CGRect(x: xC2 - txtWidth/2, y: yStart + ySpacing - 5, width: txtWidth, height: txtHeight))
        numberTxt.font = UIFont.systemFontOfSize(15)
        numberTxt.textAlignment = .Center
        numberTxt.placeholder = "Team #"
        numberTxt.keyboardType = .NumberPad
        numberTxt.delegate = self
        numberTxt.borderStyle = UITextBorderStyle.RoundedRect
        shareView.addSubview(numberTxt!)
        if scoutTeamNum != nil {
            numberTxt.text = scoutTeamNum
        }
        
        inviteBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        inviteBtn.frame = CGRect(x: xC1 - 65, y: yStart + ySpacing*3, width: 130, height: 35)
        inviteBtn.setTitle("Invite To Party", forState: UIControlState.Normal)
        inviteBtn.titleLabel!.font = UIFont.systemFontOfSize(15)
        inviteBtn.layer.cornerRadius = 5
        inviteBtn.addTarget(self, action: Selector("inviteToParty"), forControlEvents: .TouchUpInside)
        inviteBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        inviteBtn.backgroundColor = UIColor(red: 0.1, green: 0.3, blue: 0.9, alpha: 1.0)
        inviteBtn.alpha = 0.5
        inviteBtn.enabled = false
        shareView.addSubview(inviteBtn)
        
        visibleLbl = UILabel(frame: CGRect(x: xC2 - labelWidth/2, y: yStart + ySpacing*2 + 13 , width: labelWidth, height: labelHeight))
        visibleLbl.font = UIFont.systemFontOfSize(15)
        visibleLbl.textAlignment = .Center
        visibleLbl.text = "Visible"
        visibleLbl.alpha = 0.5
        visibleLbl.adjustsFontSizeToFitWidth = true
        shareView.addSubview(visibleLbl)
        
        visibleSwitch = UISwitch( frame: CGRect(x: xC2 - switchWidth/2, y: yStart + ySpacing * 3 + 8, width: switchWidth, height: switchHeight))
        visibleSwitch.on = false
        visibleSwitch.enabled = false
        visibleSwitch.alpha = 0.5
        visibleSwitch.addTarget(self, action: Selector("visibleSwitched:"), forControlEvents: .ValueChanged)
        shareView.addSubview(visibleSwitch!)
        
        picsLbl = UILabel(frame: CGRect(x: xC1 - labelWidth/2, y: yStart + ySpacing*5 - 3, width: labelWidth, height: labelHeight))
        picsLbl.font = UIFont.systemFontOfSize(15)
        picsLbl.textAlignment = .Center
        picsLbl.text = "Share Pics"
        picsLbl.adjustsFontSizeToFitWidth = true
        picsLbl.alpha = 0.5
        shareView.addSubview(picsLbl)
        
        picsSwitch = UISwitch(frame: CGRect(x: xC1 - switchWidth/2, y: yStart + ySpacing * 6 - 5, width: switchWidth, height: switchHeight))
        picsSwitch.on = false
        picsSwitch.alpha = 0.5
        picsSwitch.enabled = false
        picsSwitch.addTarget(self, action: Selector("picSwitchChanged:"), forControlEvents: .ValueChanged)
        shareView.addSubview(picsSwitch)
        
        justRegionalLbl = UILabel(frame: CGRect(x: xC2 - labelWidth/2, y: yStart + ySpacing*5 - 3, width: labelWidth, height: labelHeight))
        justRegionalLbl.font = UIFont.systemFontOfSize(15)
        justRegionalLbl.textAlignment = .Center
        justRegionalLbl.text = "Just This Regional"
        justRegionalLbl.adjustsFontSizeToFitWidth = true
        justRegionalLbl.alpha = 0.5
        shareView.addSubview(justRegionalLbl)
        
        justRegionalSwitch = UISwitch(frame: CGRect(x: xC2 - switchWidth/2, y: yStart + ySpacing * 6 - 5, width: switchWidth, height: switchHeight))
        justRegionalSwitch.on = false
        justRegionalSwitch.alpha = 0.5
        justRegionalSwitch.enabled = false
        justRegionalSwitch.addTarget(self, action: Selector("justRegionalSwitchChanged:"), forControlEvents: .ValueChanged)
        shareView.addSubview(justRegionalSwitch)
        
        shareBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        shareBtn.frame = CGRect(x: shareFrame.width/2 - 60, y: yStart + ySpacing*8 - 10, width: 120, height: 40)
        shareBtn.setTitle("Share", forState: .Normal)
        shareBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        shareBtn.titleLabel!.font = UIFont.boldSystemFontOfSize(20)
        shareBtn.layer.cornerRadius = 5
        shareBtn.addTarget(self, action: Selector("share"), forControlEvents: .TouchUpInside)
        shareBtn.backgroundColor = UIColor(red: 0.1, green: 0.3, blue: 0.9, alpha: 1.0)
        shareBtn.alpha = 1.0
        shareBtn.enabled = true
        shareView.addSubview(shareBtn)
        
        if countElements(nameTxt.text) > 0 && numberTxt.text.toInt() != nil && numberTxt.text.toInt() > 0 {
            self.enableShareUI(true, isVisibleEnabled: true)
        } else {
            self.enableShareUI(false, isVisibleEnabled: false)
        }
        
        shareView.transform = CGAffineTransformMakeScale(0.01, 0.01)
        self.view.addSubview(shareView)
        self.view.bringSubviewToFront(shareView)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.shareView.transform = CGAffineTransformIdentity
        }) { (completed) -> Void in
            if self.isSharingVisible {
                self.visibleSwitch.setOn(true, animated: true)
                self.visibleSwitched(self.visibleSwitch)
            }
            self.shareBtn.enabled = true
        }
        
    }
    
    func inviteToParty() {
        self.presentViewController(browser, animated: true, completion: nil)
        isBrowsing = true
    }
    
    func visibleSwitched(sender: UISwitch) {
        self.enableShareUI(sender.on, isVisibleEnabled: true)
        if sender.on {
            if assistant == nil {
                assistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: mcSession)
                assistant.start()
            }
            nameTxt.enabled = false
            nameTxt.alpha = 0.5
            numberTxt.enabled = false
            numberTxt.alpha = 0.5
            isSharingVisible = true
        } else {
            if assistant != nil {
                mcSession.disconnect()
                assistant.stop()
                assistant = nil
            }
            nameTxt.enabled = true
            nameTxt.alpha = 1.0
            numberTxt.enabled = true
            numberTxt.alpha = 1.0
            isSharingVisible = false
        }
    }
    
    func picSwitchChanged(sender: UISwitch) {
        isSharePics = sender.on
    }
    func justRegionalSwitchChanged(sender: UISwitch) {
        isJustThisRegional = sender.on
    }
    
    func enableShareUI(isEnabled: Bool, isVisibleEnabled: Bool) {
        if isEnabled {
            if visibleSwitch.on {
                inviteBtn.enabled = true
                picsSwitch.enabled = true
                justRegionalSwitch.enabled = true
                
                justRegionalSwitch.alpha = 1.0
                justRegionalLbl.alpha = 1.0
                picsSwitch.alpha = 1.0
                picsLbl.alpha = 1.0
                inviteBtn.alpha = 1.0
            }
            
            if isVisibleEnabled {
                visibleLbl.alpha = 1.0
                visibleSwitch.alpha = 1.0
                visibleSwitch.enabled = true
            }
        } else {
//            shareBtn.alpha = 0.5
            justRegionalSwitch.alpha = 0.5
            justRegionalLbl.alpha = 0.5
            picsSwitch.alpha = 0.5
            picsLbl.alpha = 0.5
            inviteBtn.alpha = 0.5
            
//            shareBtn.enabled = false
            inviteBtn.enabled = false
            picsSwitch.enabled = false
            justRegionalSwitch.enabled = false
            
            if !isVisibleEnabled {
                visibleLbl.alpha = 0.5
                visibleSwitch.alpha = 0.5
                visibleSwitch.enabled = false
            } else if isVisibleEnabled {
                visibleLbl.alpha = 1.0
                visibleSwitch.alpha = 1.0
                visibleSwitch.enabled = true
            }
        }
    }
    
    func share() {
        let context : NSManagedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        
        var dictToSend = [String: AnyObject]()
        var regionalsDict = [String: [String: [String: [String: AnyObject]]]]()
        var pitTeamsDict = [String: AnyObject]()
        
        var regionalRequest = NSFetchRequest(entityName: "Regional")
        var regionalRequestErr : NSError?
        let regionalResults = context.executeFetchRequest(regionalRequest, error: &regionalRequestErr) as [Regional]
        if regionalRequestErr != nil { println(regionalRequestErr!.localizedDescription); return }
        for regional in regionalResults {
            var regionalDict = [String: [String: [String: AnyObject]]]()
            regionalsDict.updateValue(regionalDict, forKey: regional.name)
            
            for team in regional.teams.allObjects as [Team] {
                println("TEAM NUMBER: \(team.teamNumber)")
                var teamDict = [String: [String: AnyObject]]()
                regionalDict.updateValue(teamDict, forKey: "\(team.teamNumber)")
                
                println(regionalDict)
                
                for match in team.matches.allObjects as [Match] {
                    var toteStacks = Array<Array<Int>>()
                    for totestack in match.toteStacks.allObjects as [ToteStack] {
                        var convertedStack = [Int](count: 7, repeatedValue: 0)
                        convertedStack[0] = totestack.tote1.integerValue
                        convertedStack[1] = totestack.tote2.integerValue
                        convertedStack[2] = totestack.tote3.integerValue
                        convertedStack[3] = totestack.tote4.integerValue
                        convertedStack[4] = totestack.tote5.integerValue
                        convertedStack[5] = totestack.tote6.integerValue
                        convertedStack[6] = totestack.containerLvl.integerValue
                        toteStacks.append(convertedStack)
                    }
                    
                    var coopStacks = Array<Array<Int>>()
                    for coopstack in match.coopStacks.allObjects as [CoopStack] {
                        var convertedStack = [Int](count: 4, repeatedValue: 0)
                        convertedStack[0] = coopstack.tote1.integerValue
                        convertedStack[1] = coopstack.tote2.integerValue
                        convertedStack[2] = coopstack.tote3.integerValue
                        convertedStack[3] = coopstack.tote4.integerValue
                        coopStacks.append(convertedStack)
                    }
                    
                    var matchDict : [String: AnyObject] = [
                        "autoContainers": match.autoContainers.integerValue,
                        "autoTotes": match.autoTotes.integerValue,
                        "numCoopStacks": match.numCoopStacks.integerValue,
                        "numStacks": match.numStacks.integerValue,
                        "noodlesInContainer": match.noodlesInContainer.integerValue,
                        "penalty": match.penalty.integerValue,
                        "stacksKnockedOver": match.stacksKnockedOver.integerValue,
                        "noodlesInLandFill": match.noodlesInLandfill.integerValue,
                        "autoDrive": match.autoDrive.boolValue,
                        "autoStack": match.autoStack.boolValue,
                        "toteStacks": toteStacks,
                        "coopStacks": coopStacks,
                        "uniqueID": match.uniqueID.integerValue,
                        "matchNum": match.matchNum,
                        "scoutInitials": match.scoutInitials,
                        "scoutPosition": match.scoutPosition.integerValue,
                        "notes": match.notes ?? ""
                    ]
                    
                    teamDict.updateValue(matchDict, forKey: match.matchNum)
                }
            }
        }
        
        var pitTeamsRequest = NSFetchRequest(entityName: "PitTeam")
        var pitTeamsRequestErr : NSError?
        let pitTeamsResults = context.executeFetchRequest(pitTeamsRequest, error: &pitTeamsRequestErr)
        if pitTeamsRequestErr != nil { println(pitTeamsRequestErr!.localizedDescription); return }
        for pitTeam in pitTeamsResults as [PitTeam] {
            var pitTeamDict : [String : AnyObject] = [
                "teamNumber": pitTeam.teamNumber.integerValue,
                "teamName": pitTeam.teamName,
                "driveTrain": pitTeam.driveTrain,
                "stackTotes": pitTeam.stackTotes.boolValue,
                "stackerType": pitTeam.stackerType,
                "heightOfStack": pitTeam.heightOfStack.integerValue,
                "stackContainer": pitTeam.stackContainer.boolValue,
                "containerLevel": pitTeam.containerLevel.integerValue,
                "carryCapacity": pitTeam.carryCapacity.integerValue,
                "withContainer": pitTeam.withContainer.boolValue,
                "autoNone": pitTeam.autoNone.boolValue,
                "autoMobility": pitTeam.autoMobility.boolValue,
                "autoTote": pitTeam.autoTote.boolValue,
                "autoContainer": pitTeam.autoContainer.boolValue,
                "autoStack": pitTeam.autoStack.boolValue,
                "autoStepContainer": pitTeam.autoStepContainer.boolValue,
                "coop": pitTeam.coop,
                "noodles": pitTeam.noodles,
                "strategy": pitTeam.strategy,
                "additionalNotes": pitTeam.additionalNotes,
                "uniqueID": pitTeam.uniqueID.integerValue,
                "picture": pitTeam.picture
            ]
            pitTeamsDict.updateValue(pitTeamDict, forKey: "\(pitTeam.teamNumber)")
        }
        
        dictToSend.updateValue(regionalsDict, forKey: "Regionals")
//        dictToSend.updateValue(pitTeamsDict, forKey: "Pit Teams")
        
        func getFileURL(fileName: String) -> NSURL {
            let manager = NSFileManager.defaultManager()
            let dirURL = manager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil)
            return dirURL!.URLByAppendingPathComponent(fileName)
        }
        
        let filePath = getFileURL("sendData.dat").path!
        
        println(dictToSend)
        
        NSKeyedArchiver.archiveRootObject(dictToSend, toFile: filePath)
        
    }
    
    func closeShareView(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.shareView.transform = CGAffineTransformMakeScale(0.01, 0.01)
        }) { (completed) -> Void in
            self.shareView.removeFromSuperview()
            self.grayOutView.removeFromSuperview()
        }
    }
    
    // ********************************************** //
    // *********** Multipeer Connectivity *********** //
    // ********************************************** //
    
    let serviceType = "FRCScoutLong"
    
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var mcSession : MCSession!
    var peerID : MCPeerID!
    
    var isBrowsing = false
    
    func setUpMultipeer(){
        peerID = MCPeerID(displayName: "\(scoutFirstName!) - \(scoutTeamNum!)")
        mcSession = MCSession(peer: peerID)
        mcSession.delegate = self
        
        browser = MCBrowserViewController(serviceType: serviceType, session: mcSession)
        browser.delegate = self
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
            let context : NSManagedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
            
            println("SUCCESS!! RECEIVED \(data.length) BITS OF DATA!!!")
        })
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        switch state {
        case .Connected:
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if !self.isBrowsing {
                    let connectedAlertController = UIAlertController(title: "Connected!", message: "You've connected to \(peerID.displayName)!", preferredStyle: .Alert)
                    let confirmAction = UIAlertAction(title: "Cool", style: .Cancel, handler: nil)
                    connectedAlertController.addAction(confirmAction)
                    self.presentViewController(connectedAlertController, animated: true, completion: nil)
                }
                self.shareBtn.alpha = 1.0
                self.shareBtn.enabled = true
            })
            
        case .NotConnected:
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                println("Disconnected")
                if !self.isBrowsing {
                    let notConnectedAlertController = UIAlertController(title: "Disconnected!", message: "You've disconnected from \(peerID.displayName)!", preferredStyle: .Alert)
                    let confirmAction = UIAlertAction(title: "Aww man! Ok...", style: .Cancel, handler: nil)
                    notConnectedAlertController.addAction(confirmAction)
                    self.presentViewController(notConnectedAlertController, animated: true, completion: nil)
                }
                if self.mcSession.connectedPeers.count == 0 {
                    self.shareBtn.alpha = 0.5
//                    self.shareBtn.enabled = false
                }
            })
            
        default:
            return
        }
    }
    
    
    // Dumb required functions
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        // Dumb required function
    }
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        // Another dumb required function
    }
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        // Third and final dumb required function
    }
    
    
    
    // Change Regional
    
    @IBAction func changeRegionalPress(sender: AnyObject) {
        self.view.addSubview(grayOutView)
        regionalView = UIView(frame: CGRect(x: 94, y: 180, width: 580, height: 400))
        regionalView.backgroundColor = .whiteColor()
        regionalView.layer.cornerRadius = 10
        
        weekSelector = UISegmentedControl(items: ["All", "1", "2", "3", "4", "5", "6", "7+"])
        weekSelector.frame = CGRect(x: -52, y: 172, width: 216, height: 30)
        weekSelector.addTarget(self, action: Selector("weekSelectorChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        regionalView.addSubview(weekSelector)
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
        let weekSelectorLbl = UILabel(frame: CGRect(x: 39, y: 60, width: 36, height: 18))
        weekSelectorLbl.font = UIFont.systemFontOfSize(15)
        weekSelectorLbl.textAlignment = .Center
        weekSelectorLbl.text = "Week"
        weekSelectorLbl.adjustsFontSizeToFitWidth = true
        regionalView.addSubview(weekSelectorLbl)
        
        regionalPicker.frame = CGRect(x: 80, y: 80, width: 420, height: 216)
        regionalPicker.showsSelectionIndicator = true
        regionalPicker.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        regionalPicker.layer.cornerRadius = 5
        regionalView.addSubview(regionalPicker)
        if let regName = NSUserDefaults.standardUserDefaults().objectForKey(REGIONALSELECTEDKEY) as? String {
            regionalPicker.selectRow(find(allWeekRegionals[weekSelected], regName)!, inComponent: 0, animated: true)
        }
        let regionalPickerLbl = UILabel(frame: CGRect(x: regionalPicker.frame.origin.x, y: regionalPicker.frame.origin.y - 20, width: regionalPicker.frame.width, height: 18))
        regionalPickerLbl.font = UIFont.systemFontOfSize(15)
        regionalPickerLbl.textAlignment = .Center
        regionalPickerLbl.text = "Select Your Regional"
        regionalPickerLbl.adjustsFontSizeToFitWidth = true
        regionalView.addSubview(regionalPickerLbl)
        
        let regionalChangeSaveBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        regionalChangeSaveBtn.frame = CGRect(x: 250, y: regionalPicker.frame.origin.y + regionalPicker.frame.height + 45, width: 80, height: 35)
        regionalChangeSaveBtn.layer.cornerRadius = 5
        regionalChangeSaveBtn.backgroundColor = UIColor(red: 37.0/255, green: 149.0/255, blue: 212.0/255, alpha: 1.0)
        regionalChangeSaveBtn.titleLabel!.font = UIFont.boldSystemFontOfSize(18)
        regionalChangeSaveBtn.setTitle("Save", forState: .Normal)
        regionalChangeSaveBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        regionalChangeSaveBtn.addTarget(self, action: Selector("regionalSaveBtnPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        regionalView.addSubview(regionalChangeSaveBtn)
        
        var closeBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        closeBtn.frame = CGRect(x: regionalView.layer.frame.width - 60, y: 5, width: 50, height:20)
        closeBtn.addTarget(nil, action: Selector("closeRegionalView"), forControlEvents: UIControlEvents.TouchUpInside)
        closeBtn.setTitle("Close X", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        closeBtn.setTitleColor(UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1),forState: UIControlState.Normal)
        closeBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        regionalView.addSubview(closeBtn)
        
        regionalView.transform = CGAffineTransformMakeScale(0.01, 0.01)
        self.view.addSubview(regionalView)
        self.view.bringSubviewToFront(regionalView)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.regionalView.transform = CGAffineTransformIdentity
        })
    }
    
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
    
    func regionalSaveBtnPressed(){
        regionalName = allWeekRegionals[weekSelected][regionalPicker.selectedRowInComponent(0)]
        NSUserDefaults.standardUserDefaults().setObject(regionalName, forKey: REGIONALSELECTEDKEY)
        closeRegionalView()
    }
    
    func closeRegionalView(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.regionalView.transform = CGAffineTransformMakeScale(0.01, 0.01)
        }) { (completed) -> Void in
            self.regionalView.removeFromSuperview()
            self.grayOutView.removeFromSuperview()
        }
    }
    
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
    
    
    // General Text Fields
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nameTxt {
            numberTxt.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField{
        case nameTxt, numberTxt:
            visibleSwitch.enabled = false
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField{
        case nameTxt, numberTxt:
            if countElements(nameTxt.text) > 0 {
                scoutFirstName = nameTxt.text
            }
            if countElements(numberTxt.text) > 0 {
                scoutTeamNum = numberTxt.text
            }
            if countElements(nameTxt.text) > 0 && numberTxt.text.toInt() != nil && numberTxt.text.toInt() > 0 {
                self.enableShareUI(true, isVisibleEnabled: true)
                self.setUpMultipeer()
            } else {
                self.enableShareUI(false, isVisibleEnabled: false)
            }
        default:
            return
        }
    }


}
