import Foundation

enum StatisticsControllerError {
    case loadDataError(innerError: Error)
}

class StatisticsController {
    let presenter: StatisticsPresenterProtocol
    let throttler = Throttler(minimumDelay: 0.1)
    
    let chartObjectSource: ChartObjectSourceProtocol = ChartObjectSource()
    let chartObjectRepository: ChartObjectRepositoryProtocol = ChartObjectRepository()
    
    init(presenter: StatisticsPresenterProtocol) {
        self.presenter = presenter
    }
}

extension StatisticsController: StatisticsViewDelegate {
    func viewWillAppear(initially: Bool) {
        if initially {
            do {
                for chartObject in try chartObjectSource.load(resourceName: "chart_data") {
                    chartObjectRepository.save(chartObject)
                }
            } catch {
                presenter.presentAlert(about: .loadDataError(innerError: error))
                
                return
            }
            let chartObjects = chartObjectRepository.getAllObjects()
            presenter.present(chartObjects: chartObjects)
        }
    }
}

extension StatisticsController: ChartViewDelegate {
    func chartViewDidLayoutSubViews(chartId: String) {
        if let chartObject = chartObjectRepository.getObject(by: chartId) {
            presenter.present(chartObject: chartObject)
            presenter.scale(primaryCanvasShapesBy: chartId, animated: false)
            presenter.scale(secondaryCanvasShapesBy: chartId, animated: false)
        }
    }
    
    func chartViewDidChangeSelection(chartId: String) {
        throttler.execute { [weak self] in
            self?.presenter.scale(secondaryCanvasShapesBy: chartId, animated: true)
        }
    }
}


extension StatisticsController: LegendItemDelegate {
    func legendItemViewGotTapEvent(chartId: String) {
        presenter.scale(primaryCanvasShapesBy: chartId, animated: true)
        presenter.scale(secondaryCanvasShapesBy: chartId, animated: true)
    }
}
