//
//  ChartData.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/20/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import Foundation

struct ChartData {
    let id: String
    let name: String?
    let color: String?
    let yData: DataSeries<Double>
}
