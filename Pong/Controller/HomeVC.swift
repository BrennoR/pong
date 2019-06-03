//
//  HomeVC.swift
//  Pong
//
//  Created by Brenno Ribeiro on 2/16/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import UIKit
import GoogleMobileAds
import GameKit

class HomeVC: UIViewController, GADBannerViewDelegate, GKGameCenterControllerDelegate {
    
    @IBOutlet weak var adBanner1: GADBannerView!    // banner ad
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    let LEADERBOARD_ID = "grp.levels"   // game center leaderboard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateLocalPlayer()
        setupAds()
    }
    
    // loads freeplayVC
    @IBAction func freeplayBtnWasPressed(_ sender: Any) {
        performSegue(withIdentifier: "freeplaySeg", sender: self)
    }
    
    // presents gamecenter leaderboard
    @IBAction func leaderboardsBtnWasPressed(_ sender: Any) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
//        gcVC.viewState = .leaderboards
        gcVC.viewState = .default
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
    
    // unwind segue
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
    }

    // authenticate gamecenter player
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error as Any)
                    } else { self.gcDefaultLeaderBoard = "grp.levels" }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error as Any)
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    // ad banner setup
    @objc func setupAds() {
        if UserDefaults.standard.bool(forKey: PurchaseManager.instance.IAP_PREMIUM) {
            adBanner1?.removeFromSuperview()
        } else {
            adBanner1.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            adBanner1.rootViewController = self
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            adBanner1.load(GADRequest())
        }
    }

}
