//
//  StatisticsViewModel.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/12/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

class StatisticsViewModel {
    class Chart {
        let id: String
        let title: String
        let legendItems: [LegendItem]
        
        var selectorLeftOffset: CGFloat = 0
        var selectorRightOffset: CGFloat = 0
        
        var primaryCanvasTransform = CGAffineTransform(scaleX: 1, y: 1)
        var secondaryCanvasTransform = CGAffineTransform(scaleX: 1, y: 1)
        
        var primaryCanvasPaths: [CGPath]?
        var secondaryCanvasPaths: [CGPath]?
        
        init(
            id: String,
            title: String,
            legendItems: [LegendItem]
        ) {
            self.id = id
            self.title = title
            self.legendItems = legendItems
        }
    }
    
    class LegendItem {
        let id: String
        let title: String
        let color: UIColor
        var isChecked: Bool = true
        let chartId: String
        
        init(
            id: String,
            title: String,
            color: UIColor,
            chartId: String
        ) {
            self.id = id
            self.title = title
            self.color = color
            self.chartId = chartId
        }
    }
    var charts = [Chart]()
    var nightModeButtonText: String?
}
