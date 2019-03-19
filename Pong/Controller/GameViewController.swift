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

var freeplayHold = false
var gameOverHold = false

class GameViewController: UIViewController, GADInterstitialDelegate {
    
    var freeplay = false
    var file = ""
    
    var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // interstitial add
        interstitial = createAndLoadInterstitial()
        
        if freeplay {
            file = "FreeplayScene"
        } else {
            file = "GameScene"
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(gameOver), name: NSNotification.Name(rawValue: "gameOver"), object: nil)
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
    
    @objc func gameOver() {
        performSegue(withIdentifier: "backToHome", sender: nil)
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        
        if freeplayHold == true {
            if let view = self.view as! SKView? {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = SKScene(fileNamed: "FreeplayScene")!
                gameScene.scaleMode = .aspectFill
                view.presentScene(gameScene, transition: reveal)
            }
        }
        freeplayHold = false
        
        if gameOverHold == true {
            gameOver()
        }
        gameOverHold = false
    }
    
    @objc func showInterstitial() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
}
