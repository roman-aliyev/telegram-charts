//
//  StatisticsViewController+StatisticsViewProtocol.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/13/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

extension StatisticsViewController: StatisticsViewProtocol {
    func presentAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateAllSections() {
        self.tableView.reloadData()
    }
    
    func chartView(at section: Int) -> ChartViewProtocol? {
        return self.tableView.cellForRow(at: IndexPath(item: 0, section: section)) as? ChartViewProtocol
    }
    
    func update(chartViewShapesAt section: Int) {
        (
            self.tableView.cellForRow(
                at: IndexPath(item: 0, section: section)
            ) as? ChartView
        )?.bind(
            to: self.viewModel.charts[section],
            delegate: self.delegate
        )
    }
}
