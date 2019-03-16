//
//  BorderButton.swift
//  Pong
//
//  Created by Brenno Ribeiro on 2/16/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import UIKit

class BorderButton: UIButton {

    override func awakeFromNib() {
//        self.layer.borderWidth = 1.0
//        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.cornerRadius = self.frame.height * 0.24
        self.clipsToBounds = true
    }

}
