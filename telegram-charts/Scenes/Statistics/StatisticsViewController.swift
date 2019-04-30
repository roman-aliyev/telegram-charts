//
//  StatisticsViewController.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/12/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController, RouteToAlert {
    @IBOutlet var statisticsView: StatisticsView!
    
    lazy var delegate: StatisticsViewDelegate & ChartViewDelegate & LegendItemDelegate = StatisticsInteractor(
        presenter: StatisticsPresenter(router: self, statisticsView: self.statisticsView)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statisticsView.delegate = self.delegate
        self.delegate.viewDidLoad()
    }
}
