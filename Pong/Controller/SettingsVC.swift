//
//  SettingsVC.swift
//  Pong
//
//  Created by Brenno Ribeiro on 2/16/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import UIKit
import GoogleMobileAds


class SettingsVC: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var adBanner3: GADBannerView!    // banner ad
    
    // audio switch
    @IBOutlet weak var audioSwitch: UISwitch!
    
    // color buttons
    @IBOutlet weak var paddleColorBtn: UIButton!
    @IBOutlet weak var enemyPaddleColorBtn: UIButton!
    @IBOutlet weak var ballColorBtn: UIButton!
    @IBOutlet weak var backgroundThemeBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAds()
        updateColors()
        
        audioSwitch.isOn = UserDefaults.standard.value(forKey: "audioEnabled") as? Bool ?? true
        
        // ad observer
        NotificationCenter.default.addObserver(self, selector: #selector(setupAds), name: Notification.Name("ADS"), object: nil)
        // color update observer
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: Notification.Name("updateColors"), object: nil)
    }
    
    // presents color palette
    @IBAction func showColorPalette(_ sender: UIButton) {
        let ColorPaletteVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ColorPaletteID") as! ColorPaletteVC
        self.addChild(ColorPaletteVC)
        ColorPaletteVC.view.frame = self.view.frame
        ColorPaletteVC.setting = sender.restorationIdentifier
        self.view.addSubview(ColorPaletteVC.view)
        ColorPaletteVC.didMove(toParent: self)
    }
    
    // returns to homeVC
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // updates button colors
    @objc func updateColors() {
        paddleColorBtn.backgroundColor = UserDefaults.standard.colorForKey(key: "paddleColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        enemyPaddleColorBtn.backgroundColor = UserDefaults.standard.colorForKey(key: "enemyPaddleColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ballColorBtn.backgroundColor = UserDefaults.standard.colorForKey(key: "ballColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        backgroundThemeBtn.backgroundColor = UserDefaults.standard.colorForKey(key: "backgroundTheme") ?? #colorLiteral(red: 0.1490196139, green: 0.1490196139, blue: 0.1490196139, alpha: 1)
    }
    
    // enables and disables sound
    @IBAction func audioSwitchWasUsed(_ sender: Any) {
        if audioSwitch.isOn {
            UserDefaults.standard.set(true, forKey: "audioEnabled")
            AudioSettings.instance.soundEnabled = true
        } else {
            UserDefaults.standard.set(false, forKey: "audioEnabled")
            AudioSettings.instance.soundEnabled = false
        }
    }
    
    // presents premium pop-up
    @IBAction func removeAdsBtnWasPressed(_ sender: Any) {
        let premiumVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremiumID") as! PremiumVC
        self.addChild(premiumVC)
        premiumVC.view.frame = self.view.frame
        self.view.addSubview(premiumVC.view)
        premiumVC.didMove(toParent: self)
    }
    
    // ad banner setup
    @objc func setupAds() {
        if UserDefaults.standard.bool(forKey: PurchaseManager.instance.IAP_PREMIUM) {
            adBanner3?.removeFromSuperview()
        } else {
            adBanner3.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            adBanner3.rootViewController = self
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            adBanner3.load(request)
        }
    }
    

}
