//
//  StatisticsViewController.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/12/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = StatisticsViewModel()
    lazy var delegate: StatisticsViewDelegate & ChartViewDelegate & LegendItemDelegate = StatisticsInteractor(
        presenter: StatisticsPresenter(statisticsView: self)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.delegate.viewDidLoad()
    }
}
