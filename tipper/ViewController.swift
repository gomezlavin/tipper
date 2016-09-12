//
//  ViewController.swift
//  tipper
//
//  Created by SGLMR on 28/08/16.
//  Copyright © 2016 Golav. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var backgroundViewTop: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var percentageSlider: UISlider!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var percentageIcon: UILabel!
    @IBOutlet weak var peopleSlider: UISlider!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var peopleIcon: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tipNameLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalNameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var backgroundViewBottom: UIView!
    @IBOutlet weak var settingsIcon: UIBarButtonItem!
    
    var currencySymbol = ""
    let currencyValues = ["$", "£", "€", "¥", "₩"]
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billField.delegate = self
        
        if (defaults.objectForKey("tipPercentage") == nil) {
            defaults.setFloat(15, forKey: "tipPercentage")
            defaults.setFloat(1, forKey: "peopleNumber")
            defaults.setInteger(0, forKey: "currencySymbol")
            //            defaults.setInteger(0, forKey: "colorTheme")
            defaults.synchronize()
        }
        
        currencySymbol = currencyValues[defaults.integerForKey("currencySymbol")]
        billField.text = currencySymbol
    }
    
    @IBAction func billFieldChange(sender: AnyObject) {
        let billString = String(billField.text!)
        
        if (!billString.isEmpty && billString[billString.startIndex] == currencySymbol[currencySymbol.startIndex]) {
            let newString = String(billString.characters.dropFirst(1))
            billField.text = newString
        }
        
        if (billField.text != "") {
            UIView.animateWithDuration(0.1, animations: {
                self.percentageSlider.alpha = 1
                self.percentageLabel.alpha = 1
                self.percentageIcon.alpha = 1
                self.peopleSlider.alpha = 1
                self.peopleLabel.alpha = 1
                self.peopleIcon.alpha = 1
                self.tipNameLabel.alpha = 1
                self.tipLabel.alpha = 1
                self.totalNameLabel.alpha = 1
                self.totalLabel.alpha = 1
            })
            
            UIView.animateWithDuration(0.4, animations: {
                self.topView.frame = CGRectMake(0, 0, self.topView.frame.size.width, self.topView.frame.size.height);
                self.bottomView.frame = CGRectMake(0, 176, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
            })
            calculateTip()
        }
        
        if (billField.text == "") {
            billField.text = currencySymbol
            UIView.animateWithDuration(0.1, animations: {
                self.percentageSlider.alpha = 0
                self.percentageLabel.alpha = 0
                self.percentageIcon.alpha = 0
                self.peopleSlider.alpha = 0
                self.peopleLabel.alpha = 0
                self.peopleIcon.alpha = 0
                self.tipNameLabel.alpha = 0
                self.tipLabel.alpha = 0
                self.totalNameLabel.alpha = 0
                self.totalLabel.alpha = 0
            })
            
            UIView.animateWithDuration(0.4, animations: {
                self.topView.frame = CGRectMake(0, 115, self.topView.frame.size.width, self.topView.frame.size.height);
                self.bottomView.frame = CGRectMake(0, 287, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
            })
        }
    }
    
    @IBAction func percentageSliderChange(sender: AnyObject) {
        let roundedValue = round(self.percentageSlider.value)
        percentageSlider.setValue(roundedValue, animated: true)
        percentageLabel.text = String(format: "%.0f", roundedValue)
        calculateTip()
    }
    
    @IBAction func peopleSliderChange(sender: AnyObject) {
        let roundedValue = round(self.peopleSlider.value)
        peopleSlider.setValue(roundedValue, animated: true)
        peopleLabel.text = String(format: "%.0f", roundedValue)
        calculateTip()
    }
    
    func calculateTip() {
        var billString = String(billField.text!)
        billString = billString.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let bill = Float(billString) ?? 0
        let tip = ((bill * percentageSlider.value) / 100) / peopleSlider.value
        let total = (bill / peopleSlider.value) + tip
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.groupingSeparator = ","
        billField.text = formatter.stringFromNumber(bill)
        formatter.minimumFractionDigits = 2;
        formatter.maximumFractionDigits = 2;
        tipLabel.text = currencySymbol + formatter.stringFromNumber(tip)!
        totalLabel.text = currencySymbol + formatter.stringFromNumber(total)!
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tipPercentage = defaults.floatForKey("tipPercentage")
        let peopleNumber = defaults.floatForKey("peopleNumber")
        currencySymbol = currencyValues[defaults.integerForKey("currencySymbol")]
        let colorTheme = defaults.integerForKey("colorTheme")
        
        if (currencyValues.indexOf(billField.text!) != nil) {
            billField.text = currencySymbol
        }
        
        percentageSlider.setValue(tipPercentage, animated: true)
        percentageLabel.text = String(format: "%.0f", tipPercentage)
        peopleSlider.setValue(peopleNumber, animated: true)
        peopleLabel.text = String(format: "%.0f", peopleNumber)
        
        tipLabel.text!.removeAtIndex(tipLabel.text!.startIndex)
        totalLabel.text!.removeAtIndex(totalLabel.text!.startIndex)
        tipLabel.text = currencySymbol + tipLabel.text!
        totalLabel.text = currencySymbol + totalLabel.text!
        
        switch (colorTheme) {
        case (0):
            changeColorTheme("dark", kb: "dark", lr: 0.3686, lg: 0.3686, lb: 0.3686, dr: 0.098, dg: 0.098, db: 0.098, img: "peopleWhite")
        case (1):
            changeColorTheme("light", kb: "light", lr: 1.0, lg: 1.0, lb: 1.0, dr: 0.8078, dg: 0.8314, db: 0.8588, img: "peopleBlack")
        case (2):
            changeColorTheme("blue", kb: "light", lr: 0.8196, lg: 0.8824, lb: 0.9529, dr: 0.1216, dg: 0.2863, db: 0.4392, img: "peopleBlue")
        case (3):
            changeColorTheme("red", kb: "light", lr: 0.9216, lg: 0.7765, lb: 0.7725, dr: 0.4627, dg: 0.2039, db: 0.1882, img: "peopleRed")
        default:
            print("Default")
        }
        
        if (billField.text != currencySymbol) {
            percentageSlider.alpha = 1
            percentageLabel.alpha = 1
            percentageIcon.alpha = 1
            peopleSlider.alpha = 1
            peopleLabel.alpha = 1
            peopleIcon.alpha = 1
            tipNameLabel.alpha = 1
            tipLabel.alpha = 1
            totalNameLabel.alpha = 1
            self.totalLabel.alpha = 1
            self.topView.frame = CGRectMake(0, 0, self.topView.frame.size.width, self.topView.frame.size.height);
            self.bottomView.frame = CGRectMake(0, 176, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
        } else {
            self.percentageSlider.alpha = 0
            self.percentageLabel.alpha = 0
            self.percentageIcon.alpha = 0
            self.peopleSlider.alpha = 0
            self.peopleLabel.alpha = 0
            self.peopleIcon.alpha = 0
            self.tipNameLabel.alpha = 0
            self.tipLabel.alpha = 0
            self.totalNameLabel.alpha = 0
            self.totalLabel.alpha = 0
            self.topView.frame = CGRectMake(0, 115, self.topView.frame.size.width, self.topView.frame.size.height);
            self.bottomView.frame = CGRectMake(0, 287, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool {
        let maxLength = 9
        let currentString: NSString = textField.text!
        let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }
    
    func changeColorTheme(style: String, kb: String, lr: Float, lg: Float, lb: Float, dr: Float, dg: Float, db: Float, img: String) {
        let lr = CGFloat(lr)
        let lg = CGFloat(lg)
        let lb = CGFloat(lb)
        let dr = CGFloat(dr)
        let dg = CGFloat(dg)
        let db = CGFloat(db)
        var lfr = CGFloat(0.0)
        var lfg = CGFloat(0.0)
        var lfb = CGFloat(0.0)
        var dfr = CGFloat(1.0)
        var dfg = CGFloat(1.0)
        var dfb = CGFloat(1.0)
        
        switch style {
        case "dark":
            self.billField.keyboardAppearance = UIKeyboardAppearance.Dark
            UIApplication.sharedApplication().statusBarStyle = .LightContent
            lfr = CGFloat(1.0)
            lfg = CGFloat(1.0)
            lfb = CGFloat(1.0)
            dfr = lfr
            dfg = lfg
            dfb = lfb
        case "light":
            self.billField.keyboardAppearance = UIKeyboardAppearance.Light
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
            lfr = CGFloat(0.0)
            lfg = CGFloat(0.0)
            lfb = CGFloat(0.0)
            dfr = lfr
            dfg = lfg
            dfb = lfb
        case "blue":
            self.billField.keyboardAppearance = UIKeyboardAppearance.Light
            UIApplication.sharedApplication().statusBarStyle = .LightContent
            lfr = lr
            lfg = lg
            lfb = lb
            dfr = dr
            dfg = dg
            dfb = db
        case "red":
            self.billField.keyboardAppearance = UIKeyboardAppearance.Light
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
            lfr = lr
            lfg = lg
            lfb = lb
            dfr = dr
            dfg = dg
            dfb = db
        default:
            print("Default")
        }
        
        navigationController!.navigationBar.barTintColor = UIColor(red: dr, green: dg, blue: db, alpha: 1.0)
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: lfr, green: lfg, blue: lfb, alpha: 1.0)]
        settingsIcon.tintColor = UIColor(red: lfr, green: lfg, blue: lfb, alpha: 1.0)
        backgroundViewTop.backgroundColor = UIColor(red: lr, green: lg, blue: lb, alpha: 1.0)
        backgroundViewBottom.backgroundColor = UIColor(red: dr, green: dg, blue: db, alpha: 1.0)
        topView.backgroundColor = UIColor(red: lr, green: lg, blue: lb, alpha: 1.0)
        billField.textColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        
        self.percentageSlider.minimumTrackTintColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.percentageSlider.maximumTrackTintColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.percentageSlider.thumbTintColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.percentageLabel.textColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.percentageIcon.textColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        
        self.peopleSlider.minimumTrackTintColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.peopleSlider.maximumTrackTintColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.peopleSlider.thumbTintColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.peopleLabel.textColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.peopleIcon.image = UIImage(named: img)

        bottomView.backgroundColor = UIColor(red: dr, green: dg, blue: db, alpha: 1.0)
        self.tipNameLabel.textColor = UIColor(red: lfr, green: lfg, blue: lfb, alpha: 1.0)
        self.tipLabel.textColor = UIColor(red: lfr, green: lfg, blue: lfb, alpha: 1.0)
        self.totalNameLabel.textColor = UIColor(red: lfr, green: lfg, blue: lfb, alpha: 1.0)
        self.totalLabel.textColor = UIColor(red: lfr, green: lfg, blue: lfb, alpha: 1.0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        billField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

