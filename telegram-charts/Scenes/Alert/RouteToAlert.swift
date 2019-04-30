//
//  RouteToAlert.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 4/30/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

protocol RouteToAlert where Self: UIViewController { }

extension RouteToAlert {
    func presentAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
