//
//  CanvasView.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/15/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

class CanvasView: UIView {
    var shapeLayers = [CAShapeLayer]()
    
    func configure(legendItems: [StatisticsViewModel.LegendItem]) {
        self.shapeLayers.forEach { $0.removeFromSuperlayer() }
        self.shapeLayers.removeAll()
        
        for legendItem in legendItems {
            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = 1
            shapeLayer.fillColor = nil
            shapeLayer.strokeColor = legendItem.color.cgColor
            self.shapeLayers.append(shapeLayer)
            self.layer.addSublayer(shapeLayer)
        }
    }
}
