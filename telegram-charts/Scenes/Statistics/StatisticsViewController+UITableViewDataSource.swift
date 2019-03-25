//
//  StatisticsViewController+UITableViewDataSource.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/12/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? tableView.bounds.width : 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.charts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.charts[section].legendItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.charts[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "ChartView", for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LegendItemView", for: indexPath)
            let legendItem = self.viewModel.charts[indexPath.section].legendItems[indexPath.row - 1]
            (cell as? LegendItemView)?.bind(to: legendItem, delegate: self.delegate)
            return cell
        }
    }
}
