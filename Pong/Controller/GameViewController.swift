//
//  GameViewController.swift
//  Pong
//
//  Created by Brenno Ribeiro on 12/23/18.
//  Copyright © 2018 Brenno Ribeiro. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

// hold variables for interstitial ad
var freeplayHold = false    
var gameOverHold = false

class GameViewController: UIViewController, GADInterstitialDelegate {
    
    var freeplay = false    // freeplay variable
    var file = ""           // file name
    
    var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // interstitial ad
        interstitial = createAndLoadInterstitial()
        
        if freeplay {
            file = "FreeplayScene"  // freeplay scene
        } else {
            file = "GameScene"      // career game scene
        }
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: file) {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        // game over observer
        NotificationCenter.default.addObserver(self, selector: #selector(gameOver), name: NSNotification.Name(rawValue: "gameOver"), object: nil)
        // interstitial ad observer
        NotificationCenter.default.addObserver(self, selector: #selector(showInterstitial), name: NSNotification.Name(rawValue: "showInterstitial"), object: nil)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // homeVC segue
    @objc func gameOver() {
        performSegue(withIdentifier: "backToHome", sender: nil)
    }
    
    // loads interstitial
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial() // loads new interstitial
        
        // reloads freeplayscene after interstitial is dismissed
        if freeplayHold == true {
            if let view = self.view as! SKView? {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = SKScene(fileNamed: "FreeplayScene")!
                gameScene.scaleMode = .aspectFill
                view.presentScene(gameScene, transition: reveal)
            }
        }
        freeplayHold = false
        
        // returns to homeVC after interstitial is dismissed
        if gameOverHold == true {
            gameOver()
        }
        gameOverHold = false
    }
    
    // presents interstitial ad
    @objc func showInterstitial() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
}
