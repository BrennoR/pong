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

class GameViewController: UIViewController {
    
    var freeplay = false
    var file = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
