//
//  ChartView.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/15/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

class ChartView: UITableViewCell, PrimaryCanvasViewDelegate {
    @IBOutlet weak var secondaryCanvas: CanvasView!
    @IBOutlet weak var primaryCanvas: PrimaryCanvasView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selectionStyle = .none
    }
    
    var chartModel: StatisticsViewModel.Chart?
    private var delegate: ChartViewDelegate?
    
    func bind(to chartModel: StatisticsViewModel.Chart, delegate: ChartViewDelegate) {
        self.chartModel = chartModel
        self.delegate = delegate
        self.primaryCanvas.delegate = self
        self.primaryCanvas.configure(legendItems: chartModel.legendItems)
        self.secondaryCanvas.configure(legendItems: chartModel.legendItems)
        
        for row in 0..<chartModel.legendItems.count {
            self.primaryCanvas.shapeLayers[row].path = chartModel.primaryCanvasPaths?[row]
            self.secondaryCanvas.shapeLayers[row].path = chartModel.secondaryCanvasPaths?[row]
        }
        
        self.primaryCanvas.selectorLeftOffset = chartModel.selectorLeftOffset
        self.primaryCanvas.selectorRightOffset = chartModel.selectorRightOffset
        self.primaryCanvas.setNeedsLayout()
    }
    
    func selectionDidChange(sender: UIView, leftOffset: CGFloat, rightOffset: CGFloat) {
        guard let chartModel = self.chartModel else {
            return
        }
        chartModel.selectorLeftOffset = leftOffset
        chartModel.selectorRightOffset = rightOffset
        self.delegate?.chartViewDidChangeSelection(chartId: chartModel.id)
    }
}
