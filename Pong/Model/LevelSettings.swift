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
    
    let settings: [Int: [Double]] = [ 1: [20, 1],
                     2: [25, 0.98],
                     3: [30, 0.95],
                     4: [35, 0.9],
                     5: [40, 0.9],
                     6: [44, 0.87],
                     7: [48, 0.8],
                     8: [52, 0.75],
                     9: [56, 0.75],
                     10: [60, 0.75],
                     11: [65, 0.7],
                     12: [70, 0.6]
                     ]

}
