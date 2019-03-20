//
//  GameScene.swift
//  Pong
//
//  Created by Brenno Ribeiro on 12/23/18.
//  Copyright © 2018 Brenno Ribeiro. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
import GameKit

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
    var pausePopUp = SKShapeNode()
    var currentLvlLbl = SKLabelNode()
    var scoreToBeatLbl = SKLabelNode()
    var timeToSurviveLbl = SKLabelNode()
    
    // initialize pop-up buttons
    var startGameBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    var nextLvlBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    var retryBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    var quitBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    var pauseBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "pause_btn"), selectedTexture: SKTexture.init(imageNamed: "pause_btn"), disabledTexture: SKTexture.init(imageNamed: "pause_btn"))
    var continueBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    var restartBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    var quitBtn2 = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    
    // heart live sprites
    var hearts = [SKSpriteNode]()
    
    // sounds
    var sounds = AudioSettings.instance.sounds
    
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
    var oldTime = 0
    var wasPaused = false
    
    // difficulty parameters
    var velocity = LevelSettings.instance.current_setting[0]
    var reaction = LevelSettings.instance.current_setting[1]
    var scoreToBeat = LevelSettings.instance.current_setting[2]
    var mainPaddleSizeFactor = LevelSettings.instance.current_setting[3]
    
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
        pausePopUp = self.childNode(withName: "pausePopUp") as! SKShapeNode
        
        // start game pop-up label nodes
        currentLvlLbl = startGamePopUp.childNode(withName: "currentLvlLbl") as! SKLabelNode
        scoreToBeatLbl = startGamePopUp.childNode(withName: "scoreToBeatLbl") as! SKLabelNode
        timeToSurviveLbl = startGamePopUp.childNode(withName: "timeToSurviveLbl") as! SKLabelNode
        currentLvlLbl.text = "Level \(currentLevel)"
        scoreToBeatLbl.text = "Score > \(scoreToBeat)"
        timeToSurviveLbl.text = "Survive > \(setTime) sec"
        
        // pause button
        pauseBtn.size = CGSize(width: 75, height: 75)
        pauseBtn.position = CGPoint(x: -15, y: (self.frame.height / 2) - 50)
        print(-(self.frame.height / 2) + 200)
        pauseBtn.zPosition = 4
        pauseBtn.name = "pauseBtn"
        pauseBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(FreeplayScene.pauseBtnWasPressed))
        self.addChild(pauseBtn)
        pauseBtn.isEnabled = false
        
        // pop-up buttons
        setupPopUpBtns()
        
        // hide pop-ups
        lvlCompletePopUp.isHidden = true
        pausePopUp.isHidden = true
        gameOverPopUp.isHidden = true
        
        // paddle sizes
        mainPaddle.size.width = self.frame.size.width * CGFloat(mainPaddleSizeFactor)
        
        // heart sprites
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
        border.collisionBitMask = 3
        
        self.physicsBody = border
        
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
    
    // touch functionality
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
        
        // sets timer on start of match
        if self.startCount == true {
            self.setTime += Int(currentTime)
            self.startCount = false
        }
        
        // adjust timer after pausing
        if self.wasPaused == true {
            self.setTime += (oldTime - (self.setTime - Int(currentTime)))
            self.wasPaused = false
        }
        
        if self.startTheGame == true {
            self.myTime = self.setTime - Int(currentTime)
            self.timer.text = ("\(self.myTime)")
            
            if self.myTime < 1 {
                if score >= Int(scoreToBeat) {
                    updateLeaderboard()
                    if currentLevel < 12 {
                        nextLevel()
                    } else {
                        revealScene(Filename: "CompletedGameScene")
                    }
                } else {
                    gameOver()
                }
                self.isPaused = true
            }
        }
        
        if ball.position.y <= mainPaddle.position.y - 70 {
            // Removes lives
            AudioSettings.instance.playSound(soundIndex: 2)
            hearts[lives - 1].removeFromParent()
            lives -= 1
            serve()
        } else if ball.position.y >= enemyPaddle.position.y + 70 {
            // Adds points
            AudioSettings.instance.playSound(soundIndex: 2)
            score += 1
            scoreLbl.text = "Score: \(score)"
            serve()
        }
        
        if lives < 1 {
            gameOver()
        }
    }
    
    // serving function
    func serve() {
        serving = true
        enemyPaddle.run(SKAction.moveTo(x: 0, duration: 0.1))
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: velocity * 0.5))
    }
    
    // initializes start variables and performs initial ball serve
    @objc func startGame() {
        startCount = true
        startTheGame = true
        serve()
        pauseBtn.isEnabled = true
        startGamePopUp.isHidden = true
    }
    
    // updates unlocked levels and presents next level pop-up
    func nextLevel() {
        if currentLevel > availableLevelIndex && availableLevelIndex < 11 {
            UserDefaults.standard.set(availableLevelIndex + 1, forKey: "availableLevelIndex")
        }
        lvlCompletePopUp.isHidden = false
        timer.isHidden = true
        ball.removeFromParent()
    }
    
    // presents game over pop-up
    func gameOver() {
        lvlCompletePopUp.removeFromParent()
        gameOverPopUp.isHidden = false
        self.isPaused = true
    }
    
    // button setup
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
        
        setupBtn(btn: continueBtn, size: CGSize(width: 60, height: 20), position: CGPoint(x: 0, y: 15), title: "Continue", name: "continueBtn")
        continueBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(FreeplayScene.continueBtnWasPressed))
        pausePopUp.addChild(continueBtn)
        
        setupBtn(btn: restartBtn, size: CGSize(width: 60, height: 20), position: CGPoint(x: 0, y: -10), title: "Restart", name: "restartBtn")
        restartBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(FreeplayScene.retryBtnWasPressed))
        pausePopUp.addChild(restartBtn)
        
        setupBtn(btn: quitBtn2, size: CGSize(width: 60, height: 20), position: CGPoint(x: 0, y: -35), title: "Quit", name: "quitBtn2")
        quitBtn2.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(FreeplayScene.quitBtnWasPressed))
        pausePopUp.addChild(quitBtn2)
    }
    
    // button setup helper function
    func setupBtn(btn: FTButtonNode, size: CGSize, position: CGPoint, title: NSString, name: String) {
        btn.setButtonLabel(title: title, font: "Avenir", fontSize: 26, fontColor: UIColor.black)
        btn.label.xScale = 0.5
        btn.label.yScale = 0.5
        btn.size = size
        btn.position = position
        btn.zPosition = 4
        btn.name = name
    }
    
    // returns to homeVC
    @objc func quitBtnWasPressed() {
        NotificationCenter.default.post(name: NSNotification.Name("gameOver"), object: nil)
    }
    
    // interstitial ad pop-up
    func showInterstitial() {
        NotificationCenter.default.post(name: NSNotification.Name("showInterstitial"), object: nil)
    }
    
    // reloads scene with the settings of the next level
    @objc func nextLvlBtnWasPressed() {
        if currentLevel < 12 {
            LevelSettings.instance.currentLevel = currentLevel + 1
            LevelSettings.instance.current_setting = LevelSettings.instance.settings[currentLevel + 1]!
        }
        
        if currentLevel % 2 == 0 {
            showInterstitial()
        }
        
        revealScene(Filename: "GameScene")
    }
    
    // reloads scene
    @objc func retryBtnWasPressed() {
        revealScene(Filename: "GameScene")
    }
    
    // scene loading function
    @objc func revealScene(Filename: String) {
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameScene = SKScene(fileNamed: Filename)!
        gameScene.scaleMode = .aspectFill
        self.view?.presentScene(gameScene, transition: reveal)
    }
    
    // pauses game and presents pause pop-up
    @objc func pauseBtnWasPressed() {
        self.isPaused = true
        oldTime = myTime
        pausePopUp.isHidden = false
    }
    
    // continues game from pause pop-up
    @objc func continueBtnWasPressed() {
        self.isPaused = false
        self.wasPaused = true
        pausePopUp.isHidden = true
    }

    // sends highscores to leaderboard
    func updateLeaderboard() {
        var highScore = UserDefaults.standard.array(forKey: "scoreArray") as? [Int] ?? [Int](repeating: 0, count: 12)
        if score > highScore[currentLevel - 1] {
            let bestScoreInt = GKScore(leaderboardIdentifier: "grp.boards.level_\(currentLevel)")
            bestScoreInt.value = Int64(score)
            
            GKScore.report([bestScoreInt]) { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Best Score submitted to your Leaderboard!")
                }
            }
            highScore[currentLevel - 1] = score
            UserDefaults.standard.set(highScore, forKey: "scoreArray")
        }
    }
    
}
