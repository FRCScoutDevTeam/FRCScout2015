//
//  NextMatchView.swift
//  FRC Scout
//
//  Created by Louie Bertoncin on 3/26/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit
import CoreData

class NextMatchView: UIViewController, UITextFieldDelegate {
    
    var context : NSManagedObjectContext!
    
    @IBOutlet weak var red1TF: UITextField!
    @IBOutlet weak var red2TF: UITextField!
    @IBOutlet weak var red3TF: UITextField!
    
    @IBOutlet weak var blue1TF: UITextField!
    @IBOutlet weak var blue2TF: UITextField!
    @IBOutlet weak var blue3TF: UITextField!
    
    let lblWidth : CGFloat = 60
    let lblHeight : CGFloat = 35
    let yDiff : CGFloat = 110
    let yCoord : CGFloat = 274
    let lblFontSize : CGFloat = 25
    
    var red1AutoStrength : UILabel!
    var red1TeleopAvg : UILabel!
    var red1ToteAvg : UILabel!
    var red1ContainerAvg : UILabel!
    var red1AvgStacksKnockedOver : UILabel!
    var red1PenaltyAvg : UILabel!
    
    var red2AutoStrength : UILabel!
    var red2TeleopAvg : UILabel!
    var red2ToteAvg : UILabel!
    var red2ContainerAvg : UILabel!
    var red2AvgStacksKnockedOver : UILabel!
    var red2PenaltyAvg : UILabel!
    
    var red3AutoStrength : UILabel!
    var red3TeleopAvg : UILabel!
    var red3ToteAvg : UILabel!
    var red3ContainerAvg : UILabel!
    var red3AvgStacksKnockedOver : UILabel!
    var red3PenaltyAvg : UILabel!
    
    var blue1AutoStrength : UILabel!
    var blue1TeleopAvg : UILabel!
    var blue1ToteAvg : UILabel!
    var blue1ContainerAvg : UILabel!
    var blue1AvgStacksKnockedOver : UILabel!
    var blue1PenaltyAvg : UILabel!
    
    var blue2AutoStrength : UILabel!
    var blue2TeleopAvg : UILabel!
    var blue2ToteAvg : UILabel!
    var blue2ContainerAvg : UILabel!
    var blue2AvgStacksKnockedOver : UILabel!
    var blue2PenaltyAvg : UILabel!
    
    var blue3AutoStrength : UILabel!
    var blue3TeleopAvg : UILabel!
    var blue3ToteAvg : UILabel!
    var blue3ContainerAvg : UILabel!
    var blue3AvgStacksKnockedOver : UILabel!
    var blue3PenaltyAvg : UILabel!
    
    override func viewDidLoad() {
        let screenTapped = UITapGestureRecognizer(target: self, action: Selector("screenTapped:"))
        self.view.addGestureRecognizer(screenTapped)
        
        context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        
        backgroundSetup()
        
        red1ColumnSetup()
        red2ColumnSetup()
        red3ColumnSetup()
        blue1ColumnSetup()
        blue2ColumnSetup()
        blue3ColumnSetup()
    }
    
    func screenTapped(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func backgroundSetup() {
        let grayHighlight1 = UIView(frame: CGRect(x: 0, y: yCoord - 37, width: UIScreen.mainScreen().bounds.width, height: 110))
        grayHighlight1.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
        self.view.addSubview(grayHighlight1)
        self.view.sendSubviewToBack(grayHighlight1)
        
        let grayHighlight2 = UIView(frame: CGRect(x: 0, y: grayHighlight1.frame.origin.y + 220, width: UIScreen.mainScreen().bounds.width, height: 110))
        grayHighlight2.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
        self.view.addSubview(grayHighlight2)
        self.view.sendSubviewToBack(grayHighlight2)
        
        let grayHighlight3 = UIView(frame: CGRect(x: 0, y: grayHighlight2.frame.origin.y + 220, width: UIScreen.mainScreen().bounds.width, height: 110))
        grayHighlight3.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
        self.view.addSubview(grayHighlight3)
        self.view.sendSubviewToBack(grayHighlight3)
        
        let redView = UIView(frame: CGRect(x: 98, y: 63, width: 335, height: 912))
        redView.backgroundColor = UIColor.redColor()
        redView.alpha = 0.45
        self.view.addSubview(redView)
        self.view.sendSubviewToBack(redView)
        
        let blueView = UIView(frame: CGRect(x: redView.frame.origin.x + redView.frame.width, y: 63, width: 335, height: 912))
        blueView.backgroundColor = UIColor.blueColor()
        blueView.alpha = 0.45
        self.view.addSubview(blueView)
        self.view.sendSubviewToBack(blueView)
    }
    func red1ColumnSetup() {
        let xCoord : CGFloat = 128
        red1AutoStrength = UILabel(frame: CGRect(x: xCoord, y: yCoord, width: lblWidth, height: lblHeight))
        red1AutoStrength.textAlignment = .Center
        red1AutoStrength.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red1AutoStrength.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red1AutoStrength)
        red1TeleopAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff, width: lblWidth, height: lblHeight))
        red1TeleopAvg.textAlignment = .Center
        red1TeleopAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red1TeleopAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red1TeleopAvg)
        red1ToteAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*2, width: lblWidth, height: lblHeight))
        red1ToteAvg.textAlignment = .Center
        red1ToteAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red1ToteAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red1ToteAvg)
        red1ContainerAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*3, width: lblWidth, height: lblHeight))
        red1ContainerAvg.textAlignment = .Center
        red1ContainerAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red1ContainerAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red1ContainerAvg)
        red1AvgStacksKnockedOver = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*4, width: lblWidth, height: lblHeight))
        red1AvgStacksKnockedOver.textAlignment = .Center
        red1AvgStacksKnockedOver.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red1AvgStacksKnockedOver.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red1AvgStacksKnockedOver)
        red1PenaltyAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*5, width: lblWidth, height: lblHeight))
        red1PenaltyAvg.textAlignment = .Center
        red1PenaltyAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red1PenaltyAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red1PenaltyAvg)
    }
    func red2ColumnSetup() {
        let xCoord : CGFloat = 238
        red2AutoStrength = UILabel(frame: CGRect(x: xCoord, y: yCoord, width: lblWidth, height: lblHeight))
        red2AutoStrength.textAlignment = .Center
        red2AutoStrength.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red2AutoStrength.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red2AutoStrength)
        red2TeleopAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff, width: lblWidth, height: lblHeight))
        red2TeleopAvg.textAlignment = .Center
        red2TeleopAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red2TeleopAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red2TeleopAvg)
        red2ToteAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*2, width: lblWidth, height: lblHeight))
        red2ToteAvg.textAlignment = .Center
        red2ToteAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red2ToteAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red2ToteAvg)
        red2ContainerAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*3, width: lblWidth, height: lblHeight))
        red2ContainerAvg.textAlignment = .Center
        red2ContainerAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red2ContainerAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red2ContainerAvg)
        red2AvgStacksKnockedOver = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*4, width: lblWidth, height: lblHeight))
        red2AvgStacksKnockedOver.textAlignment = .Center
        red2AvgStacksKnockedOver.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red2AvgStacksKnockedOver.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red2AvgStacksKnockedOver)
        red2PenaltyAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*5, width: lblWidth, height: lblHeight))
        red2PenaltyAvg.textAlignment = .Center
        red2PenaltyAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red2PenaltyAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red2PenaltyAvg)
    }
    func red3ColumnSetup() {
        let xCoord : CGFloat = 348
        red3AutoStrength = UILabel(frame: CGRect(x: xCoord, y: yCoord, width: lblWidth, height: lblHeight))
        red3AutoStrength.textAlignment = .Center
        red3AutoStrength.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red3AutoStrength.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red3AutoStrength)
        red3TeleopAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff, width: lblWidth, height: lblHeight))
        red3TeleopAvg.textAlignment = .Center
        red3TeleopAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red3TeleopAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red3TeleopAvg)
        red3ToteAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*2, width: lblWidth, height: lblHeight))
        red3ToteAvg.textAlignment = .Center
        red3ToteAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red3ToteAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red3ToteAvg)
        red3ContainerAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*3, width: lblWidth, height: lblHeight))
        red3ContainerAvg.textAlignment = .Center
        red3ContainerAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red3ContainerAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red3ContainerAvg)
        red3AvgStacksKnockedOver = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*4, width: lblWidth, height: lblHeight))
        red3AvgStacksKnockedOver.textAlignment = .Center
        red3AvgStacksKnockedOver.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red3AvgStacksKnockedOver.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red3AvgStacksKnockedOver)
        red3PenaltyAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*5, width: lblWidth, height: lblHeight))
        red3PenaltyAvg.textAlignment = .Center
        red3PenaltyAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        red3PenaltyAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(red3PenaltyAvg)
    }
    func blue1ColumnSetup() {
        let xCoord : CGFloat = 458
        blue1AutoStrength = UILabel(frame: CGRect(x: xCoord, y: yCoord, width: lblWidth, height: lblHeight))
        blue1AutoStrength.textAlignment = .Center
        blue1AutoStrength.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue1AutoStrength.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue1AutoStrength)
        blue1TeleopAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff, width: lblWidth, height: lblHeight))
        blue1TeleopAvg.textAlignment = .Center
        blue1TeleopAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue1TeleopAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue1TeleopAvg)
        blue1ToteAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*2, width: lblWidth, height: lblHeight))
        blue1ToteAvg.textAlignment = .Center
        blue1ToteAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue1ToteAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue1ToteAvg)
        blue1ContainerAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*3, width: lblWidth, height: lblHeight))
        blue1ContainerAvg.textAlignment = .Center
        blue1ContainerAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue1ContainerAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue1ContainerAvg)
        blue1AvgStacksKnockedOver = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*4, width: lblWidth, height: lblHeight))
        blue1AvgStacksKnockedOver.textAlignment = .Center
        blue1AvgStacksKnockedOver.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue1AvgStacksKnockedOver.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue1AvgStacksKnockedOver)
        blue1PenaltyAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*5, width: lblWidth, height: lblHeight))
        blue1PenaltyAvg.textAlignment = .Center
        blue1PenaltyAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue1PenaltyAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue1PenaltyAvg)
    }
    func blue2ColumnSetup() {
        let xCoord : CGFloat = 568
        blue2AutoStrength = UILabel(frame: CGRect(x: xCoord, y: yCoord, width: lblWidth, height: lblHeight))
        blue2AutoStrength.textAlignment = .Center
        blue2AutoStrength.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue2AutoStrength.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue2AutoStrength)
        blue2TeleopAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff, width: lblWidth, height: lblHeight))
        blue2TeleopAvg.textAlignment = .Center
        blue2TeleopAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue2TeleopAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue2TeleopAvg)
        blue2ToteAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*2, width: lblWidth, height: lblHeight))
        blue2ToteAvg.textAlignment = .Center
        blue2ToteAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue2ToteAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue2ToteAvg)
        blue2ContainerAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*3, width: lblWidth, height: lblHeight))
        blue2ContainerAvg.textAlignment = .Center
        blue2ContainerAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue2ContainerAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue2ContainerAvg)
        blue2AvgStacksKnockedOver = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*4, width: lblWidth, height: lblHeight))
        blue2AvgStacksKnockedOver.textAlignment = .Center
        blue2AvgStacksKnockedOver.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue2AvgStacksKnockedOver.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue2AvgStacksKnockedOver)
        blue2PenaltyAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*5, width: lblWidth, height: lblHeight))
        blue2PenaltyAvg.textAlignment = .Center
        blue2PenaltyAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue2PenaltyAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue2PenaltyAvg)
    }
    func blue3ColumnSetup() {
        let xCoord : CGFloat = 678
        blue3AutoStrength = UILabel(frame: CGRect(x: xCoord, y: yCoord, width: lblWidth, height: lblHeight))
        blue3AutoStrength.textAlignment = .Center
        blue3AutoStrength.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue3AutoStrength.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue3AutoStrength)
        blue3TeleopAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff, width: lblWidth, height: lblHeight))
        blue3TeleopAvg.textAlignment = .Center
        blue3TeleopAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue3TeleopAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue3TeleopAvg)
        blue3ToteAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*2, width: lblWidth, height: lblHeight))
        blue3ToteAvg.textAlignment = .Center
        blue3ToteAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue3ToteAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue3ToteAvg)
        blue3ContainerAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*3, width: lblWidth, height: lblHeight))
        blue3ContainerAvg.textAlignment = .Center
        blue3ContainerAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue3ContainerAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue3ContainerAvg)
        blue3AvgStacksKnockedOver = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*4, width: lblWidth, height: lblHeight))
        blue3AvgStacksKnockedOver.textAlignment = .Center
        blue3AvgStacksKnockedOver.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue3AvgStacksKnockedOver.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue3AvgStacksKnockedOver)
        blue3PenaltyAvg = UILabel(frame: CGRect(x: xCoord, y: yCoord + yDiff*5, width: lblWidth, height: lblHeight))
        blue3PenaltyAvg.textAlignment = .Center
        blue3PenaltyAvg.font = UIFont.boldSystemFontOfSize(lblFontSize)
        blue3PenaltyAvg.adjustsFontSizeToFitWidth = true
        self.view.addSubview(blue3PenaltyAvg)
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text.toInt() == nil && countElements(textField.text) > 0 {
            let nonNumberAlert = UIAlertController(title: "Whoa there!", message: "You didn't enter a valid number!", preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "Ah, whoops", style: .Cancel, handler: nil)
            nonNumberAlert.addAction(confirmAction)
            self.presentViewController(nonNumberAlert, animated: true, completion: nil)
            return
        }
        switch textField{
        case red1TF:
            if countElements(textField.text) == 0 { red1Clear() }
            else { red1TeamSearch(textField.text.toInt()!) }
        case red2TF:
            if countElements(textField.text) == 0 { red2Clear() }
            else { red2TeamSearch(textField.text.toInt()!) }
        case red3TF:
            if countElements(textField.text) == 0 { red3Clear() }
            else { red3TeamSearch(textField.text.toInt()!) }
        case blue1TF:
            if countElements(textField.text) == 0 { blue1Clear() }
            else { blue1TeamSearch(textField.text.toInt()!) }
        case blue2TF:
            if countElements(textField.text) == 0 { blue2Clear() }
            else { blue2TeamSearch(textField.text.toInt()!) }
        case blue3TF:
            if countElements(textField.text) == 0 { blue3Clear() }
            else { blue3TeamSearch(textField.text.toInt()!) }
        default:
            return
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        switch textField{
        case red1TF:
            red2TF.becomeFirstResponder()
        case red2TF:
            red3TF.becomeFirstResponder()
        case red3TF:
            blue1TF.becomeFirstResponder()
        case blue1TF:
            blue2TF.becomeFirstResponder()
        case blue2TF:
            blue3TF.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    
    func red1TeamSearch(teamNum: Int) {
        let teamFetchRequest = NSFetchRequest(entityName: "Team")
        teamFetchRequest.predicate = NSPredicate(format: "teamNumber = \(teamNum)")
        let results = context.executeFetchRequest(teamFetchRequest, error: nil)
        if results!.count == 0 {
            teamNotFoundAlert(red1TF)
            return
        }
        let foundTeam = results!.first as Team
        
        var formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        red1AutoStrength.text = formatter.stringFromNumber(foundTeam.autoStrength)
        red1TeleopAvg.text = formatter.stringFromNumber(foundTeam.teleAvg)
        red1ToteAvg.text = formatter.stringFromNumber(foundTeam.toteAvg)
        red1ContainerAvg.text = formatter.stringFromNumber(foundTeam.containerAvg)
        red1AvgStacksKnockedOver.text = formatter.stringFromNumber(foundTeam.stacksKnockedOverAvg)
        red1PenaltyAvg.text = formatter.stringFromNumber(foundTeam.penaltyAvg)
    }
    func red1Clear() {
        red1AutoStrength.text = ""
        red1TeleopAvg.text = ""
        red1ToteAvg.text = ""
        red1ContainerAvg.text = ""
        red1AvgStacksKnockedOver.text = ""
        red1PenaltyAvg.text = ""
    }
    func red2TeamSearch(teamNum: Int) {
        let teamFetchRequest = NSFetchRequest(entityName: "Team")
        teamFetchRequest.predicate = NSPredicate(format: "teamNumber = \(teamNum)")
        let results = context.executeFetchRequest(teamFetchRequest, error: nil)
        if results!.count == 0 {
            teamNotFoundAlert(red2TF)
            return
        }
        let foundTeam = results!.first as Team
        
        var formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        red2AutoStrength.text = formatter.stringFromNumber(foundTeam.autoStrength)
        red2TeleopAvg.text = formatter.stringFromNumber(foundTeam.teleAvg)
        red2ToteAvg.text = formatter.stringFromNumber(foundTeam.toteAvg)
        red2ContainerAvg.text = formatter.stringFromNumber(foundTeam.containerAvg)
        red2AvgStacksKnockedOver.text = formatter.stringFromNumber(foundTeam.stacksKnockedOverAvg)
        red2PenaltyAvg.text = formatter.stringFromNumber(foundTeam.penaltyAvg)
    }
    func red2Clear() {
        red2AutoStrength.text = ""
        red2TeleopAvg.text = ""
        red2ToteAvg.text = ""
        red2ContainerAvg.text = ""
        red2AvgStacksKnockedOver.text = ""
        red2PenaltyAvg.text = ""
    }
    func red3TeamSearch(teamNum: Int) {
        let teamFetchRequest = NSFetchRequest(entityName: "Team")
        teamFetchRequest.predicate = NSPredicate(format: "teamNumber = \(teamNum)")
        let results = context.executeFetchRequest(teamFetchRequest, error: nil)
        if results!.count == 0 {
            teamNotFoundAlert(red3TF)
            return
        }
        let foundTeam = results!.first as Team
        
        var formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        red3AutoStrength.text = formatter.stringFromNumber(foundTeam.autoStrength)
        red3TeleopAvg.text = formatter.stringFromNumber(foundTeam.teleAvg)
        red3ToteAvg.text = formatter.stringFromNumber(foundTeam.toteAvg)
        red3ContainerAvg.text = formatter.stringFromNumber(foundTeam.containerAvg)
        red3AvgStacksKnockedOver.text = formatter.stringFromNumber(foundTeam.stacksKnockedOverAvg)
        red3PenaltyAvg.text = formatter.stringFromNumber(foundTeam.penaltyAvg)
    }
    func red3Clear() {
        red3AutoStrength.text = ""
        red3TeleopAvg.text = ""
        red3ToteAvg.text = ""
        red3ContainerAvg.text = ""
        red3AvgStacksKnockedOver.text = ""
        red3PenaltyAvg.text = ""
    }
    func blue1TeamSearch(teamNum: Int) {
        let teamFetchRequest = NSFetchRequest(entityName: "Team")
        teamFetchRequest.predicate = NSPredicate(format: "teamNumber = \(teamNum)")
        let results = context.executeFetchRequest(teamFetchRequest, error: nil)
        if results!.count == 0 {
            teamNotFoundAlert(blue1TF)
            return
        }
        let foundTeam = results!.first as Team
        
        var formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        blue1AutoStrength.text = formatter.stringFromNumber(foundTeam.autoStrength)
        blue1TeleopAvg.text = formatter.stringFromNumber(foundTeam.teleAvg)
        blue1ToteAvg.text = formatter.stringFromNumber(foundTeam.toteAvg)
        blue1ContainerAvg.text = formatter.stringFromNumber(foundTeam.containerAvg)
        blue1AvgStacksKnockedOver.text = formatter.stringFromNumber(foundTeam.stacksKnockedOverAvg)
        blue1PenaltyAvg.text = formatter.stringFromNumber(foundTeam.penaltyAvg)
    }
    func blue1Clear() {
        blue1AutoStrength.text = ""
        blue1TeleopAvg.text = ""
        blue1ToteAvg.text = ""
        blue1ContainerAvg.text = ""
        blue1AvgStacksKnockedOver.text = ""
        blue1PenaltyAvg.text = ""
    }
    func blue2TeamSearch(teamNum: Int) {
        let teamFetchRequest = NSFetchRequest(entityName: "Team")
        teamFetchRequest.predicate = NSPredicate(format: "teamNumber = \(teamNum)")
        let results = context.executeFetchRequest(teamFetchRequest, error: nil)
        if results!.count == 0 {
            teamNotFoundAlert(blue2TF)
            return
        }
        let foundTeam = results!.first as Team
        
        var formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        blue2AutoStrength.text = formatter.stringFromNumber(foundTeam.autoStrength)
        blue2TeleopAvg.text = formatter.stringFromNumber(foundTeam.teleAvg)
        blue2ToteAvg.text = formatter.stringFromNumber(foundTeam.toteAvg)
        blue2ContainerAvg.text = formatter.stringFromNumber(foundTeam.containerAvg)
        blue2AvgStacksKnockedOver.text = formatter.stringFromNumber(foundTeam.stacksKnockedOverAvg)
        blue2PenaltyAvg.text = formatter.stringFromNumber(foundTeam.penaltyAvg)
    }
    func blue2Clear() {
        blue2AutoStrength.text = ""
        blue2TeleopAvg.text = ""
        blue2ToteAvg.text = ""
        blue2ContainerAvg.text = ""
        blue2AvgStacksKnockedOver.text = ""
        blue2PenaltyAvg.text = ""
    }
    func blue3TeamSearch(teamNum: Int) {
        let teamFetchRequest = NSFetchRequest(entityName: "Team")
        teamFetchRequest.predicate = NSPredicate(format: "teamNumber = \(teamNum)")
        let results = context.executeFetchRequest(teamFetchRequest, error: nil)
        if results!.count == 0 {
            teamNotFoundAlert(blue3TF)
            return
        }
        let foundTeam = results!.first as Team
        
        var formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        blue3AutoStrength.text = formatter.stringFromNumber(foundTeam.autoStrength)
        blue3TeleopAvg.text = formatter.stringFromNumber(foundTeam.teleAvg)
        blue3ToteAvg.text = formatter.stringFromNumber(foundTeam.toteAvg)
        blue3ContainerAvg.text = formatter.stringFromNumber(foundTeam.containerAvg)
        blue3AvgStacksKnockedOver.text = formatter.stringFromNumber(foundTeam.stacksKnockedOverAvg)
        blue3PenaltyAvg.text = formatter.stringFromNumber(foundTeam.penaltyAvg)
    }
    func blue3Clear() {
        blue3AutoStrength.text = ""
        blue3TeleopAvg.text = ""
        blue3ToteAvg.text = ""
        blue3ContainerAvg.text = ""
        blue3AvgStacksKnockedOver.text = ""
        blue3PenaltyAvg.text = ""
    }
    
    func teamNotFoundAlert(badTF: UITextField) {
        let notFoundAlert = UIAlertController(title: "Oh no!", message: "\(badTF.text) wasn't found in the database!", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "Aw man!", style: .Cancel) { (action) -> Void in
            badTF.text = ""
            badTF.becomeFirstResponder()
        }
        notFoundAlert.addAction(confirmAction)
        self.presentViewController(notFoundAlert, animated: true, completion: nil)
    }
    
}



