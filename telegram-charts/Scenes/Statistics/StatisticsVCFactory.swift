//
//  StatisticsVCFactory.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 5/14/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

class StatisticsVCFactory {
    func createStatisticsVC() -> UIViewController {
        let statisticsVC = UIStoryboard(name: "StatisticsVC", bundle: nil).instantiateInitialViewController() as! StatisticsVC
        statisticsVC.loadViewIfNeeded()
        let interactor = StatisticsInteractor(
            presenter: StatisticsPresenter(
                routeToAlert: RouteToAlert(from: statisticsVC),
                statisticsView: statisticsVC
                )
        )
        statisticsVC.delegate = interactor
        return statisticsVC
    }
}
