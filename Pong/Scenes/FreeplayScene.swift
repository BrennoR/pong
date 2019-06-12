//
//  GameOverScene.swift
//  Pong
//
//  Created by Brenno Ribeiro on 2/16/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import SpriteKit
import GameplayKit

class FreeplayScene: SKScene, SKPhysicsContactDelegate {
    
    // nodes
    var ball = SKSpriteNode()
    var mainPaddle = SKSpriteNode()
    var enemyPaddle = SKSpriteNode()
    var scoreLbl = SKLabelNode()
    var enemyScoreLbl = SKLabelNode()
    
    // pop-up nodes
    var popUp = SKShapeNode()
    var popUpLbl = SKLabelNode()
    var popUpScoreLbl = SKLabelNode()
    var popUpScoreLbl2 = SKLabelNode()
    var pausePopUp = SKShapeNode()
    
    // pop-up buttons
    var pauseBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "pause_btn"), selectedTexture: SKTexture.init(imageNamed: "pause_btn"), disabledTexture: SKTexture.init(imageNamed: "pause_btn"))
    var retryBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    var quitBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    var continueBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    var restartBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    var quitBtn2 = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    
    // game mode
    var playerNumber = FreeplaySettings.instance.freeplayPlayerNumber
    var mode = FreeplaySettings.instance.freeplayMode   // 0 = unlimited, 1 = three lives
    
    // hearts
    var hearts = [SKSpriteNode]()
    var enemyHearts = [SKSpriteNode]()
    
    // sounds
    var sounds = AudioSettings.instance.sounds
    
    // lives
    var lives = 3
    var enemyLives = 3
    
    // serving state
    var serving = true
    
    // score
    var score = 0
    var enemyScore = 0
    
    // velocity variable
    var velocity: Float = 63.0
    
    // names
    var playerName = "Your Score"
    var enemyName = "Enemy"
    
    // ad timer
    var startCount = true
    var startTime = 0
    var timer = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        // child nodes
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        mainPaddle = self.childNode(withName: "mainPaddle") as! SKSpriteNode
        enemyPaddle = self.childNode(withName: "enemyPaddle") as! SKSpriteNode
        scoreLbl = self.childNode(withName: "scoreLbl") as! SKLabelNode
        enemyScoreLbl = self.childNode(withName: "enemyScoreLbl") as! SKLabelNode
        popUp = self.childNode(withName: "popUp") as! SKShapeNode
        popUpLbl = popUp.childNode(withName: "popUpLbl") as! SKLabelNode
        popUpScoreLbl = popUp.childNode(withName: "popUpScoreLbl") as! SKLabelNode
        popUpScoreLbl2 = popUp.childNode(withName: "popUpScoreLbl2") as! SKLabelNode
        pausePopUp = self.childNode(withName: "pausePopUp") as! SKShapeNode
        
        // hide pop-ups
        popUp.isHidden = true
        pausePopUp.isHidden = true
        
        // pause button
        pauseBtn.size = CGSize(width: 75, height: 75)
        pauseBtn.position = CGPoint(x: 0, y: (self.frame.height / 2) - 65)
        pauseBtn.zPosition = 4
        pauseBtn.name = "pauseBtn"
        pauseBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(FreeplayScene.pauseBtnWasPressed))
        self.addChild(pauseBtn)
        
        // quit and retry buttons
        setupPopUpBtns()
        
        // serve ball
        var rand: Float = 1.0
        if playerNumber == 2 {  // random direction if two-player game
            rand = sign(Float.random(in: -1 ... 1))
        }
        serve(sign: rand)
        
        // lives
        for i in 1...3 {
            hearts.append(self.childNode(withName: "heart\(i)") as! SKSpriteNode)
            enemyHearts.append(self.childNode(withName: "enemyHeart\(i)") as! SKSpriteNode)
        }
        
        // adjust names based on player number
        if playerNumber == 2 {
            playerName = "Player 1"
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
        self.backgroundColor = UserDefaults.standard.colorForKey(key: "backgroundTheme") ?? #colorLiteral(red: 0.07843137255, green: 0.5568627451, blue: 1, alpha: 1)
        
        // physics
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        border.collisionBitMask = 3
        
        self.physicsBody = border
    }
    
    // touch functionality
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        let w = mainPaddle.frame.width
        let rightOfPaddle = mainPaddle.position.x + w / 2
        let dist = rightOfPaddle - ball.position.x
        let rightOfEnemy = enemyPaddle.position.x + w / 2
        let distEnemy = rightOfEnemy - ball.position.x
        
        let minAngle = CGFloat.pi * 2/6
        let maxAngle = CGFloat.pi * 4/6
        
        var v = sqrt(pow((ball.physicsBody?.velocity.dx)!, 2) + pow((ball.physicsBody?.velocity.dy)!, 2))
        
        if serving == true {
            v *= 2
            serving = false
        }
        
        if contact.bodyA.collisionBitMask == 2 || contact.bodyB.collisionBitMask == 2 {
            AudioSettings.instance.playSound(soundIndex: 0)
            
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
        
        // contact with wall
        if contact.bodyA.collisionBitMask == 3 || contact.bodyB.collisionBitMask == 3 {
            AudioSettings.instance.playSound(soundIndex: 1)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if playerNumber == 1 {
            enemyPaddle.run(SKAction.moveTo(x: ball.position.x, duration: 0.5))
        }
        
        // sets timer on start of match
        if startCount == true {
            self.startTime = Int(currentTime)
            startCount = false
        }
        
        if ball.position.y <= mainPaddle.position.y - 70 {
            AudioSettings.instance.playSound(soundIndex: 2)
            if mode == 1 {
                // removes lives
                lives -= 1
                hearts[lives].removeFromParent()
            }
            
            enemyScore += 1
            enemyScoreLbl.text = "\(enemyScore)"
            
            serve(sign: 1)
            
        } else if ball.position.y >= enemyPaddle.position.y + 70 {
            // adds to score
            AudioSettings.instance.playSound(soundIndex: 2)
            score += 1
            scoreLbl.text = "\(score)"
            if mode == 1 && playerNumber == 2 {
                enemyLives -= 1
                enemyHearts[enemyLives].removeFromParent()
            }
            
            if playerNumber == 1 {
                serve(sign: 1)
            } else {
                serve(sign: -1)
            }

        }
        
        // end-game pop-up labels
        if lives <  1 {
            gameOver()
            if playerNumber == 1 {
                popUpLbl.text = "Game Over"
            } else {
                popUpLbl.text = "\(enemyName) Wins"
            }
        } else if enemyLives < 1 {
            gameOver()
            popUpLbl.text = "Player 1 Wins"
        }
        
    }
    
    // serving function
    func serve(sign: Float) {
        serving = true
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: Int(velocity * sign * 0.5)))
    }
    
    // paddle movement 
    func paddleMovement(location: CGPoint) {
        if location.y < 0 {
            mainPaddle.run(SKAction.moveTo(x: location.x, duration: 0.1))
        } else if location.y > 0 && playerNumber == 2 {
            enemyPaddle.run(SKAction.moveTo(x: location.x, duration: 0.1))
        }
    }
    
    // button setup
    func setupPopUpBtns() {
        setupBtn(btn: retryBtn, size: CGSize(width: 60, height: 17), position: CGPoint(x: 0, y: -12), title: "Retry", name: "retryBtn", yscale: 0.42)
        retryBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(FreeplayScene.retryBtnWasPressed))
        popUp.addChild(retryBtn)
        
        setupBtn(btn: quitBtn, size: CGSize(width: 60, height: 17), position: CGPoint(x: 0, y: -35), title: "Quit", name: "quitBtn", yscale: 0.42)
        quitBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(FreeplayScene.quitBtnWasPressed))
        popUp.addChild(quitBtn)
        
        setupBtn(btn: continueBtn, size: CGSize(width: 60, height: 20), position: CGPoint(x: 0, y: 15), title: "Continue", name: "continueBtn", yscale: 0.5)
        continueBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(FreeplayScene.continueBtnWasPressed))
        pausePopUp.addChild(continueBtn)
        
        setupBtn(btn: restartBtn, size: CGSize(width: 60, height: 20), position: CGPoint(x: 0, y: -10), title: "Restart", name: "restartBtn", yscale: 0.5)
        restartBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(FreeplayScene.retryBtnWasPressed))
        pausePopUp.addChild(restartBtn)
        
        setupBtn(btn: quitBtn2, size: CGSize(width: 60, height: 20), position: CGPoint(x: 0, y: -35), title: "Quit", name: "quitBtn2", yscale: 0.5)
        quitBtn2.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(FreeplayScene.quitBtnWasPressed))
        pausePopUp.addChild(quitBtn2)
    }
    
    // button setup helper function
    func setupBtn(btn: FTButtonNode, size: CGSize, position: CGPoint, title: NSString, name: String, yscale: CGFloat) {
        btn.setButtonLabel(title: title, font: "Avenir", fontSize: 26, fontColor: UIColor.black)
        btn.label.xScale = 0.5
        btn.label.yScale = yscale
        btn.size = size
        btn.position = position
        btn.zPosition = 4
        btn.name = name
    }
    
    // interstitial ad pop-up
    func showInterstitial() {
        NotificationCenter.default.post(name: NSNotification.Name("showInterstitial"), object: nil)
    }
    
    // pauses game and presents pause pop-up
    @objc func pauseBtnWasPressed() {
        physicsWorld.speed = 0
        pausePopUp.isHidden = false
    }
    
    // presents game over pop-up
    @objc func gameOver() {
        physicsWorld.speed = 0
        popUpScoreLbl.text = "\(playerName): \(score)"
        popUpScoreLbl2.text = "\(enemyName): \(enemyScore)"
        popUp.isHidden = false
        pauseBtn.isEnabled = false
    }
    
    // continues game from pause pop-up
    @objc func continueBtnWasPressed() {
        physicsWorld.speed = 1
        pausePopUp.isHidden = true
    }
    
    // reloads scene
    @objc func retryBtnWasPressed() {
        if timer >= 90 {
            showInterstitial()
            freeplayHold = true
            pausePopUp.isHidden = true
        } else {
            revealScene(Filename: "FreeplayScene")
        }
    }
    
    // returns to homeVC
    @objc func quitBtnWasPressed() {
        if timer >= 90 {
            showInterstitial()
            gameOverHold = true
            pausePopUp.isHidden = true
        } else {
            NotificationCenter.default.post(name: NSNotification.Name("gameOver"), object: nil)
        }
    }
    
    // scene loading function
    @objc func revealScene(Filename: String) {
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameScene = SKScene(fileNamed: Filename)!
        gameScene.scaleMode = .aspectFit
        self.view?.presentScene(gameScene, transition: reveal)
    }
    
}
