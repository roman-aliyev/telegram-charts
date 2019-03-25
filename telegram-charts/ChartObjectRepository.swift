//
//  ChartObjectRepository.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/19/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import Foundation

enum GeneralError: Error {
    case unkonown
}

protocol ChartObjectRepositoryProtocol {
    func getAllObjects() -> [ChartObject]
    func getObject(by id: String) -> ChartObject?
    func save(_ chartObject: ChartObject)
}

class ChartObjectRepository: ChartObjectRepositoryProtocol {
    var chartObjects = [ChartObject]()
    
    func getAllObjects() -> [ChartObject] {
        return self.chartObjects
    }
    
    func getObject(by id: String) -> ChartObject? {
        return self.chartObjects.first { $0.id == id }
    }
    
    func save(_ chartObject: ChartObject) {
        self.chartObjects.append(chartObject)
    }
}
