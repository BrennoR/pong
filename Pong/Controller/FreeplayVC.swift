//
//  FreeplayVC.swift
//  Pong
//
//  Created by Brenno Ribeiro on 2/17/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FreeplayVC: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var singlePlayerBtn: BorderButton!
    @IBOutlet weak var twoPlayerBtn: BorderButton!
    @IBOutlet weak var unlimitedBtn: BorderButton!
    @IBOutlet weak var threeLivesBtn: BorderButton!
    @IBOutlet weak var adBanner4: GADBannerView!
    
    var playerNumber = 1
    var modeState = 0   // used to either dismiss VC or go back to 1 vs. 2 player
    var livesMode = 0   // 0 = unlimited, 1 = three lives
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showPlayers()
        setupAds()
        
//        // Google AdMob
//        // Request
//        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID]
//
//        // Set up ad
//        adBanner4.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//
//        adBanner4.rootViewController = self
//        adBanner4.delegate = self
//
//        adBanner4.load(request)
    }
    
    @IBAction func singlePlayerBtnWasPressed(_ sender: Any) {
        showModes()
        playerNumber = 1
    }
    
    @IBAction func twoPlayerBtnWasPressed(_ sender: Any) {
        showModes()
        playerNumber = 2
    }
    
    @IBAction func unlimitedBtnWasPressed(_ sender: Any) {
        livesMode = 0
        performSegue(withIdentifier: "fromFreeplaySeg", sender: self)
    }
    
    @IBAction func threeLivesBtnWasPressed(_ sender: Any) {
        livesMode = 1
        performSegue(withIdentifier: "fromFreeplaySeg", sender: self)
    }
    
    
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        if modeState == 0 {
            dismiss(animated: true, completion: nil)
        } else {
            showPlayers()
        }
    }
    
    
    func showPlayers() {
        singlePlayerBtn.isHidden = false
        twoPlayerBtn.isHidden = false
        unlimitedBtn.isHidden = true
        threeLivesBtn.isHidden = true
        modeState = 0
    }
    
    func showModes() {
        singlePlayerBtn.isHidden = true
        twoPlayerBtn.isHidden = true
        unlimitedBtn.isHidden = false
        threeLivesBtn.isHidden = false
        modeState = 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let GameVC = segue.destination as? GameViewController {
            GameVC.freeplay = true
            FreeplaySettings.instance.freeplayMode = livesMode
            FreeplaySettings.instance.freeplayPlayerNumber = playerNumber
        }
    }
    
    @objc func setupAds() {
        print(UserDefaults.standard.bool(forKey: PurchaseManager.instance.IAP_PREMIUM))
        if UserDefaults.standard.bool(forKey: PurchaseManager.instance.IAP_PREMIUM) {
            adBanner4?.removeFromSuperview()
        } else {
            adBanner4.adUnitID = "ca-app-pub-6168015053740034/1040430807"
            adBanner4.rootViewController = self
//            adBanner4.delegate = self
//            let request = GADRequest()
//            request.testDevices = [kGADSimulatorID]
            adBanner4.load(GADRequest())
        }
    }

}
