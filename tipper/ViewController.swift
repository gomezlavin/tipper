//
//  ViewController.swift
//  tipper
//
//  Created by SGLMR on 28/08/16.
//  Copyright © 2016 Golav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting default NSUserDefaults for the first time the app is used
        if (defaults.object(forKey: "tipPercentage") == nil) {
            defaults.set(15, forKey: "tipPercentage")
            defaults.set(1, forKey: "peopleNumber")
            defaults.set(0, forKey: "currencySymbol")
            defaults.set(0, forKey: "colorTheme")
            defaults.synchronize()
        }
        
        // Save the value of the bill field unless 10 minutes have passed by
        currencySymbol = currencyValues[defaults.integer(forKey: "currencySymbol")]
        if (defaults.object(forKey: "bill") != nil && defaults.object(forKey: "expiryTime") != nil) {
            let now = Date()
            let expiryTime = String(describing: defaults.object(forKey: "expiryTime")!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
            let expiration = dateFormatter.date(from: expiryTime)!
            
            switch now.compare(expiration) {
            case .orderedAscending, .orderedSame:
                billField.text = (defaults.object(forKey: "bill") as! String)
                if (currencyValues.index(of: billField.text!) == nil) {
                    calculateTip()
                }
            case .orderedDescending:
                billField.text = currencySymbol
            }
        } else {
            billField.text = currencySymbol
        }
    }
    
    @IBAction func billFieldChange(_ sender: AnyObject) {
        let billString = String(billField.text!)!
        
        if (!billString.isEmpty && billString[billString.startIndex] == currencySymbol[currencySymbol.startIndex]) {
            let newString = String(billString.characters.dropFirst(1))
            billField.text = newString
        }
        
        if (billField.text != "") {
            UIView.animate(withDuration: 0.1, animations: {
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
            
            UIView.animate(withDuration: 0.4, animations: {
                self.topView.frame = CGRect(x: 0, y: 0, width: self.topView.frame.size.width, height: self.topView.frame.size.height);
                self.bottomView.frame = CGRect(x: 0, y: 176, width: self.bottomView.frame.size.width, height: self.bottomView.frame.size.height);
            })
            calculateTip()
        }
        
        if (billField.text == "") {
            billField.text = currencySymbol
            UIView.animate(withDuration: 0.1, animations: {
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
            
            UIView.animate(withDuration: 0.4, animations: {
                self.topView.frame = CGRect(x: 0, y: 115, width: self.topView.frame.size.width, height: self.topView.frame.size.height);
                self.bottomView.frame = CGRect(x: 0, y: 287, width: self.bottomView.frame.size.width, height: self.bottomView.frame.size.height);
            })
        }
    }
    
    @IBAction func percentageSliderChange(_ sender: AnyObject) {
        // Locking slider intervals to fixed integer positions
        let roundedValue = round(self.percentageSlider.value)
        percentageSlider.setValue(roundedValue, animated: true)
        percentageLabel.text = String(format: "%.0f", roundedValue)
        calculateTip()
    }
    
    @IBAction func peopleSliderChange(_ sender: AnyObject) {
        // Locking slider intervals to fixed integer positions
        let roundedValue = round(self.peopleSlider.value)
        peopleSlider.setValue(roundedValue, animated: true)
        peopleLabel.text = String(format: "%.0f", roundedValue)
        calculateTip()
    }
    
    func calculateTip() {
        var billString = String(billField.text!)!
        billString = billString.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        billString = validateBillLabel(billString)
        
        let bill = Double(billString) ?? 0
        let percentage = Double(percentageSlider.value)
        let people = Double(peopleSlider.value)
        let tip = ((bill * percentage) / 100) / people
        let total = (bill / people) + tip
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2;
        formatter.maximumFractionDigits = 2;
        tipLabel.text = currencySymbol + formatter.string(from: NSNumber.init(value: tip))!
        totalLabel.text = currencySymbol + formatter.string(from: NSNumber.init(value: total))!
    }
    
    // Function to format the bill field using comma as group separator
    // Had to build function because formatter wasn't allowing "." in the field for some reason
    func fieldFormatter(_ billCharacters: [Character]) -> String {
        if (billCharacters.count > 3) {
            if (billCharacters.index(of: ".") != nil) {
                let index = billCharacters.index(of: ".")
                var intArray = Array(billCharacters[0...index!-1])
                let floatArray = Array(billCharacters[index!...billCharacters.endIndex-1])
                
                if (intArray.count > 3) {
                    var reversedArray = Array(intArray.reversed())
                    for i in 0 ..< reversedArray.count {
                        if (i != 0 && i % 3 == 0) {
                            reversedArray.insert(",", at: i+(i/3-1))
                        }
                    }
                    intArray = Array(reversedArray.reversed())
                }
                return String(intArray + floatArray)
            } else {
                var reversedArray = Array(billCharacters.reversed())
                for i in 0 ..< reversedArray.count {
                    if (i != 0 && i % 3 == 0) {
                        reversedArray.insert(",", at: i+(i/3-1))
                    }
                }
                
                return String(Array(reversedArray.reversed()))
            }
        }
        
        return String(billCharacters)
    }
    
    // Function for restrict user input into the billField
    func validateBillLabel (_ billString: String) -> String {
        let permitedCharacters = ["0","1","2","3","4","5","6","7","8","9","."]
        let maxLengthBill = 10
        let maxLengthTotal = 12
        var billCharacters = Array(billString.characters)
        let totalCharacters = Array(totalLabel.text!.characters)
        
        // Only allow digits and period
        if (permitedCharacters.index(of: String(billCharacters[billCharacters.endIndex-1])) == nil) {
            _ = billCharacters.popLast()
        }
        
        // Limit the max length of the Total Field
        if (totalCharacters.count > maxLengthTotal) {
            _ = billCharacters.popLast()
        }
        
        // Limit the max length of the Bill Field
        if (billCharacters.count > maxLengthBill) {
            _ = billCharacters.popLast()
        }
        
        // Allow only one zero
        if (billCharacters.count > 1 && billCharacters[0] == "0" && billCharacters[1] == "0") {
            _ = billCharacters.popLast()
        }
        
        // Trim starting zero if not followed by period
        if (billCharacters.count > 1 && billCharacters[0] == "0" && billCharacters[1] != ".") {
            _ = billCharacters.removeFirst()
        }
        
        // Allowing only one period
        if (billCharacters.endIndex > 0 && billCharacters[billCharacters.endIndex-1] == ".") {
            if (billCharacters.count < 2) {
                _ = billCharacters.popLast()
            } else {
                let subArray = billCharacters[0...billCharacters.endIndex-2]
                if (subArray.index(of: ".") != nil) {
                    _ = billCharacters.popLast()
                }
            }
        }
        
        let formattedField = fieldFormatter(billCharacters)
        billField.text = formattedField
        return formattedField.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Loading user defaults
        let tipPercentage = defaults.float(forKey: "tipPercentage")
        let peopleNumber = defaults.float(forKey: "peopleNumber")
        currencySymbol = currencyValues[defaults.integer(forKey: "currencySymbol")]
        let colorTheme = defaults.integer(forKey: "colorTheme")
        
        if (currencyValues.index(of: billField.text!) != nil) {
            billField.text = currencySymbol
        }
        
        percentageSlider.setValue(tipPercentage, animated: true)
        percentageLabel.text = String(format: "%.0f", tipPercentage)
        peopleSlider.setValue(peopleNumber, animated: true)
        peopleLabel.text = String(format: "%.0f", peopleNumber)
        
        tipLabel.text!.remove(at: tipLabel.text!.startIndex)
        totalLabel.text!.remove(at: totalLabel.text!.startIndex)
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
            self.topView.frame = CGRect(x: 0, y: 0, width: self.topView.frame.size.width, height: self.topView.frame.size.height);
            self.bottomView.frame = CGRect(x: 0, y: 176, width: self.bottomView.frame.size.width, height: self.bottomView.frame.size.height);
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
            self.topView.frame = CGRect(x: 0, y: 115, width: self.topView.frame.size.width, height: self.topView.frame.size.height);
            self.bottomView.frame = CGRect(x: 0, y: 287, width: self.bottomView.frame.size.width, height: self.bottomView.frame.size.height);
        }
    }
    
    // Function to change the app's color theme in this view based on user defaults
    func changeColorTheme(_ style: String, kb: String, lr: Float, lg: Float, lb: Float, dr: Float, dg: Float, db: Float, img: String) {
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
            self.billField.keyboardAppearance = UIKeyboardAppearance.dark
            UIApplication.shared.statusBarStyle = .lightContent
            lfr = CGFloat(1.0)
            lfg = CGFloat(1.0)
            lfb = CGFloat(1.0)
            dfr = lfr
            dfg = lfg
            dfb = lfb
        case "light":
            self.billField.keyboardAppearance = UIKeyboardAppearance.light
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
            lfr = CGFloat(0.0)
            lfg = CGFloat(0.0)
            lfb = CGFloat(0.0)
            dfr = lfr
            dfg = lfg
            dfb = lfb
        case "blue":
            self.billField.keyboardAppearance = UIKeyboardAppearance.light
            UIApplication.shared.statusBarStyle = .lightContent
            lfr = lr
            lfg = lg
            lfb = lb
            dfr = dr
            dfg = dg
            dfb = db
        case "red":
            self.billField.keyboardAppearance = UIKeyboardAppearance.light
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        billField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Saving billField value for 10 minutes
        defaults.set(15, forKey: "tipPercentage")
        defaults.set(billField.text!, forKey: "bill")
        let now = Date()
        let futureDate = now.addingTimeInterval(10.0 * 60.0)
        defaults.set(futureDate, forKey: "expiryTime")
        defaults.synchronize()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

