//
//  GameOverScene.swift
//  Pong
//
//  Created by Brenno Ribeiro on 2/16/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
    
    var retryBtn = SKSpriteNode()
    var homeBtn = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        retryBtn = self.childNode(withName: "retryBtn") as! SKSpriteNode
        homeBtn = self.childNode(withName: "homeBtn") as! SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if retryBtn.contains(location) {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = SKScene(fileNamed: "GameScene")!
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene, transition: reveal)
            }
            
            if homeBtn.contains(location) {
                NotificationCenter.default.post(name: NSNotification.Name("gameOver"), object: nil)
            }
            
        }
    }

}
