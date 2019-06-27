//
//  PurchaseManager2.swift
//  Pong
//
//  Created by Brenno Ribeiro on 6/26/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

//typealias CompletionHandler = (_ success: Bool) -> ()

import Foundation
import StoreKit
import SwiftyStoreKit

var sharedSecret = "4497b05ac690472884a1677ff2e8d38b"

enum RegisteredPurchase : String {
    case Premium = "premium"
}

class NetworkActivityIndicatorManager: NSObject {
    
    private static var loadingCount = 0
    
    class func NetworkOperationStarted() {
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
    }
    
    class func NetworkOperationFinished() {
        if loadingCount > 0 {
            loadingCount -= 1
        }
        
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}

class PurchaseManager2: NSObject {
    
    static let instance = PurchaseManager2() // singleton
    
    let bundleID = "com.brennoribeiro.Pong"
    let IAP_PREMIUM = "com.brennoribeiro.Pong.premium"  // premium IAP ID
    
    let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
    
    func getInfo(purchase: RegisteredPurchase) {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([bundleID + "." + purchase.rawValue], completion: {
            result in
            NetworkActivityIndicatorManager.NetworkOperationFinished()
            
        })
    }
    
    func purchase(purchase: RegisteredPurchase) {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.purchaseProduct(bundleID + "." + purchase.rawValue, completion: {
            result in
            NetworkActivityIndicatorManager.NetworkOperationFinished()
            
            if case .success(let product) = result {
                
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                UserDefaults.standard.set(true, forKey: self.IAP_PREMIUM)
                NotificationCenter.default.post(name: Notification.Name("ADS"), object: nil) // TESTING
//                onComplete(true)
            } else {
//                onComplete(false)
            }
            
        })

    }
    
    func restorePurchases() {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true, completion: {
            result in
            NetworkActivityIndicatorManager.NetworkOperationFinished()
            
            for product in result.restoredPurchases {
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
            }
            UserDefaults.standard.set(true, forKey: self.IAP_PREMIUM)
            NotificationCenter.default.post(name: Notification.Name("ADS"), object: nil) // TESTING
            
        })
    }
    
    func verifyReceipt() {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: {
            result in
            NetworkActivityIndicatorManager.NetworkOperationFinished()
            
            if case .error(let error) = result {
                if case .noReceiptData = error {
                    self.verifyReceipt()
                }
            }
            
        })
        
    }
    func verifyPurchase(product: RegisteredPurchase) {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: {
            result in
            NetworkActivityIndicatorManager.NetworkOperationFinished()
            
            switch result{
            case .success(let receipt):
                
                let productID = self.bundleID + "." + product.rawValue
                let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: productID, inReceipt: receipt)

            case .error(let error):
                if case .noReceiptData = error {
                    self.verifyReceipt()
                }
                
            }
            
            
        })
        
    }
    
}

