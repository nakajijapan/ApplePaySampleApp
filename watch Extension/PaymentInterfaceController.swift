//
//  PaymentInterfaceController.swift
//  applepay
//
//  Created by nakajijapan on 2017/01/08.
//  Copyright © 2017年 nakajijapan. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications
import PassKit

class PaymentInterfaceController: WKInterfaceController {

    @IBOutlet weak var applePayButton: WKInterfacePaymentButton!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var productImage: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        
        titleLabel.setText("Product Name")
        productImage.setImage(UIImage(named: "product"))
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func paymentButtonDidTap() {
        
        if !PKPaymentAuthorizationController.canMakePayments(usingNetworks: [PKPaymentNetwork.visa]) {
            
            if !PKPassLibrary().isPaymentPassActivationAvailable() {
                print("Can not Payment.")
            }
            
            return
        }
        
        let request = PKPaymentRequest()
        
        request.merchantIdentifier = "merchant.net.nakajijapan.applepaytest"
        request.countryCode = "JP"
        request.currencyCode = "JPY"
        request.supportedNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard]
        
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Item Price", amount: 999),
            PKPaymentSummaryItem(label: "NKJ", amount: 1000)
        ]
        
        let applePayController = PKPaymentAuthorizationController(paymentRequest: request)
        applePayController.delegate = self
        applePayController.present { (finished) in
            print("finished")
        }
        
    }
    
}

// MARK: - PKPaymentAuthorizationControllerDelegate

extension PaymentInterfaceController: PKPaymentAuthorizationControllerDelegate {
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        print("paymentAuthorizationController:didAuthorizePayment")
        print(payment.token)
        
        // Check - success
        completion(.success)
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        print("paymentAuthorizationControllerDidFinish")
        controller.dismiss { 
            print("finished")
        }
    }
}

