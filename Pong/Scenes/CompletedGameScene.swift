//
//  CompletedGameScene.swift
//  Pong
//
//  Created by Brenno Ribeiro on 2/16/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import SpriteKit
import GameplayKit

class CompletedGameScene: SKScene {
    
    // nodes
    var ball1 = SKSpriteNode()
    var ball2 = SKSpriteNode()
    var ball3 = SKSpriteNode()
    var ball4 = SKSpriteNode()
    
    // main menu button
    var mainMenuBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    
    override func didMove(to view: SKView) {
        setupMainMenuBtn()
        
        ball1 = self.childNode(withName: "ball1") as! SKSpriteNode
        ball2 = self.childNode(withName: "ball2") as! SKSpriteNode
        ball3 = self.childNode(withName: "ball3") as! SKSpriteNode
        ball4 = self.childNode(withName: "ball4") as! SKSpriteNode
        
        // physics settings
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        border.collisionBitMask = 3
        
        self.physicsBody = border
        
        ball1.physicsBody?.applyImpulse(CGVector(dx: 40, dy: 70 * 0.5))
        ball2.physicsBody?.applyImpulse(CGVector(dx: 30, dy: -50 * 0.5))
        ball3.physicsBody?.applyImpulse(CGVector(dx: -50, dy: 40 * 0.5))
        ball4.physicsBody?.applyImpulse(CGVector(dx: 60, dy: 30 * 0.5))
    }
    
    // main menu button setup
    func setupMainMenuBtn() {
        mainMenuBtn.size = CGSize(width: 420, height: 120)
        mainMenuBtn.position = CGPoint(x: 0, y: -(self.frame.height / 2) + 180)
        print(-(self.frame.height / 2) + 200)
        mainMenuBtn.zPosition = 4
        mainMenuBtn.name = "pauseBtn"
        mainMenuBtn.setButtonLabel(title: "Main Menu", font: "Avenir", fontSize: 65, fontColor: UIColor.black)
        mainMenuBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(CompletedGameScene.mainMenuBtnWasPressed))
        self.addChild(mainMenuBtn)
    }
    
    // returns to homeVC
    @objc func mainMenuBtnWasPressed() {
        NotificationCenter.default.post(name: NSNotification.Name("gameOver"), object: nil)
    }
    
    
}
