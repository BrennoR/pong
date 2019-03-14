//
//  GameOverScene.swift
//  Pong
//
//  Created by Brenno Ribeiro on 2/16/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import SpriteKit
import GameplayKit

class FreeplayScene: SKScene {
    
    // nodes
    var ball = SKSpriteNode()
    var mainPaddle = SKSpriteNode()
    var enemyPaddle = SKSpriteNode()
    var scoreLbl = SKLabelNode()
    var enemyScoreLbl = SKLabelNode()
    var popUp = SKShapeNode()
    var popUpLbl = SKLabelNode()
    var popUpScoreLbl = SKLabelNode()
    
    // game mode
    var playerNumber = FreeplaySettings.instance.freeplayPlayerNumber
    var mode = FreeplaySettings.instance.freeplayMode   // 0 = unlimited, 1 = three lives
    
    // hearts
    var hearts = [SKSpriteNode]()
    var enemyHearts = [SKSpriteNode]()
    
    // lives
    var lives = 3
    var enemyLives = 3
    
    // serving state
    var serving = true
    
    // score
    var score = 0
    var enemyScore = 0
    
    var velocity = 40
    
    // enemy name
    var enemyName = "Enemy"
    
    override func didMove(to view: SKView) {
        // nodes
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        mainPaddle = self.childNode(withName: "mainPaddle") as! SKSpriteNode
        enemyPaddle = self.childNode(withName: "enemyPaddle") as! SKSpriteNode
        scoreLbl = self.childNode(withName: "scoreLbl") as! SKLabelNode
        enemyScoreLbl = self.childNode(withName: "enemyScoreLbl") as! SKLabelNode
        popUp = self.childNode(withName: "popUp") as! SKShapeNode
        popUpLbl = popUp.childNode(withName: "popUpLbl") as! SKLabelNode
        popUpScoreLbl = popUp.childNode(withName: "popUpScoreLbl") as! SKLabelNode
        
        popUp.isHidden = true
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 40, dy: 40))
        
        // lives
        for i in 1...3 {
            hearts.append(self.childNode(withName: "heart\(i)") as! SKSpriteNode)
            enemyHearts.append(self.childNode(withName: "enemyHeart\(i)") as! SKSpriteNode)
        }
        
        // remove enemy label
        if playerNumber == 2 {
//            enemyScoreLbl.removeFromParent()
            enemyName = "Player 2"
        }
        
        // set game mode
        if mode == 0 {
            for i in 0...2 {
                hearts[i].removeFromParent()
                enemyHearts[i].removeFromParent()
            }
        } else {
            if playerNumber == 1 {
                for i in 0...2 {
                    enemyHearts[i].removeFromParent()
                }
            }
        }
        
        // color settings
        mainPaddle.color = UserDefaults.standard.colorForKey(key: "paddleColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        enemyPaddle.color = UserDefaults.standard.colorForKey(key: "enemyPaddleColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ball.color = UserDefaults.standard.colorForKey(key: "ballColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.backgroundColor = UserDefaults.standard.colorForKey(key: "backgroundTheme") ?? #colorLiteral(red: 0.1490196139, green: 0.1490196139, blue: 0.1490196139, alpha: 1)
        
        // physics
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddleMovement(location: location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddleMovement(location: location)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if playerNumber == 1 {
            enemyPaddle.run(SKAction.moveTo(x: ball.position.x, duration: 0.8))
        }
        
        if ball.position.y <= mainPaddle.position.y - 70 {
            if mode == 1 {
                lives -= 1
                hearts[lives].removeFromParent()
            }
            
//            if playerNumber == 2 {
                enemyScore += 1
                enemyScoreLbl.text = "\(enemyScore)"
//            }
            
            let rand = Double.random(in: -1 ..< 1)
            ball.position = CGPoint(x: mainPaddle.position.x, y: mainPaddle.position.y + mainPaddle.frame.height / 2)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.applyImpulse(CGVector(dx: 40 * rand, dy: 40))
            
        } else if ball.position.y >= enemyPaddle.position.y + 70 {
            score += 1
            scoreLbl.text = "\(score)"
            if mode == 1 && playerNumber == 2 {
                enemyLives -= 1
                enemyHearts[enemyLives].removeFromParent()
            }
            
            let rand = Double.random(in: -1 ..< 1)
            ball.position = CGPoint(x: enemyPaddle.position.x, y: enemyPaddle.position.y - enemyPaddle.frame.height / 2)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.applyImpulse(CGVector(dx: -40 * rand, dy: -40))
        }
        
        if lives <  1 {
            gameOver()
            popUpLbl.text = "\(enemyName) Wins"
        } else if enemyLives < 1 {
            gameOver()
            popUpLbl.text = "Player 1 Wins"
        }
        
    }
    
    func serve(speed: Float) {
//        serving = true
//        ball.position = CGPoint(x: 0, y: 0)
//        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//        ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: velocity * speed))
    }
    
    // paddle movement 
    func paddleMovement(location: CGPoint) {
        if location.y < 0 {
            mainPaddle.run(SKAction.moveTo(x: location.x, duration: 0.1))
        } else if location.y > 0 && playerNumber == 2 {
            enemyPaddle.run(SKAction.moveTo(x: location.x, duration: 0.1))
        }
    }
    
    func gameOver() {
        physicsWorld.speed = 0
        popUpScoreLbl.text = "Player 1: \(score)\n\(enemyName): \(enemyScore)"
        popUp.isHidden = false
    }
    
}
