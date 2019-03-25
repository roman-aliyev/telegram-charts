//
//  ChartObjectSource.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/20/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import Foundation

enum ChartDataError: Error {
    case fileCouldNotBeLocated(fileName: String)
    case urlCanNotBeRead(url: URL)
    case unsupportedDataFormat(url: URL)
}

protocol ChartObjectSourceProtocol {
    func load(resourceName: String) throws -> [ChartObject]
}

class ChartObjectSource: ChartObjectSourceProtocol {
    
    private func loadJsonData(resourceName: String) throws -> [ChartDataFromJson] {
        let fileExtension = "json"
        guard let chartDataUrl = Bundle.main.url(forResource: resourceName, withExtension: fileExtension) else {
            throw ChartDataError.fileCouldNotBeLocated(fileName: "\(resourceName).\(fileExtension)")
        }
        guard let chartData = try? Data(contentsOf: chartDataUrl) else {
            throw ChartDataError.urlCanNotBeRead(url: chartDataUrl)
        }
        do {
            return try JSONDecoder().decode([ChartDataFromJson].self, from: chartData)
        } catch {
            throw ChartDataError.unsupportedDataFormat(url: chartDataUrl)
        }
    }
    
    func load(resourceName: String) throws -> [ChartObject] {
        let jsonData = try self.loadJsonData(resourceName: resourceName)
        var chartObjects = [ChartObject]()
        for i in 0..<jsonData.count {
            let jsonObject = jsonData[i]
            var chartDataList = [ChartData]()
            
            for id in jsonObject.ids {
                guard let yData = jsonObject.yColumns[id] else {
                    continue
                }
                chartDataList.append(
                    ChartData(
                        id: id,
                        name: jsonObject.names[id],
                        color: jsonObject.colors[id],
                        yData: DataSeries(
                            data: yData,
                            minValue: yData.min() ?? 0,
                            maxValue: yData.max() ?? 0
                        )
                    )
                )
            }
            chartObjects.append(
                ChartObject(
                    id: "\(i)",
                    name: "Chart \(i + 1)",
                    xData: DataSeries<UInt64>(
                        data: jsonObject.xColumn,
                        minValue: jsonObject.xColumn.min() ?? 0,
                        maxValue: jsonObject.xColumn.max() ?? 0
                    ),
                    chartData: chartDataList
                )
            )
        }
        return chartObjects
    }
}

private class ChartDataFromJson: Decodable {
    let ids: [String]
    let names: [String: String]
    let colors: [String: String]
    
    let xColumn: [UInt64]
    let yColumns: [String: [Double]]
    
    enum Key: String, CodingKey {
        case columns
        case types
        case names
        case colors
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let types = try container.decode([String:String].self, forKey: .types)
        self.names = try container.decode([String:String].self, forKey: .names)
        self.colors = (try container.decode([String:String].self, forKey: .colors))
        
        var columnsContainer = try container.nestedUnkeyedContainer(forKey: .columns)
        
        var ids = [String]()
        var xColumn = [UInt64]()
        var yColumns = [String: [Double]]()
        
        while !columnsContainer.isAtEnd {
            var container = try columnsContainer.nestedUnkeyedContainer()
            if container.count ?? 0 > 0 {
                let id = try container.decode(String.self)
                
                switch types[id] {
                case "x":
                    while !container.isAtEnd {
                        xColumn.append(try container.decode(UInt64.self))
                    }
                case "line":
                    ids.append(id)
                    var data = [Double]()
                    while !container.isAtEnd {
                        data.append(try container.decode(Double.self))
                    }
                    yColumns[id] = data
                default:
                    break
                }
            }
        }
        self.xColumn = xColumn
        self.yColumns = yColumns
        self.ids = ids
    }
}
