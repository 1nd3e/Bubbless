//
//  IAPService.swift
//  Bubbless
//
//  Created by Vladislav Kulikov on 04.05.2020.
//  Copyright © 2020 Vladislav Kulikov. All rights reserved.
//

import UIKit
import StoreKit

protocol IAPServiceDelegate: class {
    func adsDisabled()
}

class IAPService: NSObject {
    
    // MARK: - Types
    
    static let shared = IAPService()
    
    // MARK: - Properties
    
    weak var delegate: IAPServiceDelegate?
    
    // MARK: - Methods
    
    // Adds an observer for transactions in In-App Purchases.
    func addObserver() {
        SKPaymentQueue.default().add(self)
    }
    
    // Removes an observer for transactions in In-App Purchases.
    func removeObserver() {
        SKPaymentQueue.default().remove(self)
    }
    
    // Sends a request for purchase of removing ads.
    func removeAds() {
        guard SKPaymentQueue.canMakePayments() else { return }
        
        let payment = SKMutablePayment()
        payment.productIdentifier = "ru.1nd3e.Bubbless.Ads"
        
        SKPaymentQueue.default().add(payment)
    }
    
    // Sends a request to restore purchases.
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}

// MARK: - SKPaymentTransactionObserver

extension IAPService: SKPaymentTransactionObserver {
    
    // Processes transaction states.
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                delegate?.adsDisabled()
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                
                if let error = transaction.error {
                    print("Payment transaction failed: \(error.localizedDescription).")
                }
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                delegate?.adsDisabled()
            default:
                break
            }
        }
    }
    
}
