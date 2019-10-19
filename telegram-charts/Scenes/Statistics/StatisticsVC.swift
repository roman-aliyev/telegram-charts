import UIKit

protocol StatisticsViewProtocol: AnyObject {
    var viewModel: StatisticsViewModel { get }
    func updateAllSections()
    func update(chartViewShapesAt section: Int)
    func chartView(at section: Int) -> ChartViewProtocol?
}

protocol ChartViewProtocol {
    var primaryCanvasSize: CGSize { get }
    var secondaryCanvasSize: CGSize { get }
    func transformPrimaryCanvasShapes(animated: Bool)
    func transformSecondaryCanvasShapes(animated: Bool)
}

protocol StatisticsViewDelegate {
    func viewWillAppear(initially: Bool)
}

protocol ChartViewDelegate {
    func chartViewDidLayoutSubViews(chartId: String)
    func chartViewDidChangeSelection(chartId: String)
}

protocol LegendItemDelegate {
    func legendItemViewGotTapEvent(chartId: String)
}

class StatisticsVC: UIViewController {
    let viewModel = StatisticsViewModel()
    @IBOutlet private weak var tableView: UITableView!
    
    var delegate: (ChartViewDelegate & LegendItemDelegate & StatisticsViewDelegate)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    var wasAppearedBefore = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate.viewWillAppear(initially: !wasAppearedBefore)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        wasAppearedBefore = true
    }
}

extension StatisticsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            DispatchQueue.main.async {
                let chartModel = self.viewModel.charts[indexPath.section]
                self.delegate.chartViewDidLayoutSubViews(chartId: chartModel.id)
            }
        }
    }
}

extension StatisticsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? tableView.bounds.width : 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.charts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.charts[section].legendItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.charts[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "ChartView", for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LegendItemView", for: indexPath)
            let legendItem = viewModel.charts[indexPath.section].legendItems[indexPath.row - 1]
            (cell as? LegendItemView)?.bind(to: legendItem, delegate: self.delegate)
            return cell
        }
    }
}

extension StatisticsVC: StatisticsViewProtocol {
    func updateAllSections() {
        tableView.reloadData()
    }
    
    func chartView(at section: Int) -> ChartViewProtocol? {
        return tableView.cellForRow(at: IndexPath(item: 0, section: section)) as? ChartViewProtocol
    }
    
    func update(chartViewShapesAt section: Int) {
        let cellView = tableView.cellForRow(at: IndexPath(item: 0, section: section))
        let chartView = cellView as? ChartView
        chartView?.bind(to: self.viewModel.charts[section], delegate: self.delegate)
    }
}
