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
    var scoreLbl = SKLabelNode()
    var timer = SKLabelNode()
    
    var hearts = [SKSpriteNode]()
    
    var score = 0
    var lives = 3
    
    var startCount = true
    var setTime = 61
    var myTime = 0
    
    var velocity = LevelSettings.instance.current_setting[0]
    var reaction = LevelSettings.instance.current_setting[1]
    var scoreToBeat = LevelSettings.instance.current_setting[2]
    
    var currentLevel = LevelSettings.instance.currentLevel
    var availableLevelIndex = UserDefaults.standard.integer(forKey: "availableLevelIndex")
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        mainPaddle = self.childNode(withName: "mainPaddle") as! SKSpriteNode
        enemyPaddle = self.childNode(withName: "enemyPaddle") as! SKSpriteNode
        scoreLbl = self.childNode(withName: "scoreLbl") as! SKLabelNode
        timer = self.childNode(withName: "timer") as! SKLabelNode
        
        for i in 1...3 {
            hearts.append(self.childNode(withName: "heart\(i)") as! SKSpriteNode)
        }
        
        mainPaddle.color = UserDefaults.standard.colorForKey(key: "paddleColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        enemyPaddle.color = UserDefaults.standard.colorForKey(key: "enemyPaddleColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ball.color = UserDefaults.standard.colorForKey(key: "ballColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.backgroundColor = UserDefaults.standard.colorForKey(key: "backgroundTheme") ?? #colorLiteral(red: 0.1490196139, green: 0.1490196139, blue: 0.1490196139, alpha: 1)
        
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
        
        if self.startCount == true {
            self.setTime += Int(currentTime)
            self.startCount = false
        }
        
        self.myTime = self.setTime - Int(currentTime)
        self.timer.text = ("\(self.myTime)")
        
        if self.myTime < 1 {
            if score >= Int(scoreToBeat) {
                nextLevel()
            } else {
                gameOver()
            }
        }
        
        if ball.position.y <= mainPaddle.position.y - 70 {
            // Removes lives
            hearts[lives - 1].removeFromParent()
            lives -= 1
            let rand = Double.random(in: -1 ..< 1)
            ball.position = CGPoint(x: enemyPaddle.position.x, y: enemyPaddle.position.y - enemyPaddle.frame.height / 2)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.applyImpulse(CGVector(dx: -velocity * rand, dy: -velocity))
        } else if ball.position.y >= enemyPaddle.position.y + 70 {
            // Adds points
            score += 1
            scoreLbl.text = "Score: \(score)"
            let rand = Double.random(in: -1 ..< 1)
            ball.position = CGPoint(x: mainPaddle.position.x, y: mainPaddle.position.y + mainPaddle.frame.height / 2)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.applyImpulse(CGVector(dx: velocity * rand, dy: velocity))
        }
        
        if lives < 1 {
            gameOver()
        }
    }
    
    func nextLevel() {
        if currentLevel > availableLevelIndex {
            UserDefaults.standard.set(availableLevelIndex + 1, forKey: "availableLevelIndex")
        }
    }
    
    func gameOver() {
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = SKScene(fileNamed: "GameOverScene")!
        gameOverScene.scaleMode = .aspectFill
        self.view?.presentScene(gameOverScene, transition: reveal)
    }
    
}
