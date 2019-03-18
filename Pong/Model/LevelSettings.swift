//
//  LevelSettings.swift
//  Pong
//
//  Created by Brenno Ribeiro on 2/10/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import Foundation

class LevelSettings {
    
    static let instance = LevelSettings()
    
    var current_setting: [Double] = []
    
    var currentLevel: Int = 1
    
    let settings: [Int: [Double]] = [ 1: [45, 0.87, 5, 0.27],
                     2: [48, 0.87, 5, 0.27],
                     3: [51, 0.87, 10, 0.27],
                     4: [54, 0.8, 10, 0.24],
                     5: [57, 0.8, 10, 0.24],
                     6: [60, 0.8, 10, 0.24],
                     7: [63, 0.75, 10, 0.2],
                     8: [66, 0.75, 10, 0.2],
                     9: [69, 0.75, 10, 0.2],
                     10: [75, 0.75, 10, 0.18],
                     11: [80, 0.7, 10, 0.17],
                     12: [85, 0.6, 0, 0.16]
                     ]

}
