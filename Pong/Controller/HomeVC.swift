//
//  HomeVC.swift
//  Pong
//
//  Created by Brenno Ribeiro on 2/16/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import UIKit
import GoogleMobileAds

enum colorSettings: Int {
    case paddle = 0
    case enemyPaddle = 1
    case ball = 2
    case backgroundTheme = 3
}

class HomeVC: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var adBanner1: GADBannerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Google AdMob
        // Request
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        // Set up ad
        adBanner1.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        adBanner1.rootViewController = self
        adBanner1.delegate = self
        
        adBanner1.load(request)
    }
    
    @IBAction func freeplayBtnWasPressed(_ sender: Any) {
        performSegue(withIdentifier: "freeplaySeg", sender: self)
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
    }


}
