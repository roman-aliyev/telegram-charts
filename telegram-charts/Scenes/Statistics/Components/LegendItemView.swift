import UIKit

class LegendItemView: UITableViewCell {
    private var legendItem: StatisticsViewModel.LegendItem?
    private var delegate: LegendItemDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        imageView?.image = UIImage(named: "LegendItemImage")?.withRenderingMode(.alwaysTemplate)
    }
    
    func bind(to legendItem: StatisticsViewModel.LegendItem, delegate: LegendItemDelegate) {
        self.legendItem = legendItem
        self.delegate = delegate
        textLabel?.text = legendItem.title
        accessoryType = legendItem.isChecked ? .checkmark : .none
        imageView?.tintColor = legendItem.color
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            accessoryType = self.accessoryType == .none ? .checkmark : .none
            legendItem?.isChecked.toggle()
            
            if let chartId = legendItem?.chartId {
                delegate?.legendItemViewGotTapEvent(chartId: chartId)
            }
        }
    }
}
