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
                     2: [48, 0.75, 17, 0.27],
                     3: [51, 0.75, 18, 0.27],
                     4: [54, 0.7, 19, 0.24],
                     5: [57, 0.7, 20, 0.24],
                     6: [60, 0.7, 21, 0.24],
                     7: [63, 0.65, 22, 0.2],
                     8: [66, 0.65, 23, 0.2],
                     9: [69, 0.65, 24, 0.2],
                     10: [75, 0.6, 25, 0.18],
                     11: [80, 0.6, 27, 0.17],
                     12: [85, 0.5, 30, 0.16]
                     ]

}
