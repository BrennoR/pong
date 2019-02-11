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
    var lives = 3
    
    var velocity = LevelSettings.instance.current_setting[0]
    var reaction = LevelSettings.instance.current_setting[1]
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        mainPaddle = self.childNode(withName: "mainPaddle") as! SKSpriteNode
        enemyPaddle = self.childNode(withName: "enemyPaddle") as! SKSpriteNode
        
        ball.physicsBody?.applyImpulse(CGVector(dx: velocity, dy: velocity))
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            mainPaddle.run(SKAction.moveTo(x: location.x, duration: 0.1))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            mainPaddle.run(SKAction.moveTo(x: location.x, duration: 0.1))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        enemyPaddle.run(SKAction.moveTo(x: ball.position.x, duration: reaction))
        
        if ball.position.y <= mainPaddle.position.y - 70 {
            // Removes lives
            lives -= 1
            let rand = Double.random(in: -1 ..< 1)
            ball.position = CGPoint(x: enemyPaddle.position.x, y: enemyPaddle.position.y - enemyPaddle.frame.height / 2)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.applyImpulse(CGVector(dx: -velocity * rand, dy: -velocity))
        } else if ball.position.y >= enemyPaddle.position.y + 70 {
            // Adds points
            let rand = Double.random(in: -1 ..< 1)
            print(rand)
            ball.position = CGPoint(x: mainPaddle.position.x, y: mainPaddle.position.y - mainPaddle.frame.height / 2)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.applyImpulse(CGVector(dx: velocity * rand, dy: velocity))
        }
    }
}
