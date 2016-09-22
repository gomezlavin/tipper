//
//  SettingsViewController.swift
//  tipper
//
//  Created by SGLMR on 02/09/16.
//  Copyright © 2016 Golav. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var tipSection: UIView!
    @IBOutlet weak var tipSectionLabel: UILabel!
    @IBOutlet weak var settingsTipSlider: UISlider!
    @IBOutlet weak var settingsTipLabel: UILabel!
    @IBOutlet weak var settingsTipIcon: UILabel!
    
    @IBOutlet weak var peopleSection: UIView!
    @IBOutlet weak var peopleSectionLabel: UILabel!
    @IBOutlet weak var settingsPeopleSlider: UISlider!
    @IBOutlet weak var settingsPeopleLabel: UILabel!
    @IBOutlet weak var settingsPeopleIcon: UIImageView!
    
    @IBOutlet weak var currencySection: UIView!
    @IBOutlet weak var currencySectionlabel: UILabel!
    @IBOutlet weak var settingsCurrencyControl: UISegmentedControl!
    
    @IBOutlet weak var themeSection: UIView!
    @IBOutlet weak var themeSectionLabel: UILabel!
    @IBOutlet weak var settingsThemeControl: UISegmentedControl!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tipSection.layer.cornerRadius = 5.0
        peopleSection.layer.cornerRadius = 5.0
        currencySection.layer.cornerRadius = 5.0
        themeSection.layer.cornerRadius = 5.0
 
        let tipPercentage = defaults.float(forKey: "tipPercentage")
        let peopleNumber = defaults.float(forKey: "peopleNumber")
        let currencySymbol = defaults.integer(forKey: "currencySymbol")
        let colorTheme = defaults.integer(forKey: "colorTheme")
        
        settingsTipSlider.setValue(tipPercentage, animated: true)
        settingsTipLabel.text = String(format: "%.0f", tipPercentage)
        settingsPeopleSlider.setValue(peopleNumber, animated: true)
        settingsPeopleLabel.text = String(format: "%.0f", peopleNumber)
        settingsCurrencyControl.selectedSegmentIndex = currencySymbol
        settingsThemeControl.selectedSegmentIndex = colorTheme
        
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
        var shr = CGFloat(1.0)
        var shg = CGFloat(1.0)
        var shb = CGFloat(1.0)
        
        switch style {
        case "dark":
            UIApplication.shared.statusBarStyle = .lightContent
            lfr = CGFloat(1.0)
            lfg = CGFloat(1.0)
            lfb = CGFloat(1.0)
            dfr = lfr
            dfg = lfg
            dfb = lfb
        case "light":
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
            lfr = CGFloat(0.0)
            lfg = CGFloat(0.0)
            lfb = CGFloat(0.0)
            dfr = lfr
            dfg = lfg
            dfb = lfb
            shr = CGFloat(0.0)
            shg = CGFloat(0.0)
            shb = CGFloat(0.0)
        case "blue", "red":
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
        
        backgroundView.backgroundColor = UIColor(red: lr, green: lg, blue: lb, alpha: 1.0)
        tipSection.backgroundColor = UIColor(red: dr, green: dg, blue: db, alpha: 1.0)
        tipSectionLabel.textColor = UIColor(red: shr, green: shg, blue: shb, alpha: 1.0)
        peopleSection.backgroundColor = UIColor(red: dr, green: dg, blue: db, alpha: 1.0)
        peopleSectionLabel.textColor = UIColor(red: shr, green: shg, blue: shb, alpha: 1.0)
        currencySection.backgroundColor = UIColor(red: dr, green: dg, blue: db, alpha: 1.0)
        currencySectionlabel.textColor = UIColor(red: shr, green: shg, blue: shb, alpha: 1.0)
        themeSection.backgroundColor = UIColor(red: dr, green: dg, blue: db, alpha: 1.0)
        themeSectionLabel.textColor = UIColor(red: shr, green: shg, blue: shb, alpha: 1.0)
        
        navigationController!.navigationBar.tintColor = UIColor(red: dr, green: dg, blue: db, alpha: 1.0)
        navigationController!.navigationBar.barTintColor = UIColor(red: lr, green: lg, blue: lb, alpha: 1.0)
        
        self.settingsTipSlider.minimumTrackTintColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.settingsTipSlider.maximumTrackTintColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.settingsTipSlider.thumbTintColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.settingsTipLabel.textColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.settingsTipLabel.textColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.settingsTipIcon.textColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        
        self.settingsPeopleSlider.minimumTrackTintColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.settingsPeopleSlider.maximumTrackTintColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.settingsPeopleSlider.thumbTintColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.settingsPeopleLabel.textColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.settingsPeopleLabel.textColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        self.settingsPeopleIcon.image = UIImage(named: img)
        
        settingsCurrencyControl.tintColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
        settingsThemeControl.tintColor = UIColor(red: dfr, green: dfg, blue: dfb, alpha: 1.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        defaults.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func settingsTipSliderChange(_ sender: AnyObject) {
        let roundedValue = round(self.settingsTipSlider.value)
        settingsTipSlider.setValue(roundedValue, animated: true)
        settingsTipLabel.text = String(format: "%.0f", roundedValue)
        defaults.set(roundedValue, forKey: "tipPercentage")
    }

    @IBAction func settingsPeopleSliderChange(_ sender: AnyObject) {
        let roundedValue = round(self.settingsPeopleSlider.value)
        settingsPeopleSlider.setValue(roundedValue, animated: true)
        settingsPeopleLabel.text = String(format: "%.0f", roundedValue)
        defaults.set(roundedValue, forKey: "peopleNumber")
    }
    
    @IBAction func currencyControlChange(_ sender: AnyObject) {
        defaults.set(settingsCurrencyControl.selectedSegmentIndex, forKey: "currencySymbol")
    }
    
    @IBAction func themeControlChange(_ sender: AnyObject) {
        switch (settingsThemeControl.selectedSegmentIndex) {
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
        
        defaults.set(settingsThemeControl.selectedSegmentIndex, forKey: "colorTheme")
    }
}
