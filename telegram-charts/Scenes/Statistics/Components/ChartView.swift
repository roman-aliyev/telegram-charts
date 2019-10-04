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
        primaryCanvas.delegate = self
        primaryCanvas.configure(legendItems: chartModel.legendItems)
        secondaryCanvas.configure(legendItems: chartModel.legendItems)
        
        for row in 0..<chartModel.legendItems.count {
            primaryCanvas.shapeLayers[row].path = chartModel.primaryCanvasPaths?[row]
            secondaryCanvas.shapeLayers[row].path = chartModel.secondaryCanvasPaths?[row]
        }
        
        primaryCanvas.selectorLeftOffset = chartModel.selectorLeftOffset
        primaryCanvas.selectorRightOffset = chartModel.selectorRightOffset
        primaryCanvas.setNeedsLayout()
    }
    
    func selectionDidChange(sender: UIView, leftOffset: CGFloat, rightOffset: CGFloat) {
        guard let chartModel = chartModel else {
            return
        }
        chartModel.selectorLeftOffset = leftOffset
        chartModel.selectorRightOffset = rightOffset
        delegate?.chartViewDidChangeSelection(chartId: chartModel.id)
    }
}
