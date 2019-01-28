//
//  GameScene.swift
//  Pong
//
//  Created by Brenno Ribeiro on 12/23/18.
//  Copyright © 2018 Brenno Ribeiro. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var ball = SKSpriteNode()
    var mainPaddle = SKSpriteNode()
    var enemyPaddle = SKSpriteNode()
    
    var score = [Int]()
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        mainPaddle = self.childNode(withName: "mainPaddle") as! SKSpriteNode
        enemyPaddle = self.childNode(withName: "enemyPaddle") as! SKSpriteNode
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 20))
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            mainPaddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            mainPaddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        enemyPaddle.run(SKAction.moveTo(x: ball.position.x, duration: 1))
        
        if ball.position.y <= mainPaddle.position.y - 70 {
            // Removes lives
            ball.position = CGPoint(x: 0, y: 0)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.applyImpulse(CGVector(dx: -20, dy: -20))
        } else if ball.position.y >= enemyPaddle.position.y + 70 {
            // Adds points
            ball.position = CGPoint(x: 0, y: 0)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 20))
        }
    }
}
