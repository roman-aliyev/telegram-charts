//
//  StatisticsBuilder.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 5/14/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

class StatisticsBuilder {
    func build() -> StatisticsViewController {
        let statisticsViewController = UIStoryboard(name: "Statistics", bundle: nil).instantiateInitialViewController() as! StatisticsViewController
        statisticsViewController.loadViewIfNeeded()
        let interactor = StatisticsInteractor(
            presenter: StatisticsPresenter(
                routeToAlert: RouteToAlert(from: statisticsViewController),
                statisticsView: statisticsViewController.statisticsView
                )
        )
        statisticsViewController.delegate = interactor
        statisticsViewController.statisticsView.delegate = interactor
        return statisticsViewController
    }
}
