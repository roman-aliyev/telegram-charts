//
//  StatisticsInteractor.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/13/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import Foundation

enum StatisticsInteractorError {
    case loadDataError(innerError: Error)
}

protocol StatisticsViewDelegate {
    func viewWillAppear(initially: Bool)
}

protocol ChartViewDelegate {
    func chartViewDidLayoutSubViews(chartId: String)
    func chartViewDidChangeSelection(chartId: String)
}

protocol LegendItemDelegate {
    func legendItemViewGotTapEvent(chartId: String)
}

protocol StatisticsPresenterProtocol {
    func present(chartObjects: [ChartObject])
    func present(chartObject: ChartObject)
    func scale(primaryCanvasShapesBy id: String, animated: Bool)
    func scale(secondaryCanvasShapesBy id: String, animated: Bool)
    func presentAlert(about error: StatisticsInteractorError)
}

class StatisticsInteractor {
    let presenter: StatisticsPresenterProtocol
    let throttler = Throttler(minimumDelay: 0.1)
    
    let chartObjectSource: ChartObjectSourceProtocol = ChartObjectSource()
    let chartObjectRepository: ChartObjectRepositoryProtocol = ChartObjectRepository()
    
    init(presenter: StatisticsPresenterProtocol) {
        self.presenter = presenter
    }
}

extension StatisticsInteractor: StatisticsViewDelegate {
    func viewWillAppear(initially: Bool) {
        if initially {
            do {
                for chartObject in try self.chartObjectSource.load(resourceName: "chart_data") {
                    self.chartObjectRepository.save(chartObject)
                }
            } catch {
                self.presenter.presentAlert(about: .loadDataError(innerError: error))
                return
            }
            let chartObjects = self.chartObjectRepository.getAllObjects()
            self.presenter.present(chartObjects: chartObjects)
        }
    }
}

extension StatisticsInteractor: ChartViewDelegate {
    func chartViewDidLayoutSubViews(chartId: String) {
        if let chartObject = self.chartObjectRepository.getObject(by: chartId) {
            self.presenter.present(chartObject: chartObject)
            self.presenter.scale(primaryCanvasShapesBy: chartId, animated: false)
            self.presenter.scale(secondaryCanvasShapesBy: chartId, animated: false)
        }
    }
    
    func chartViewDidChangeSelection(chartId: String) {
        self.throttler.execute {
            [weak self] in
            self?.presenter.scale(secondaryCanvasShapesBy: chartId, animated: true)
        }
    }
}


extension StatisticsInteractor: LegendItemDelegate {
    func legendItemViewGotTapEvent(chartId: String) {
        self.presenter.scale(primaryCanvasShapesBy: chartId, animated: true)
        self.presenter.scale(secondaryCanvasShapesBy: chartId, animated: true)
    }
}
