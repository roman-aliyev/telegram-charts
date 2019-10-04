import UIKit

class CanvasView: UIView {
    var shapeLayers = [CAShapeLayer]()
    
    func configure(legendItems: [StatisticsViewModel.LegendItem]) {
        shapeLayers.forEach { $0.removeFromSuperlayer() }
        shapeLayers.removeAll()
        
        for legendItem in legendItems {
            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = 1
            shapeLayer.fillColor = nil
            shapeLayer.strokeColor = legendItem.color.cgColor
            shapeLayers.append(shapeLayer)
            layer.addSublayer(shapeLayer)
        }
    }
}
