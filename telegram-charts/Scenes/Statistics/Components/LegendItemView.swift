//
//  LegendItemView.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/12/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

class LegendItemView: UITableViewCell {
    private var legendItem: StatisticsViewModel.LegendItem?
    private var delegate: LegendItemDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.imageView?.image = UIImage(named: "LegendItemImage")?.withRenderingMode(.alwaysTemplate)
    }
    
    func bind(to legendItem: StatisticsViewModel.LegendItem, delegate: LegendItemDelegate) {
        self.legendItem = legendItem
        self.delegate = delegate
        self.textLabel?.text = legendItem.title
        self.accessoryType = legendItem.isChecked ? .checkmark : .none
        self.imageView?.tintColor = legendItem.color
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.accessoryType = self.accessoryType == .none ? .checkmark : .none
            self.legendItem?.isChecked.toggle()
            if let chartId = legendItem?.chartId {
                self.delegate?.legendItemViewGotTapEvent(chartId: chartId)
            }
        }
    }
}
