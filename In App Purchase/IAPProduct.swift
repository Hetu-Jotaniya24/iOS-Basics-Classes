//
//  IAPProduct.swift
//  Absolutum
//
//  Created by PC3 on 21/02/19.
//  Copyright © 2019 HeelfInfotech. All rights reserved.
//

import Foundation
import SVProgressHUD

enum IAPProducts: String {
    case goldplan = "heelf.wordsmatter.newquotes"
}

var IAPProductsRaw = ["heelf.wordsmatter.newquotes"]

enum ReceiptValidationError: Error {
    case receiptNotFound
    case jsonResponseIsNotValid(description: String)
    case notBought
    case expired
}

//MARK:- verifyReciept
func IAPVerify(){
    do {
        try validateReceipt()
        print("Receipt is valid")
    } catch ReceiptValidationError.receiptNotFound {
        print("Receipt not dound")
    } catch ReceiptValidationError.jsonResponseIsNotValid(let description) {
        print(description)
    } catch ReceiptValidationError.notBought {
    } catch ReceiptValidationError.expired {
    } catch {
        print("Unexpected error: \(error).")
    }
}


//MARK:- validate receipt
func validateReceipt() throws {
    guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL, FileManager.default.fileExists(atPath: appStoreReceiptURL.path) else {
        SVProgressHUD.dismiss()
        throw ReceiptValidationError.receiptNotFound
    }
    
    let receiptData = try! Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
    let receiptString = receiptData.base64EncodedString()
    let jsonObjectBody = ["receipt-data" : receiptString, "password" : "feb6a14bb32a4a1a8aa75e784e6a5d49"]
    
   // #if DEBUG
    //let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
   /* #else
    let url = URL(string: "https://buy.itunes.apple.com/verifyReceipt")!
    #endif*/
    var url: URL!
    if isSimulatorOrTestFlight() {
        url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
    }else{
        url = URL(string: "https://buy.itunes.apple.com/verifyReceipt")!
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObjectBody, options: .prettyPrinted)
    
    var validationError : ReceiptValidationError?
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil, httpResponse.statusCode == 200 else {
            validationError = ReceiptValidationError.jsonResponseIsNotValid(description: error?.localizedDescription ?? "")
            
            return
        }
        
        guard let jsonResponse = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [AnyHashable: Any] else {
            validationError = ReceiptValidationError.jsonResponseIsNotValid(description: "Unable to parse json")
            
            return
        }

        guard let receiptInfo = (jsonResponse["latest_receipt_info"] as? [[AnyHashable: Any]]) else {
            return
        }
        
        if let receiptDic = receiptInfo.last as? [String:Any], let productID = receiptDic["product_id"] as? String, let expiryDateMS = receiptDic["expires_date_ms"] as? String, productID == IAPProducts.goldplan.rawValue {
             let currentDateMS = Int((Date().timeIntervalSince1970) * 1000)
           isYearlySubscribed = (Int(expiryDateMS) ?? 0) > currentDateMS
            print("Expiry Date MS = \(expiryDateMS)")
            print("Today Date MS = \(currentDateMS)")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receiptLoad"), object: nil)
            }
        }
        
    }
    
    task.resume()
    
    if let validationError = validationError {
        SVProgressHUD.dismiss()
        throw validationError
    }
}

private func isSimulatorOrTestFlight() -> Bool {
    guard let path = Bundle.main.appStoreReceiptURL?.path else {
        return false
    }
    return path.contains("CoreSimulator") || path.contains("sandboxReceipt")
}
