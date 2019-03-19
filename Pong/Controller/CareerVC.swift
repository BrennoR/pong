//
//  HomeVC.swift
//  Pong
//
//  Created by Brenno Ribeiro on 1/26/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import UIKit
import GoogleMobileAds


class CareerVC: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var adBanner2: GADBannerView!

    @IBOutlet var levelBtns: [UIButton]!
    
    let availableLevelIndex = UserDefaults.standard.integer(forKey: "availableLevelIndex")

    override func viewDidLoad() {
        super.viewDidLoad()
        enableBtns()
        setupAds()
//        // Google AdMob
//        // Request
//        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID]
//
//        // Set up ad
//        adBanner2.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//
//        adBanner2.rootViewController = self
//        adBanner2.delegate = self
//
//        adBanner2.load(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    @IBAction func lvlBtnWasPressed(_ sender: UIButton) {
        LevelSettings.instance.current_setting = LevelSettings.instance.settings[sender.tag]!
        LevelSettings.instance.currentLevel = sender.tag
        self.performSegue(withIdentifier: "gameSeg", sender: self)
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func enableBtns() {
        if availableLevelIndex != 11 {
            for lvl in levelBtns[(availableLevelIndex + 1) ... 11] {
                lvl.isEnabled = false
            }
        }
    }
    
    @objc func setupAds() {
        if UserDefaults.standard.bool(forKey: PurchaseManager.instance.IAP_PREMIUM) {
            adBanner2?.removeFromSuperview()
        } else {
            adBanner2.adUnitID = "ca-app-pub-6168015053740034/1040430807"
            adBanner2.rootViewController = self
//            adBanner2.delegate = self
//            let request = GADRequest()
//            request.testDevices = [kGADSimulatorID]
            adBanner2.load(GADRequest())
        }
    }
    
}
