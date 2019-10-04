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
        return chartObjects
    }
    
    func getObject(by id: String) -> ChartObject? {
        return chartObjects.first { $0.id == id }
    }
    
    func save(_ chartObject: ChartObject) {
        chartObjects.append(chartObject)
    }
}
