//
//  PurchaseManager.swift
//  Pong
//
//  Created by Brenno Ribeiro on 3/18/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

typealias CompletionHandler = (_ success: Bool) -> ()

import Foundation
import StoreKit

class PurchaseManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let instance = PurchaseManager() // singleton
    
    let IAP_PREMIUM = "com.brennoribeiro.Pong.premium"  // premium IAP ID
    
    var productsRequest: SKProductsRequest!
    var products = [SKProduct]()
    var transactionComplete: CompletionHandler? // transaction completion handler
    
    // fetches available IAP products
    func fetchProducts() {
        let productIds = NSSet(object: IAP_PREMIUM) as! Set<String>
        productsRequest = SKProductsRequest(productIdentifiers: productIds)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    // premium purchase function
    func purchasePremium(onComplete: @escaping CompletionHandler) {
        if SKPaymentQueue.canMakePayments() && products.count > 0 {
            transactionComplete = onComplete
            let premiumProduct = products[0]
            let payment = SKPayment(product: premiumProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            onComplete(false)
        }
    }
    
    // restore purchase function
    func restorePurchases(onComplete: @escaping CompletionHandler) {
        if SKPaymentQueue.canMakePayments() {
            transactionComplete = onComplete
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            onComplete(false)
        }
        
    }
    
    // outputs products
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count > 0 {
            print(response.products.debugDescription)
            products = response.products
        }
        
    }
    
    // paymentQueue based on whether IAP has been purchased or not
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        
        if UserDefaults.standard.bool(forKey: IAP_PREMIUM) == false {
            return true
        } else if UserDefaults.standard.bool(forKey: IAP_PREMIUM) == true {
            return false
        }
        
        return false
    }
    
    // transactions
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:    // purchase successful
                SKPaymentQueue.default().finishTransaction(transaction)
                if transaction.payment.productIdentifier == IAP_PREMIUM {
                    // set UserDefaults IAP purchased key to true
                    UserDefaults.standard.set(true, forKey: IAP_PREMIUM)
                    transactionComplete?(true)
                }
                break
            case .failed:   // failed transaction
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionComplete?(false)
                break
            case .restored: // restore purchases successful
                SKPaymentQueue.default().finishTransaction(transaction)
                if transaction.payment.productIdentifier == IAP_PREMIUM {
                    // set UserDefaults IAP purchased key to true
                    UserDefaults.standard.set(true, forKey: IAP_PREMIUM)
                }
                transactionComplete?(true)
            default:    // default: uncomplete transaction
                transactionComplete?(false)
                break
            }
        }
    }
    
}

