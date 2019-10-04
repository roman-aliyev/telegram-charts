import Foundation

class DataSeries<T> {
    let data: UnsafePointer<T>
    let dataSize: Int
    let minValue: T
    let maxValue: T
    
    init(
        data: [T],
        minValue: T,
        maxValue: T
    ) {
        let mutableData = UnsafeMutablePointer<T>.allocate(capacity: data.count)
        mutableData.initialize(from: data, count: data.count)
        self.data = UnsafePointer(mutableData)
        self.dataSize = data.count
        self.minValue = minValue
        self.maxValue = maxValue
    }
    
    deinit {
        data.deallocate()
    }
}
