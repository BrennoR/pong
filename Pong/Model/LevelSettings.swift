//
//  LevelSettings.swift
//  Pong
//
//  Created by Brenno Ribeiro on 2/10/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import Foundation

// settings for levels in career mode
class LevelSettings {
    
    static let instance = LevelSettings()   // singleton
    
    var current_setting: [Double] = []  // current settings variable used in GameScene
    
    var currentLevel: Int = 1   // current level variable used in GameScene
    
    // settings, format - [level: speed, enemy reaction time, score to beat, main paddle size]
    let settings: [Int: [Double]] = [ 1: [45, 0.75, 15, 0.27],
                     2: [48, 0.75, 15, 0.27],
                     3: [51, 0.75, 20, 0.27],
                     4: [54, 0.7, 20, 0.24],
                     5: [57, 0.7, 25, 0.24],
                     6: [60, 0.7, 25, 0.24],
                     7: [63, 0.65, 25, 0.2],
                     8: [66, 0.65, 30, 0.2],
                     9: [69, 0.65, 30, 0.2],
                     10: [75, 0.6, 35, 0.18],
                     11: [80, 0.6, 35, 0.17],
                     12: [85, 0.5, 40, 0.16]
                     ]

}
