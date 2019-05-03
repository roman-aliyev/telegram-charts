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
    weak var source: UIViewController?
    
    init(from source: UIViewController) {
        self.source = source
    }
    
    func presentAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.source?.present(alertController, animated: true, completion: nil)
    }
}
