//
//  HomeVC.swift
//  Pong
//
//  Created by Brenno Ribeiro on 1/26/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnTest(_ sender: Any) {
        performSegue(withIdentifier: "testSeg", sender: nil)
    }
    
}
