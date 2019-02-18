//
//  GameOverPopUpVC.swift
//  Pong
//
//  Created by Brenno Ribeiro on 2/16/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import UIKit

class GameOverPopUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func retryBtnWasPressed(_ sender: Any) {
        
    }
    
    @IBAction func homeBtnWasPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "overToHomeSeg", sender: nil)
    }
    

}
