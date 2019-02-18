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
    
    let settings: [Int: [Double]] = [ 1: [20, 1, 10],
                     2: [25, 0.98, 14],
                     3: [30, 0.95, 16],
                     4: [35, 0.9, 20],
                     5: [40, 0.9, 25],
                     6: [44, 0.87, 30],
                     7: [48, 0.8, 35],
                     8: [52, 0.75, 35],
                     9: [56, 0.75, 40],
                     10: [60, 0.75, 40],
                     11: [65, 0.7, 50],
                     12: [70, 0.6, 50]
                     ]

}
