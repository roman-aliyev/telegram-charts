//
//  RouteToAlert.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 4/30/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

protocol RouteToAlertProtocol: NSObjectProtocol {
    func presentAlert(_ title: String, message: String)
}

class RouteToAlert: NSObject, RouteToAlertProtocol {
    weak var presentingViewController: UIViewController?
    
    init(from presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    func presentAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.presentingViewController?.present(alertController, animated: true, completion: nil)
    }
}
