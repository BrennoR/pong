//
//  FreeplaySettings.swift
//  Pong
//
//  Created by Brenno Ribeiro on 2/18/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import Foundation

class FreeplaySettings {
    
    static let instance = FreeplaySettings()    // singleton
    
    var freeplayPlayerNumber: Int = 1   // default player number
    var freeplayMode: Int = 0   // default mode (unlimited)
}
