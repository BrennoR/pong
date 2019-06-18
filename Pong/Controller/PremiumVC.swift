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
        PurchaseManager.instance.fetchProducts()
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
                self.showTransactionErrorAlert()
            }
        }
    }
    
    // initializes purchase restoration process in purchase manager
    @IBAction func restorePurchaseBtnWasPressed(_ sender: Any) {
        PurchaseManager.instance.restorePurchases { success in
            if success {
                NotificationCenter.default.post(name: Notification.Name("ADS"), object: nil)
            } else {
                self.showTransactionErrorAlert()
            }
        }
    }
    
    // presents alert if transactions cannot be completed
    func showTransactionErrorAlert() {
        let errorAlert = UIAlertController(title: "Error", message: "There was an error with your transaction, please go back and try again.", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Go Back", style: .default, handler: { (UIAlertAction) in
            errorAlert.dismiss(animated: true, completion: nil)
        }))
        self.present(errorAlert, animated: true, completion: nil)
    }

}
