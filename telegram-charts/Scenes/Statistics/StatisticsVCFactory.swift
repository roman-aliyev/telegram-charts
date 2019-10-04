import UIKit

class StatisticsVCFactory {
    func createStatisticsVC() -> UIViewController {
        let statisticsVC = UIStoryboard(name: "StatisticsVC", bundle: nil).instantiateInitialViewController() as! StatisticsVC
        statisticsVC.loadViewIfNeeded()
        let controller = StatisticsController(
            presenter: StatisticsPresenter(
                routeToAlert: RouteToAlert(from: statisticsVC),
                statisticsView: statisticsVC
                )
        )
        statisticsVC.delegate = controller
        
        return statisticsVC
    }
}
