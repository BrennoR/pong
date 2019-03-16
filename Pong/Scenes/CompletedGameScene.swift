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
    
    var mainMenuBtn = FTButtonNode(normalTexture: SKTexture.init(imageNamed: "btn-texture"), selectedTexture: SKTexture.init(imageNamed: "btn-texture"), disabledTexture: SKTexture.init(imageNamed: "btn-texture"))
    
    override func didMove(to view: SKView) {
        mainMenuBtn.size = CGSize(width: 420, height: 120)
        mainMenuBtn.position = CGPoint(x: 0, y: -(self.frame.height / 2) + 180)
        print(-(self.frame.height / 2) + 200)
        mainMenuBtn.zPosition = 4
        mainMenuBtn.name = "pauseBtn"
        mainMenuBtn.setButtonLabel(title: "Main Menu", font: "Avenir", fontSize: 65, fontColor: UIColor.black)
        mainMenuBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(CompletedGameScene.mainMenuBtnWasPressed))
        self.addChild(mainMenuBtn)
    }
    
    @objc func mainMenuBtnWasPressed() {
        NotificationCenter.default.post(name: NSNotification.Name("gameOver"), object: nil)
    }
    
}
