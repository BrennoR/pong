//
//  RoundedShadowButton.swift
//  Pong
//
//  Created by Brenno Ribeiro on 2/16/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import UIKit

class RoundedShadowButton: UIButton {

    override func awakeFromNib() {
        
        self.layer.cornerRadius = 10.0
        self.layer.shadowRadius = 5.0
    }

}
