//
//  GameScene.swift
//  Pong
//
//  Created by Brenno Ribeiro on 12/23/18.
//  Copyright © 2018 Brenno Ribeiro. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    // nodes
    var ball = SKSpriteNode()
    var mainPaddle = SKSpriteNode()
    var enemyPaddle = SKSpriteNode()
    var scoreLbl = SKLabelNode()
    var timer = SKLabelNode()
    var lvlCompletePopUp = SKShapeNode()
    var startGamePopUp = SKShapeNode()
    var gameOverPopUp = SKShapeNode()
    var currentLvlLbl = SKLabelNode()
    var scoreToBeatLbl = SKLabelNode()
    var timeToSurviveLbl = SKLabelNode()
    
    // initialize pop-up buttons
    var startGameBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    var nextLvlBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    var retryBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    var quitBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    
    var hearts = [SKSpriteNode]()
    
    // initiate score and lives
    var score = 0
    var lives = 3
    
    // serving state
    var serving = true
    
    // time variables
    var startCount = false
    var startTheGame = false
    var setTime = 60
    var myTime = 0
    
    // difficulty parameters
    var velocity = LevelSettings.instance.current_setting[0]
    var reaction = LevelSettings.instance.current_setting[1]
    var scoreToBeat = LevelSettings.instance.current_setting[2]
    
    // level variables
    var currentLevel = LevelSettings.instance.currentLevel
    var availableLevelIndex = UserDefaults.standard.integer(forKey: "availableLevelIndex")
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        // child nodes
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        mainPaddle = self.childNode(withName: "mainPaddle") as! SKSpriteNode
        enemyPaddle = self.childNode(withName: "enemyPaddle") as! SKSpriteNode
        scoreLbl = self.childNode(withName: "scoreLbl") as! SKLabelNode
        timer = self.childNode(withName: "timer") as! SKLabelNode
        lvlCompletePopUp = self.childNode(withName: "lvlCompletePopUp") as! SKShapeNode
        startGamePopUp = self.childNode(withName: "startGamePopUp") as! SKShapeNode
        gameOverPopUp = self.childNode(withName: "gameOverPopUp") as! SKShapeNode
        
        // start game pop-up label nodes
        currentLvlLbl = startGamePopUp.childNode(withName: "currentLvlLbl") as! SKLabelNode
        scoreToBeatLbl = startGamePopUp.childNode(withName: "scoreToBeatLbl") as! SKLabelNode
        timeToSurviveLbl = startGamePopUp.childNode(withName: "timeToSurviveLbl") as! SKLabelNode
        currentLvlLbl.text = "Level \(currentLevel)"
        scoreToBeatLbl.text = "Score > \(scoreToBeat)"
        timeToSurviveLbl.text = "Survive > \(setTime) sec"
        
        // pop-up buttons
        setupPopUpBtns()
        
        lvlCompletePopUp.isHidden = true
        gameOverPopUp.isHidden = true
        
        for i in 1...3 {
            hearts.append(self.childNode(withName: "heart\(i)") as! SKSpriteNode)
        }

        // color settings
        mainPaddle.color = UserDefaults.standard.colorForKey(key: "paddleColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        enemyPaddle.color = UserDefaults.standard.colorForKey(key: "enemyPaddleColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ball.color = UserDefaults.standard.colorForKey(key: "ballColor") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.backgroundColor = UserDefaults.standard.colorForKey(key: "backgroundTheme") ?? #colorLiteral(red: 0.1490196139, green: 0.1490196139, blue: 0.1490196139, alpha: 1)
        
        // physics settings
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let w = mainPaddle.frame.width
        let rightOfPaddle = mainPaddle.position.x + w / 2
        let dist = rightOfPaddle - ball.position.x
        let rightOfEnemy = enemyPaddle.position.x + w / 2
        let distEnemy = rightOfEnemy - ball.position.x
        
        let minAngle = CGFloat.pi*1/6
        let maxAngle = CGFloat.pi*5/6
        
        var v = sqrt(pow((ball.physicsBody?.velocity.dx)!, 2) + pow((ball.physicsBody?.velocity.dy)!, 2))
        
        if serving == true {
            v *= 2
            serving = false
        }

        if contact.bodyA.collisionBitMask == 2 || contact.bodyB.collisionBitMask == 2 {
            print(contact.bodyA.node?.name)
            print(contact.bodyB.node?.name)
            
            // contact with main paddle
            if contact.bodyA.node?.name == "mainPaddle" || contact.bodyB.node?.name == "mainPaddle" {
                
                if ball.position.y > mainPaddle.position.y + 15 {
                    let angle = minAngle + (maxAngle - minAngle) * (dist / w)
                    
                    ball.physicsBody?.velocity.dx = CGFloat(v) * cos(angle)
                    ball.physicsBody?.velocity.dy = CGFloat(v) * sin(angle)
                }
            }
            
            // contact with enemy paddle
            if contact.bodyA.node?.name == "enemyPaddle" || contact.bodyB.node?.name == "enemyPaddle" {
                if ball.position.y < enemyPaddle.position.y - 15 {
                    let angle = -minAngle + (-maxAngle + minAngle) * (distEnemy / w)

                    ball.physicsBody?.velocity.dx = CGFloat(v) * cos(angle)
                    ball.physicsBody?.velocity.dy = CGFloat(v) * sin(angle)
                }
            }
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            mainPaddle.run(SKAction.moveTo(x: location.x, duration: 0.07))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            mainPaddle.run(SKAction.moveTo(x: location.x, duration: 0.07))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        enemyPaddle.run(SKAction.moveTo(x: ball.position.x, duration: reaction))
        
        if self.startCount == true {
            self.setTime += Int(currentTime)
            self.startCount = false
        }
        
        if self.startTheGame == true {
            self.myTime = self.setTime - Int(currentTime)
            self.timer.text = ("\(self.myTime)")
            
            if self.myTime < 1 {
                if score >= Int(scoreToBeat) {
                    nextLevel()
                } else {
                    gameOver()
                }
            }
        }
        
        if ball.position.y <= mainPaddle.position.y - 70 {
            // Removes lives
            hearts[lives - 1].removeFromParent()
            lives -= 1
            serve()
        } else if ball.position.y >= enemyPaddle.position.y + 70 {
            // Adds points
            score += 1
            scoreLbl.text = "Score: \(score)"
            serve()
        }
        
        if lives < 1 {
            gameOver()
        }
    }
    
    func serve() {
        serving = true
        enemyPaddle.run(SKAction.moveTo(x: 0, duration: 0.1))
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: velocity * 0.5))
    }
    
    @objc func startGame() {
        startCount = true
        startTheGame = true
//        ball.physicsBody?.applyImpulse(CGVector(dx: velocity, dy: velocity))
        serve()
        startGamePopUp.isHidden = true
    }
    
    func nextLevel() {
        if currentLevel > availableLevelIndex && availableLevelIndex != 11 {
            UserDefaults.standard.set(availableLevelIndex + 1, forKey: "availableLevelIndex")
        }
        lvlCompletePopUp.isHidden = false
        timer.isHidden = true
        ball.removeFromParent()
    }
    
    func gameOver() {
        gameOverPopUp.isHidden = false
        
        physicsWorld.speed = 0
    }
    
    func setupPopUpBtns() {
        setupBtn(btn: startGameBtn, size: CGSize(width: 70, height: 20), position: CGPoint(x: 0, y: -35), title: "Start", name: "startGameBtn")
        startGameBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.startGame))
        startGamePopUp.addChild(startGameBtn)
        
        setupBtn(btn: retryBtn, size: CGSize(width: 70, height: 20), position: CGPoint(x: 0, y: 5), title: "Retry", name: "retryBtn")
        retryBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.retryBtnWasPressed))
        gameOverPopUp.addChild(retryBtn)
        
        setupBtn(btn: quitBtn, size: CGSize(width: 70, height: 20), position: CGPoint(x: 0, y: -26), title: "Quit", name: "quitBtn")
        quitBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.quitBtnWasPressed))
        gameOverPopUp.addChild(quitBtn)
        
        setupBtn(btn: nextLvlBtn, size: CGSize(width: 70, height: 20), position: CGPoint(x: 0, y: -27), title: "Next Lvl", name: "nextLvlBtn")
        nextLvlBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.nextLvlBtnWasPressed))
        lvlCompletePopUp.addChild(nextLvlBtn)
    }
    
    func setupBtn(btn: FTButtonNode, size: CGSize, position: CGPoint, title: NSString, name: String) {
        btn.setButtonLabel(title: title, font: "Avenir", fontSize: 26, fontColor: UIColor.black)
        btn.label.xScale = 0.5
        btn.label.yScale = 0.5
        btn.size = size
        btn.position = position
        btn.zPosition = 4
        btn.name = name
    }
    
    @objc func quitBtnWasPressed() {
        NotificationCenter.default.post(name: NSNotification.Name("gameOver"), object: nil)
    }
    
    @objc func retryBtnWasPressed() {
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameScene = SKScene(fileNamed: "GameScene")!
        gameScene.scaleMode = .aspectFill
        self.view?.presentScene(gameScene, transition: reveal)
    }
    
    @objc func nextLvlBtnWasPressed() {
        LevelSettings.instance.currentLevel = currentLevel + 1
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameScene = SKScene(fileNamed: "GameScene")!
        gameScene.scaleMode = .aspectFill
        self.view?.presentScene(gameScene, transition: reveal)
    }
    
}
