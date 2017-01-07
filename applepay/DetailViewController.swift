//
//  DetailViewController.swift
//  applepay
//
//  Created by nakajijapan on 2016/07/07.
//  Copyright © 2016 nakajijapan. All rights reserved.
//

import UIKit
import PassKit

class DetailViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 162.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let paymentNetworks = [PKPaymentNetwork.masterCard, PKPaymentNetwork.visa]
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            print("Can use payment service.")
        } else {
            print("Can not use payment service...")
        }

    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var identifier = ""
        if indexPath.row == 0 {
            identifier = "Cell0"
        } else if indexPath.row == 1 {
            identifier = "Cell1"
        } else if indexPath.row == 2 {
            identifier = "Cell2"
        } else if indexPath.row == 3 {
            identifier = "Cell3"
        } else if indexPath.row == 4 {
            identifier = "Cell4"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        
        if indexPath.row == 4 {
            let button = PKPaymentButton(type: .setUp, style: .black)
            cell.addSubview(button)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 162.0
        }

        return UITableViewAutomaticDimension
    }
    
    // MARK: - Actions
    
    @IBAction func applePayButtonDidTap(_ sender: UIButton) {
        
        
        if !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [PKPaymentNetwork.visa]) {

            if PKPassLibrary().isPaymentPassActivationAvailable() {
                PKPassLibrary().openPaymentSetup()
            } else {
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
        
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        applePayController.delegate = self
        self.present(applePayController, animated: true, completion: nil)
        
    }
    
    @IBAction func applePayButton2DidTap(_ sender: AnyObject) {
        
        let request = PKPaymentRequest()
        
        request.merchantIdentifier = "merchant.net.nakajijapan.applepaytest"
        request.countryCode = "JP"
        request.currencyCode = "JPY"
        request.supportedNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard]
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        
        // Private Information
        request.requiredShippingAddressFields = PKAddressField.all
        //request.requiredShippingAddressFields = [PKAddressField.email, PKAddressField.phone]
        //request.requiredShippingAddressFields = [PKAddressField.postalAddress]
        
        // CNMutableContact
        //addContact()
        addContact2(request: request)

        // 配送方法
        request.shippingMethods = getShippingMethods()
        
        // 明細
        request.paymentSummaryItems = getPaymentSummaryItems()
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        applePayController.delegate = self
        self.present(applePayController, animated: true, completion: nil)
        
        
    }
    
    func getShippingMethods() -> [PKShippingMethod] {
        let shippingMethod = PKShippingMethod(label: "Delivery Service 1", amount: 300)
        shippingMethod.identifier = "neco1"
        shippingMethod.detail = "Nationwide uniform"
        
        let shippingMethod2 = PKShippingMethod(label: "Delivery Service 2", amount: 400)
        shippingMethod2.identifier = "neco2"
        shippingMethod2.detail = "Nationwide uniform fee: +300"
        
        return [shippingMethod, shippingMethod2]

    }
    
    func addContact() {
        
        let store = CNContactStore()
        let request = CNSaveRequest()
        
        let contact = CNMutableContact()
        
        // name 
        contact.givenName = "Daichi"
        contact.familyName = "Nakajima"
        contact.phoneticGivenName = ""
        contact.phoneticFamilyName = ""
        contact.note = "automarically added"

        let address = CNMutablePostalAddress()
        address.city = "Tokyo"
        address.country = "Japan"
        address.state = "Kanagawa-ken"
        address.postalCode = "2131111"
        address.street = "Yokohama-shi"
        contact.postalAddresses = [CNLabeledValue(label: "Custom", value: address)]
        
       
        request.add(contact, toContainerWithIdentifier: store.defaultContainerIdentifier())

        let fetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor])
        var foundContact:CNContact?
        try! store.enumerateContacts(with: fetchRequest) { (contact, stop) in
            print(contact)
            if contact.givenName == "Daichi" && contact.familyName == "Nakajima" {
                print("find！ \(contact)")
                foundContact = contact
                stop.pointee = true
            }
        }
        
        if foundContact == nil {
            do {
                try store.execute(request)
            } catch {
                print("error")
            }
        }
 
    }
    
    func addContact2(request: PKPaymentRequest) {
        let contact = PKContact()
        var personNameComponents = PersonNameComponents()
        personNameComponents.givenName = "Daichi"
        personNameComponents.familyName = "Nakajima"
        contact.name = PersonNameComponents()
        contact.emailAddress = "popopo@gmail.com"
        contact.phoneNumber = CNPhoneNumber(stringValue: "08012341234")
        
        let postalAddress = CNMutablePostalAddress()
        postalAddress.city = "Tokyo"
        postalAddress.country = "Japan"
        postalAddress.state = "Kanagawa-ken"
        postalAddress.postalCode = "2131111"
        postalAddress.street = "Yokohama-shi"
        contact.postalAddress = postalAddress
        
        request.shippingContact = contact
    }
    
    func getPaymentSummaryItems() -> [PKPaymentSummaryItem] {
        return [
            PKPaymentSummaryItem(label: "Item Price", amount: NSDecimalNumber(value: 13900)),
            PKPaymentSummaryItem(label: "Commission", amount: NSDecimalNumber(value: 100)),
            PKPaymentSummaryItem(label: "Shipping fee", amount: NSDecimalNumber(value: 300)),
            PKPaymentSummaryItem(label: "NKJ", amount: 14300)
        ]
    }
}

// MARK: - PKPaymentAuthorizationViewControllerDelegate

extension DetailViewController: PKPaymentAuthorizationViewControllerDelegate {

    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Swift.Void) {
        print("paymentAuthorizationViewController:didAuthorizePayment")
        print(payment.token)
        
        // Check - success
        completion(PKPaymentAuthorizationStatus.success)
        
    }

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        // this method is called even if payment is cannceled
        controller.dismiss(animated: true, completion: nil)
    }
    
    @nonobjc func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, completion: (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
        
        print("paymentAuthorizationViewController:didSelectShippingMethod")
        print("shippingMethod: \(shippingMethod.amount)")
        
        // calc for shipping fee
        completion(PKPaymentAuthorizationStatus.success, getPaymentSummaryItems())
    }
    
    
    @nonobjc func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect paymentMethod: PKPaymentMethod, completion: ([PKPaymentSummaryItem]) -> Void) {
        completion(getPaymentSummaryItems())
    }
    
    @nonobjc func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelectShippingContact contact: PKContact, completion: (PKPaymentAuthorizationStatus, [PKShippingMethod], [PKPaymentSummaryItem]) -> Void) {

        print(contact.postalAddress!)
        print(contact.postalAddress!.street)
        completion(PKPaymentAuthorizationStatus.success, getShippingMethods(), getPaymentSummaryItems())
        
    }
    
}
