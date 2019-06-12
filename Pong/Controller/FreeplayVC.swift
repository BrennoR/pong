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
    
    // button outlets
    @IBOutlet weak var singlePlayerBtn: BorderButton!
    @IBOutlet weak var twoPlayerBtn: BorderButton!
    @IBOutlet weak var unlimitedBtn: BorderButton!
    @IBOutlet weak var threeLivesBtn: BorderButton!
    
    @IBOutlet weak var adBanner4: GADBannerView!    // banner ad
    
    var playerNumber = 1    // number of players variable
    var modeState = 0   // used to either dismiss VC or go back to 1 vs. 2 player
    var livesMode = 0   // 0 = unlimited, 1 = three lives
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showPlayers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupAds()
    }
    
    // sets player number to one and presents modes
    @IBAction func singlePlayerBtnWasPressed(_ sender: Any) {
        showModes()
        playerNumber = 1
    }
    
    // sets player number to two and presents modes
    @IBAction func twoPlayerBtnWasPressed(_ sender: Any) {
        showModes()
        playerNumber = 2
    }
    
    // sets unlimited mode and presents FreeplayScene
    @IBAction func unlimitedBtnWasPressed(_ sender: Any) {
        livesMode = 0
        performSegue(withIdentifier: "fromFreeplaySeg", sender: self)
    }
    
    // sets three lives mode and presents FreeplayScene
    @IBAction func threeLivesBtnWasPressed(_ sender: Any) {
        livesMode = 1
        performSegue(withIdentifier: "fromFreeplaySeg", sender: self)
    }
    
    // returns to homeVC or resets buttons
    @IBAction func backBtnWasPressed(_ sender: Any) {
        if modeState == 0 {
            dismiss(animated: true, completion: nil)
        } else {
            showPlayers()
        }
    }
    
    // initial button setup
    func showPlayers() {
        singlePlayerBtn.isHidden = false
        twoPlayerBtn.isHidden = false
        unlimitedBtn.isHidden = true
        threeLivesBtn.isHidden = true
        modeState = 0
    }
    
    // mode button setup
    func showModes() {
        singlePlayerBtn.isHidden = true
        twoPlayerBtn.isHidden = true
        unlimitedBtn.isHidden = false
        threeLivesBtn.isHidden = false
        modeState = 1
    }
    
    // sets player number and lives mode in FreeplayScene
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let GameVC = segue.destination as? GameViewController {
            GameVC.freeplay = true
            FreeplaySettings.instance.freeplayMode = livesMode
            FreeplaySettings.instance.freeplayPlayerNumber = playerNumber
        }
    }
    
    // banner ad setup
    @objc func setupAds() {
        print(UserDefaults.standard.bool(forKey: PurchaseManager.instance.IAP_PREMIUM))
        if UserDefaults.standard.bool(forKey: PurchaseManager.instance.IAP_PREMIUM) {
            adBanner4?.removeFromSuperview()
        } else {
            adBanner4.adUnitID = "ca-app-pub-6168015053740034/2453609429"
            adBanner4.rootViewController = self
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            adBanner4.load(request)
        }
    }

}
