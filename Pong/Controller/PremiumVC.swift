//
//  PremiumVC.swift
//  Pong
//
//  Created by Brenno Ribeiro on 3/18/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import UIKit

class PremiumVC: UIViewController {
    
    @IBOutlet weak var premiumPopup: UIView!    // pop-up view outlet
    
    override func viewDidLoad() {
        super.viewDidLoad()
        premiumPopup.layer.cornerRadius = premiumPopup.frame.height * 0.08  // round pop-up corners
    }
    
    // dismiss view
    @IBAction func dismissView(_ sender: Any) {
        view.removeFromSuperview()
    }
    
    // initalizes buy premium process in purchase manager
    @IBAction func buyNowBtnWasPressed(_ sender: Any) {
        PurchaseManager.instance.purchasePremium { success in
            if success {
                NotificationCenter.default.post(name: Notification.Name("ADS"), object: nil)
            } else {
                
            }
        }
    }
    
    // initializes purchase restoration process in purchase manager
    @IBAction func restorePurchaseBtnWasPressed(_ sender: Any) {
        PurchaseManager.instance.restorePurchases { success in
            if success {
                NotificationCenter.default.post(name: Notification.Name("ADS"), object: nil)
            } else {
                
            }
        }
    }

}
