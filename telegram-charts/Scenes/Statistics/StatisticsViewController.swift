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
    
    private lazy var presenter = StatisticsPresenter(statisticsView: self)
    let viewModel = StatisticsViewModel()
    lazy var delegate: StatisticsViewDelegate & ChartViewDelegate & LegendItemDelegate = StatisticsInteractor(delegate: self.presenter)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.register(LegendItemView.self, forCellReuseIdentifier: "LegendItemView")
        tableView.delegate = self
        tableView.dataSource = self
        self.delegate.viewDidLoad()
    }
}
