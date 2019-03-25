//
//  StatisticsInteractor.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/13/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import Foundation

protocol StatisticsViewDelegate {
    func viewDidLoad()
    func chartViewDidLayoutSubViews(chartId: String)
}

protocol ChartViewDelegate {
    func chartViewDidChangeSelection(chartId: String)
}

protocol LegendItemDelegate {
    func legendItemViewGotTapEvent(chartId: String)
}

protocol StatisticsInteractorDelegate: NSObjectProtocol {
    func present(chartObjects: [ChartObject])
    func present(chartObject: ChartObject)
    func scale(primaryCanvasShapesBy id: String, animated: Bool)
    func scale(secondaryCanvasShapesBy id: String, animated: Bool)
    func presentAlert(about error: Error)
}

class StatisticsInteractor: NSObject {
    private weak var delegate: StatisticsInteractorDelegate?
    let throttler = Throttler(minimumDelay: 0.1)
    
    let chartObjectSource: ChartObjectSourceProtocol = ChartObjectSource()
    let chartObjectRepository: ChartObjectRepositoryProtocol = ChartObjectRepository()
    
    init(delegate: StatisticsInteractorDelegate) {
        self.delegate = delegate
        super.init()
    }
}

extension StatisticsInteractor: StatisticsViewDelegate {
    func viewDidLoad() {
        do {
            for chartObject in try self.chartObjectSource.load(resourceName: "chart_data") {
                self.chartObjectRepository.save(chartObject)
            }
        } catch {
            self.delegate?.presentAlert(about: error)
            return
        }
        let chartObjects = self.chartObjectRepository.getAllObjects()
        self.delegate?.present(chartObjects: chartObjects)
    }
    
    func chartViewDidLayoutSubViews(chartId: String) {
        if let chartObject = self.chartObjectRepository.getObject(by: chartId) {
            self.delegate?.present(chartObject: chartObject)
            self.delegate?.scale(primaryCanvasShapesBy: chartId, animated: false)
            self.delegate?.scale(secondaryCanvasShapesBy: chartId, animated: false)
        }
    }
}

extension StatisticsInteractor: ChartViewDelegate {
    func chartViewDidChangeSelection(chartId: String) {
        self.throttler.execute {
            [weak self] in
            self?.delegate?.scale(secondaryCanvasShapesBy: chartId, animated: true)
        }
    }
}


extension StatisticsInteractor: LegendItemDelegate {
    func legendItemViewGotTapEvent(chartId: String) {
        self.delegate?.scale(primaryCanvasShapesBy: chartId, animated: true)
        self.delegate?.scale(secondaryCanvasShapesBy: chartId, animated: true)
    }
}
