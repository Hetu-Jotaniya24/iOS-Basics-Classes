//
//  IAPService.swift
//  Absolutum
//
//  Created by PC3 on 21/02/19.
//  Copyright © 2019 HeelfInfotech. All rights reserved.
//

import Foundation
import StoreKit
import SVProgressHUD

class IAPService: NSObject {
    
    private override init() {}
    static let shared = IAPService()
    
    var products = [SKProduct]()
    var purchaseprice = [String:String]()
    let paymentQueue = SKPaymentQueue.default()
    var restore = "0"
    
    func getProducts() {
        let products: Set = [IAPProducts.goldplan.rawValue]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        //paymentQueue.add(self)
    }
    
    func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func purchase(product: IAPProducts) {
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first, canMakePurchases() else { return }
        SVProgressHUD.show()
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePurchases() {
        SVProgressHUD.show()
        restore = "1"
        paymentQueue.add(self)
        paymentQueue.restoreCompletedTransactions()
    }
}

extension IAPService: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        purchaseprice.removeAll()
        for product in response.products {
            print(product.localizedTitle)
      //      if product.productIdentifier == IAPProducts.autoRenewableSubscription.rawValue {
            
                let locale = product.priceLocale
                let price = product.price
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = locale
            purchaseprice[product.productIdentifier] = numberFormatter.string(from: price)!
      //      }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        SVProgressHUD.dismiss()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "restoreAlertPop"), object: nil)
         print("Restored \(queue.transactions.count) transactions.")
    }
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            switch transaction.transactionState {
                case .purchasing: break
                case .failed, .deferred:
                    queue.finishTransaction(transaction)
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        Utility.topMsgView(msgTitle: "", msgBody: transaction.error?.localizedDescription ?? "Transaction failed.", theme: .error, time: 3.0)
    
                    }
                    break
                case .purchased:
                    SVProgressHUD.dismiss()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "purchasedAlertPop"), object: nil)
                    queue.finishTransaction(transaction)
                    break
            
            default: queue.finishTransaction(transaction)
            }
        }
    }
}

extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
        case .deferred:
            SVProgressHUD.dismiss()
            return "deferred"
        case .failed:
            SVProgressHUD.dismiss()
            return "failed"
        case .purchased:
            return "purchased"
        case .purchasing:
            return "purchasing"
        case .restored:
            return "restored"
        }
    }
}
