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
    
    let settings: [Int: [Double]] = [ 1: [35, 1, 5],
                     2: [40, 0.98, 5],
                     3: [40, 0.95, 10],
                     4: [40, 0.9, 10],
                     5: [40, 0.9, 10],
                     6: [44, 0.87, 10],
                     7: [48, 0.8, 10],
                     8: [52, 0.75, 10],
                     9: [56, 0.75, 10],
                     10: [60, 0.75, 10],
                     11: [65, 0.7, 10],
                     12: [70, 0.6, 10]
                     ]

}
