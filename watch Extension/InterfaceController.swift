//
//  InterfaceController.swift
//  watch Extension
//
//  Created by nakajijapan on 2017/01/07.
//  Copyright © 2017年 nakajijapan. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications

class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func handleAction(withIdentifier identifier: String?, for notification: UNNotification) {

        print("identifier: \(identifier)")
        if identifier == "paymentButtonAction" {
            pushController(withName: "PaymentInterfaceController", context: nil)
        }
        
    }

}
