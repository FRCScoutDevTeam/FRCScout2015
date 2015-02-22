//
//  more.swift
//  2015 FRC Scout
//
//  Created by David Swed on 1/9/15.
//  Copyright (c) 2015 David Swed. All rights reserved.
//

import UIKit

class More: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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

    
    @IBOutlet weak var changeRegionalBtn: UIButton!
    
    var regionalName : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        changeRegionalBtn.layer.cornerRadius = 5
        
        grayOutView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        grayOutView.backgroundColor = UIColor(white: 0.6, alpha: 0.6)
        
        weekSelected = NSUserDefaults.standardUserDefaults().integerForKey(WEEKSELECTEDKEY) ?? 0
        regionalPicker = UIPickerView()
        regionalPicker.delegate = self
        regionalPicker.dataSource = self
        
        weekSelected = NSUserDefaults.standardUserDefaults().integerForKey(WEEKSELECTEDKEY) ?? 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeRegionalPress(sender: AnyObject) {
        self.view.addSubview(grayOutView)
        regionalView = UIView(frame: CGRect(x: 94, y: 130, width: 580, height: 400))
        regionalView.backgroundColor = .whiteColor()
        regionalView.layer.cornerRadius = 10
        //regionalView.transform = CGAffineTransformMakeScale(0.01, 0.01)
        self.view.addSubview(regionalView)
        self.view.bringSubviewToFront(regionalView)
        
        /*let changeRegionalTitleLbl = UILabel(frame: CGRect(x: 240, y: 20, width: 100, height: 28))
        changeRegionalTitleLbl.textAlignment = .Center
        changeRegionalTitleLbl.text = "Sign In"
        changeRegionalTitleLbl.font = UIFont.boldSystemFontOfSize(25)
        regionalView.addSubview(changeRegionalTitleLbl)*/
        
        weekSelector = UISegmentedControl(items: ["All", "1", "2", "3", "4", "5", "6", "7+"])
        weekSelector.frame = CGRect(x: -52, y: 170, width: 216, height: 30)
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
        let weekSelectorLbl = UILabel(frame: CGRect(x: -42, y: 30, width: 36, height: 18))
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
        
        var closeBtn = UIButton(frame: CGRect(x: regionalView.layer.frame.width - 60, y: 5, width: 50, height:20))
        //var closeBtn = UIButton(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        closeBtn.addTarget(nil, action: Selector("closeRegionalView"), forControlEvents: UIControlEvents.TouchUpInside)
        closeBtn.setTitle("Close X", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        closeBtn.setTitleColor(UIColor(red: 0.25 , green: 0.75 , blue: 1.0 , alpha: 1),forState: UIControlState.Normal)
        closeBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        regionalView.addSubview(closeBtn)
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
        for view:AnyObject in regionalView.subviews {
            view.removeFromSuperview()
        }
        regionalView.removeFromSuperview()
        grayOutView.removeFromSuperview()
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
    


}
