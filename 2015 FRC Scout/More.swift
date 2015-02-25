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
    var progressIndicator : UIProgressView!


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
        shareBtn.alpha = 0.5
        shareBtn.enabled = false
        if mcSession != nil && mcSession.connectedPeers.count > 0 {
            shareBtn.alpha = 1.0
            shareBtn.enabled = true
        }
        shareView.addSubview(shareBtn)

        progressIndicator = UIProgressView(progressViewStyle: UIProgressViewStyle.Bar)
        progressIndicator.frame = CGRect(x: shareView.frame.width/2 - 150, y: shareBtn.frame.origin.y + shareBtn.frame.height + 30, width: 300, height: 2)
        progressIndicator.alpha = 0
        shareView.addSubview(progressIndicator)

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
        if NSUserDefaults.standardUserDefaults().objectForKey(REGIONALSELECTEDKEY) == nil {
            justRegionalSwitch.setOn(false, animated: true)

            let justRegionalAlertController = UIAlertController(title: "Whoa there!", message: "You never set your regional!\nWould you like to?", preferredStyle: .Alert)
            let affirmativeAction = UIAlertAction(title: "Why yes I do!", style: .Default, handler: { (action) -> Void in
                self.closeShareView()
                self.changeRegionalPress(self.changeRegionalBtn)
            })
            justRegionalAlertController.addAction(affirmativeAction)
            let cancelAction = UIAlertAction(title: "Nah, I'd rather not", style: .Cancel, handler: nil)
            justRegionalAlertController.addAction(cancelAction)
            self.presentViewController(justRegionalAlertController, animated: true, completion: nil)
        }
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
            shareBtn.alpha = 0.5
            justRegionalSwitch.alpha = 0.5
            justRegionalLbl.alpha = 0.5
            picsSwitch.alpha = 0.5
            picsLbl.alpha = 0.5
            inviteBtn.alpha = 0.5
            shareBtn.enabled = false
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

        var dictToSend = NSMutableDictionary()
        var regionalsDict = NSMutableDictionary()
        var pitTeamsDict = NSMutableDictionary()

        var regionalRequest = NSFetchRequest(entityName: "Regional")
        if isJustThisRegional {
            regionalRequest.predicate = NSPredicate(format: "name = %@", NSUserDefaults.standardUserDefaults().objectForKey(REGIONALSELECTEDKEY) as String!)
        }
        var regionalRequestErr : NSError?
        let regionalResults = context.executeFetchRequest(regionalRequest, error: &regionalRequestErr) as [Regional]
        if regionalRequestErr != nil { println(regionalRequestErr!.localizedDescription); return }
        for regional in regionalResults {
            regionalsDict[regional.name] = NSMutableDictionary()

            for team in regional.teams.allObjects as [Team] {
                println("TEAM NUMBER: \(team.teamNumber)")
                (regionalsDict[regional.name] as NSMutableDictionary)[team.teamNumber] = NSMutableDictionary()

                for match in team.matches.allObjects as [Match] {
                    var toteStacks = Array<Array<NSNumber>>()
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

                    var coopStacks = Array<Array<NSNumber>>()
                    for coopstack in match.coopStacks.allObjects as [CoopStack] {
                        var convertedStack = [Int](count: 4, repeatedValue: 0)
                        convertedStack[0] = coopstack.tote1.integerValue
                        convertedStack[1] = coopstack.tote2.integerValue
                        convertedStack[2] = coopstack.tote3.integerValue
                        convertedStack[3] = coopstack.tote4.integerValue
                        coopStacks.append(convertedStack)
                    }

                    var matchDict : NSDictionary = [
                        "autoContainers": match.autoContainers.integerValue,
                        "autoTotes": match.autoTotes.integerValue,
                        "numCoopStacks": match.numCoopStacks,
                        "numStacks": match.numStacks.integerValue,
                        "noodlesInContainer": match.noodlesInContainer.integerValue,
                        "penalty": match.penalty.integerValue,
                        "stacksKnockedOver": match.stacksKnockedOver.integerValue,
                        "noodlesInLandFill": match.noodlesInLandfill.integerValue,
                        "autoDrive": match.autoDrive.boolValue,
                        "autoStack": match.autoStack.boolValue,
                        "toteStacks": toteStacks as NSArray,
                        "coopStacks": coopStacks as NSArray,
                        "uniqueID": match.uniqueID,
                        "matchNum": match.matchNum,
                        "scoutInitials": match.scoutInitials,
                        "scoutPosition": match.scoutPosition,
                        "notes": match.notes ?? ""
                    ]

                    ((regionalsDict[regional.name] as NSMutableDictionary)[team.teamNumber] as NSMutableDictionary)[match.matchNum] = matchDict
                }
            }
        }

        var pitTeamsRequest = NSFetchRequest(entityName: "PitTeam")
        var pitTeamsRequestErr : NSError?
        let pitTeamsResults = context.executeFetchRequest(pitTeamsRequest, error: &pitTeamsRequestErr)
        if pitTeamsRequestErr != nil { println(pitTeamsRequestErr!.localizedDescription); return }
        for pitTeam in pitTeamsResults as [PitTeam] {
            var picture : NSData!
            if self.isSharePics {
                picture = pitTeam.picture
            } else {
                picture = nil
            }
            var pitTeamDict : NSDictionary = [
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
                "picture": picture
            ]
            pitTeamsDict["\(pitTeam.teamNumber)"] = pitTeamDict
        }

        dictToSend["Regionals"] = regionalsDict
        dictToSend["PitTeams"] = pitTeamsDict

        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        let documentsDirectory = paths[0]
        let path = documentsDirectory.URLByAppendingPathComponent("sendData")

        if NSFileManager.defaultManager().fileExistsAtPath(path.path!) {
            NSFileManager.defaultManager().removeItemAtURL(path, error: nil)
        }

        let sendData = NSKeyedArchiver.archivedDataWithRootObject(dictToSend)
        if sendData.length == 0 {
            println("Send Data is empty")
            return
        } else {
            println(sendData.length)
        }

        var writeErr : NSError?
        if !sendData.writeToURL(path, options: nil, error: &writeErr) {
            println(writeErr!.localizedDescription)
            return
        }

        for peer in mcSession.connectedPeers as [MCPeerID] {
            self.sendDataFromUrl(path, peer: peer)
        }
    }

    func sendDataFromUrl(url: NSURL, peer: MCPeerID) {
        progressIndicator.alpha = 1.0
        var progress : NSProgress = mcSession!.sendResourceAtURL(url, withName: "sendData", toPeer: peer) { (sendError) -> Void in
            if sendError != nil {
                println(sendError)
            } else {
                println("Sent all data to \(peer.displayName)!")
            }
        }

        progress.addObserver(self, forKeyPath: kProgressCancelledKeyPath, options: NSKeyValueObservingOptions.New, context: nil)
        progress.addObserver(self, forKeyPath: kProgressCompletedUnitCountKeyPath, options: NSKeyValueObservingOptions.New, context: nil)
        progressIndicator.tintColor = .greenColor()
        progressIndicator.progress = Float(progress.fractionCompleted)
    }
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        var progress : NSProgress = object as NSProgress
        switch keyPath {
        case kProgressCancelledKeyPath:
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.progressIndicator.progress = 0
            })
        case kProgressCompletedUnitCountKeyPath:
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.progressIndicator.progress = Float(progress.fractionCompleted)
            })

            if progress.completedUnitCount == progress.totalUnitCount {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.progressIndicator.alpha = 0
                })
            }
        default:
            return
        }
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

    var kProgressCancelledKeyPath = "cancelled";

    var kProgressCompletedUnitCountKeyPath = "completedUnitCount";


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
                    self.shareBtn.enabled = false
                }
            })

        default:
            return
        }
    }

    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        progress.addObserver(self, forKeyPath: kProgressCancelledKeyPath, options: NSKeyValueObservingOptions.New, context: nil)
        progress.addObserver(self, forKeyPath: kProgressCompletedUnitCountKeyPath, options: NSKeyValueObservingOptions.New, context: nil)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.progressIndicator.alpha = 1.0
            self.progressIndicator.tintColor = UIColor(red: 51.0/255.0, green:153.0/255.0, blue:255.0/255.0, alpha:1.0)
        })
    }
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        let documentsDirectory = paths[0]
        let receivedDataURL = documentsDirectory.URLByAppendingPathComponent("receivedData")

        if NSFileManager.defaultManager().fileExistsAtPath(receivedDataURL.path!) {
            NSFileManager.defaultManager().removeItemAtURL(receivedDataURL, error: nil)
        }
        var moveErr: NSError?
        NSFileManager.defaultManager().moveItemAtURL(localURL, toURL: receivedDataURL, error: &moveErr)
        if moveErr != nil {
            println(moveErr!.localizedDescription)
        }

        updateCoreDataFromTransfer()
    }
    func updateCoreDataFromTransfer() {
        let context : NSManagedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!

        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        let documentsDirectory = paths[0]
        let receivedDataURL = documentsDirectory.URLByAppendingPathComponent("receivedData")

        let receivedData = NSData(contentsOfURL: receivedDataURL)
        let receivedDataDict = NSKeyedUnarchiver.unarchiveObjectWithData(receivedData!) as NSDictionary

        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            for (rgnlName, regional) in receivedDataDict["Regionals"] as NSDictionary {
                println(rgnlName as String)

                let savedRegional = Regional.createRegional(rgnlName as String, context: context)
                for (tmName, team) in regional as NSDictionary {
                    let teamNum = tmName as Int
                    println("Team Number: \(teamNum)")

                    let masterTeam = MasterTeam.createMasterTeam(teamNum, context: context)
                    let savedTeam = Team.createTeam(teamNum, regional: savedRegional, masterTeam: masterTeam, context: context)
                    for (mtchNum, match) in team as NSDictionary {
                        let matchDict = match as NSDictionary

                        println(mtchNum as String)

                        let receivedToteStacks = matchDict["toteStacks"] as [[Int]]
                        let receivedCoopStacks = matchDict["coopStacks"] as [[Int]]
                        var toteStackData = [ToteStack]()
                        var coopStackData = [CoopStack]()
                        for stack in receivedToteStacks {
                            var newToteStack: ToteStack = NSEntityDescription.insertNewObjectForEntityForName("ToteStack", inManagedObjectContext: context) as ToteStack
                            newToteStack.tote1 = stack[0]
                            newToteStack.tote2 = stack[1]
                            newToteStack.tote3 = stack[2]
                            newToteStack.tote4 = stack[3]
                            newToteStack.tote5 = stack[4]
                            newToteStack.tote6 = stack[5]
                            newToteStack.containerLvl = stack[6]
                            toteStackData.append(newToteStack)
                        }
                        for stack in receivedCoopStacks {
                            var newCoopStack: CoopStack = NSEntityDescription.insertNewObjectForEntityForName("CoopStack", inManagedObjectContext: context) as CoopStack
                            newCoopStack.tote1 = stack[0]
                            newCoopStack.tote2 = stack[1]
                            newCoopStack.tote3 = stack[2]
                            newCoopStack.tote4 = stack[3]
                            coopStackData.append(newCoopStack)
                        }

                        var saveMatchDict = [
                            "autoContainers": matchDict["autoContainers"] as Int,
                            "autoTotes": matchDict["autoTotes"] as Int,
                            "numCoopStacks": matchDict["numCoopStacks"] as Int,
                            "numStacks": matchDict["numStacks"] as Int,
                            "noodlesInContainer": matchDict["noodlesInContainer"] as Int,
                            "penalty": matchDict["penalty"] as Int,
                            "stacksKnockedOver": matchDict["stacksKnockedOver"] as Int,
                            "noodlesInLandFill": matchDict["noodlesInLandFill"] as Int,
                            "autoDrive": matchDict["autoDrive"] as Int,
                            "autoStack": matchDict["autoStack"] as Bool,
                            "toteStacks": NSSet(array: toteStackData),
                            "coopStacks": NSSet(array: coopStackData),
                            "uniqueID": matchDict["uniqueID"] as Int,
                            "matchNum": matchDict["matchNum"] as String,
                            "scoutInitials": matchDict["scoutInitials"] as String,
                            "scoutPosition": matchDict["scoutPosition"] as Int,
                            "notes": matchDict["notes"] as String]

                        var match = Match.createMatch(saveMatchDict, m_team: savedTeam, context: context)
                    }
                }
            }

            for (pitTeamName, pitTeam) in receivedDataDict["PitTeams"] as NSDictionary {
                let pitTeamDict = pitTeam as NSDictionary

                let masterTeam = MasterTeam.createMasterTeam(pitTeamDict["teamNumber"] as Int, context: context)

                var pitDict: [String:AnyObject] = [
                    "teamNumber": pitTeamDict["teamNumber"] as Int,
                    "teamName": pitTeamDict["teamName"] as String,
                    "driveTrain": pitTeamDict["driveTrain"] as String,
                    "stackTotes": pitTeamDict["stackTotes"] as Bool,
                    "stackerType": pitTeamDict["stackerType"] as String,
                    "heightOfStack": pitTeamDict["heightOfStack"] as Int,
                    "stackContainer": pitTeamDict["stackContainer"] as Bool,
                    "containerLevel": pitTeamDict["containerLevel"] as Int,
                    "carryCapacity": pitTeamDict["carryCapacity"] as Int,
                    "withContainer": pitTeamDict["withContainer"] as Bool,
                    "autoNone": pitTeamDict["autoNone"] as Bool,
                    "autoMobility": pitTeamDict["autoMobility"] as Bool,
                    "autoTote": pitTeamDict["autoTote"] as Bool,
                    "autoContainer": pitTeamDict["autoContainer"] as Bool,
                    "autoStack": pitTeamDict["autoStack"] as Bool,
                    "autoStepContainer": pitTeamDict["autoStepContainer"] as Bool,
                    "coop": pitTeamDict["coop"] as String,
                    "noodles": pitTeamDict["noodles"] as String,
                    "strategy": pitTeamDict["strategy"] as String,
                    "additionalNotes": pitTeamDict["additionalNotes"] as String,
                    "uniqueID": pitTeamDict["uniqueID"] as Int,
                    "picture": pitTeamDict["picture"] as NSData]

                var newPitTeam = PitTeam.createPitTeam(pitDict, masterTeam: masterTeam, context: context)
            }
        })
    }

    // Dumb required functions
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        // A dumb required function
    }
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        // Dumb required function
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

    @IBAction func deleteMatchesPressed(sender: AnyObject) {
        let alertController = UIAlertController(title: "All Match Data will be lost", message: "Are you Sure?", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            return
        }
        alertController.addAction(cancelAction)

        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            let context: NSManagedObjectContext = appDel.managedObjectContext!
            var entities = ["Team","PitTeam","MasterTeam","Regional"]
            for i in entities {
                var request = NSFetchRequest(entityName: i)
                var results:NSArray = context.executeFetchRequest(request, error: nil)!
                if (results.count > 0){
                    for res in results {
                        context.deleteObject(res as NSManagedObject)
                    }
                }
            }
        }
        alertController.addAction(OKAction)

        self.presentViewController(alertController, animated: true, completion: nil)
    }


}
