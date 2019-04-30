//
//  StatisticsView.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 4/30/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

class StatisticsView: UIView {
    let viewModel = StatisticsViewModel()
    @IBOutlet private weak var tableView: UITableView!
    
    weak var delegate: (ChartViewDelegate & LegendItemDelegate)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
}

extension StatisticsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            DispatchQueue.main.async {
                let chartModel = self.viewModel.charts[indexPath.section]
                self.delegate.chartViewDidLayoutSubViews(chartId: chartModel.id)
            }
        }
    }
}

extension StatisticsView: UITableViewDataSource {
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

extension StatisticsView: StatisticsViewProtocol {
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
