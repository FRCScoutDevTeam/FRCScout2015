//
//  more.swift
//  2015 FRC Scout
//
//  Created by David Swed on 1/9/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit

class More: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
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
    var visibleSwitch : UISwitch?
    var picsSwitch : UISwitch?
    var justRegionalSwitch : UISwitch?
    var inviteBtn : UIButton?
    var picsLbl : UILabel?
    var justRegionalLbl : UILabel?
    var shareBtn : UIButton?
    var nameTxt : UITextField?
    var numberTxt : UITextField?
    
    
    
    @IBOutlet weak var changeRegionalBtn: UIButton!
    @IBOutlet weak var shareMatchesBtn: UIButton!
    @IBOutlet weak var deleteAllMatchesBtn: UIButton!
    var regionalName : String!

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
        
        weekSelected = NSUserDefaults.standardUserDefaults().integerForKey(WEEKSELECTEDKEY) ?? 0
        
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
        
        var shareFrame = CGRect(x: 94, y: 130, width: 580, height: 400)
        var xC1: CGFloat = shareFrame.width * 0.3   //center x of the first column of items
        var xC2: CGFloat = shareFrame.width * 0.7   //center x of the second column of items
        var yStart: CGFloat = shareFrame.height * 0.15   //starting height of first row
        var ySpacing: CGFloat = 30
        var labelWidth: CGFloat = 120
        var labelHeight: CGFloat = 25
        var txtWidth: CGFloat = 90
        var txtHeight: CGFloat = 25
        var switchWidth: CGFloat = 35
        var switchHeight: CGFloat = 15
        
        self.view.addSubview(grayOutView)
        shareView = UIView(frame: shareFrame)
        shareView.backgroundColor = .whiteColor()
        shareView.layer.cornerRadius = 10
        
        var closeBtn = UIButton(frame: CGRect(x: shareView.layer.frame.width - 60, y: 5, width: 50, height:20))
        closeBtn.addTarget(nil, action: Selector("closeShareView"), forControlEvents: UIControlEvents.TouchUpInside)
        closeBtn.setTitle("Close X", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        closeBtn.setTitleColor(UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1),forState: UIControlState.Normal)
        closeBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        shareView.addSubview(closeBtn)
        
        let shareLbl = UILabel(frame: CGRect(x: shareFrame.width/2 - 75, y: 20, width: 150, height: 30))
        shareLbl.font = UIFont.systemFontOfSize(20)
        shareLbl.textAlignment = .Center
        shareLbl.text = "Share Matches"
        shareView.addSubview(shareLbl)
        
        let nameLbl = UILabel(frame: CGRect(x: xC1 - labelWidth/2, y: yStart, width: labelWidth, height: labelHeight))
        nameLbl.font = UIFont.systemFontOfSize(15)
        nameLbl.textAlignment = .Center
        nameLbl.text = "First Name"
        nameLbl.adjustsFontSizeToFitWidth = true
        shareView.addSubview(nameLbl)
        
        nameTxt = UITextField(frame: CGRect(x: xC1 - txtWidth/2, y: yStart + ySpacing*1, width: txtWidth, height: txtHeight))
        nameTxt?.font = UIFont.systemFontOfSize(15)
        nameTxt?.textAlignment = .Center
        nameTxt?.placeholder = "Name..."
        nameTxt?.delegate = self
        nameTxt?.layer.borderWidth = 1
        nameTxt?.layer.borderColor = UIColor(white: 0.7, alpha: 0.7).CGColor
        nameTxt?.layer.cornerRadius = 5
        shareView.addSubview(nameTxt!)
        
        let numberLbl = UILabel(frame: CGRect(x: xC2 - labelWidth/2, y: yStart, width: labelWidth, height: labelHeight))
        numberLbl.font = UIFont.systemFontOfSize(15)
        numberLbl.textAlignment = .Center
        numberLbl.text = "Team Number"
        numberLbl.adjustsFontSizeToFitWidth = true
        shareView.addSubview(numberLbl)
        
        numberTxt = UITextField(frame: CGRect(x: xC2 - txtWidth/2, y: yStart + ySpacing*1, width: txtWidth, height: txtHeight))
        numberTxt?.font = UIFont.systemFontOfSize(15)
        numberTxt?.textAlignment = .Center
        numberTxt?.placeholder = "Number..."
        numberTxt?.delegate = self
        numberTxt?.layer.borderWidth = 1
        numberTxt?.layer.cornerRadius = 5
        numberTxt?.layer.borderColor = UIColor(white: 0.7, alpha: 0.7).CGColor
        shareView.addSubview(numberTxt!)
        
        inviteBtn = UIButton(frame: CGRect(x: xC1 - 65, y: yStart + ySpacing*4, width: 130, height: txtHeight))
        inviteBtn?.titleLabel?.font = UIFont.systemFontOfSize(15)
        inviteBtn?.setTitle("Invite To Party", forState: UIControlState.Normal)
        inviteBtn?.titleLabel?.textAlignment = .Center
        inviteBtn?.layer.cornerRadius = 5
        inviteBtn?.addTarget(nil, action: Selector("inviteToParty"), forControlEvents: UIControlEvents.TouchUpInside)
        inviteBtn?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        inviteBtn?.backgroundColor = UIColor(red: 0.1, green: 0.3, blue: 0.9, alpha: 0.7)
        inviteBtn?.alpha = 0.3
        inviteBtn?.enabled = false
        shareView.addSubview(inviteBtn!)
        
        let visibleLbl = UILabel(frame: CGRect(x: xC2 - labelWidth/2, y: yStart + ySpacing*3, width: labelWidth, height: labelHeight))
        visibleLbl.font = UIFont.systemFontOfSize(15)
        visibleLbl.textAlignment = .Center
        visibleLbl.text = "Visible"
        visibleLbl.adjustsFontSizeToFitWidth = true
        shareView.addSubview(visibleLbl)
        
        visibleSwitch = UISwitch( frame: CGRect(x: xC2 - switchWidth/2, y: yStart + ySpacing * 4 + 5, width: switchWidth, height: switchHeight))
        visibleSwitch?.on = false
        visibleSwitch?.addTarget(nil, action: Selector("visibleSwitched"), forControlEvents: UIControlEvents.TouchUpInside)
        shareView.addSubview(visibleSwitch!)
        
        picsLbl = UILabel(frame: CGRect(x: xC1 - labelWidth/2, y: yStart + ySpacing*6, width: labelWidth, height: labelHeight))
        picsLbl?.font = UIFont.systemFontOfSize(15)
        picsLbl?.textAlignment = .Center
        picsLbl?.text = "Share Pics"
        picsLbl?.adjustsFontSizeToFitWidth = true
        picsLbl?.alpha = 0.3
        shareView.addSubview(picsLbl!)
        
        picsSwitch = UISwitch( frame: CGRect(x: xC1 - switchWidth/2, y: yStart + ySpacing * 7 + 5, width: switchWidth, height: switchHeight))
        picsSwitch?.on = false
        picsSwitch?.alpha = 0.3
        picsSwitch?.enabled = false
        shareView.addSubview(picsSwitch!)
        
        justRegionalLbl = UILabel(frame: CGRect(x: xC2 - labelWidth/2, y: yStart + ySpacing*6, width: labelWidth, height: labelHeight))
        justRegionalLbl?.font = UIFont.systemFontOfSize(15)
        justRegionalLbl?.textAlignment = .Center
        justRegionalLbl?.text = "Just This Regional"
        justRegionalLbl?.adjustsFontSizeToFitWidth = true
        justRegionalLbl?.alpha = 0.3
        shareView.addSubview(justRegionalLbl!)
        
        justRegionalSwitch = UISwitch( frame: CGRect(x: xC2 - switchWidth/2, y: yStart + ySpacing * 7 + 5, width: switchWidth, height: switchHeight))
        justRegionalSwitch?.on = false
        justRegionalSwitch?.alpha = 0.3
        justRegionalSwitch?.enabled = false
        shareView.addSubview(justRegionalSwitch!)
        
        shareBtn = UIButton(frame: CGRect(x: shareFrame.width/2 - 60, y: yStart + ySpacing*9, width: 120, height: 30))
        shareBtn?.titleLabel?.font = UIFont.systemFontOfSize(20)
        shareBtn?.setTitle("Share", forState: UIControlState.Normal)
        shareBtn?.titleLabel?.textAlignment = .Center
        shareBtn?.layer.cornerRadius = 5
        shareBtn?.addTarget(nil, action: Selector("share"), forControlEvents: UIControlEvents.TouchUpInside)
        shareBtn?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        shareBtn?.backgroundColor = UIColor(red: 0.1, green: 0.3, blue: 0.9, alpha: 0.7)
        shareBtn?.alpha = 0.3
        shareBtn?.enabled = false
        shareView.addSubview(shareBtn!)
        
        shareView.transform = CGAffineTransformMakeScale(0.01, 0.01)
        self.view.addSubview(shareView)
        self.view.bringSubviewToFront(shareView)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.shareView.transform = CGAffineTransformIdentity
        })
        
    }
    
    func InviteToParty() {
        
    }
    
    func visibleSwitched() {
        if(visibleSwitch?.on == true){
            shareBtn?.alpha = 1.0
            justRegionalSwitch?.alpha = 1.0
            justRegionalLbl?.alpha = 1.0
            picsSwitch?.alpha = 1.0
            picsLbl?.alpha = 1.0
            inviteBtn?.alpha = 1.0
        
            shareBtn?.enabled = true
            inviteBtn?.enabled = true
            picsSwitch?.enabled = true
            justRegionalSwitch?.enabled = true
        } else {
            shareBtn?.alpha = 0.3
            justRegionalSwitch?.alpha = 0.3
            justRegionalLbl?.alpha = 0.3
            picsSwitch?.alpha = 0.3
            picsLbl?.alpha = 0.3
            inviteBtn?.alpha = 0.3
            
            shareBtn?.enabled = false
            inviteBtn?.enabled = false
            picsSwitch?.enabled = false
            justRegionalSwitch?.enabled = false
        }
    }
    
    func share() {
        if(nameTxt?.text == ""){
            let alertController = UIAlertController(title: "Input Error!", message: "Please Enter a Name", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            return
        } else if (numberTxt?.text.toInt() == nil){
            let alertController = UIAlertController(title: "Input Error!", message: "Invalid Team Number", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            return
        } else {
            //do bluetooth stuff
            
            closeShareView()
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    


}
