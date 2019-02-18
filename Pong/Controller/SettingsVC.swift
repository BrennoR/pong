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
    
    @IBOutlet weak var adBanner3: GADBannerView!
    
    @IBOutlet weak var paddleColorBtn: UIButton!
    @IBOutlet weak var enemyPaddleColorBtn: UIButton!
    @IBOutlet weak var ballColorBtn: UIButton!
    @IBOutlet weak var backgroundThemeBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Google AdMob
        // Request
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        // Set up ad
        adBanner3.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        adBanner3.rootViewController = self
        adBanner3.delegate = self
        
        adBanner3.load(request)
        
        updateColors()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: Notification.Name("updateColors"), object: nil)
    }
    
    @IBAction func showColorPalette(_ sender: UIButton) {
        let ColorPaletteVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ColorPaletteID") as! ColorPaletteVC
        self.addChild(ColorPaletteVC)
        ColorPaletteVC.view.frame = self.view.frame
        ColorPaletteVC.settingTest = sender.restorationIdentifier
        self.view.addSubview(ColorPaletteVC.view)
        ColorPaletteVC.didMove(toParent: self)
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func updateColors() {
        paddleColorBtn.backgroundColor = UserDefaults.standard.colorForKey(key: "paddleColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        enemyPaddleColorBtn.backgroundColor = UserDefaults.standard.colorForKey(key: "enemyPaddleColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ballColorBtn.backgroundColor = UserDefaults.standard.colorForKey(key: "ballColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        backgroundThemeBtn.backgroundColor = UserDefaults.standard.colorForKey(key: "backgroundTheme") ?? #colorLiteral(red: 0.1490196139, green: 0.1490196139, blue: 0.1490196139, alpha: 1)
    }

}
