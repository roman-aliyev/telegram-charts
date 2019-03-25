//
//  ChartObject.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/13/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

struct ChartObject {
    let id: String
    let name: String
    let xData: DataSeries<UInt64>
    let chartData: [ChartData]
}
