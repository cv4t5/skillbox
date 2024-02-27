//
//  CostChart.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 26.02.2024.
//

import Charts
import Foundation
import RealmSwift

class CostChart: UIViewController {
    // MARK: Internal

    var selectedCategory = Category()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        costs = finService.getFiltredCosts(category: selectedCategory)

        let dateObjects = costs.compactMap { $0 }
        let axisDateFormatter = DateFormatter()
        axisDateFormatter.dateFormat = "dd.MM"

        var entries: [ChartDataEntry] = []

        for i in 0 ..< dateObjects.count {
            let entry = ChartDataEntry(x: Double(i * 2), y: Double(costs[i].amount))
            entries.append(entry)
        }

        let dataSet = LineChartDataSet(entries: entries, label: "грн")
        dataSet.colors = [NSUIColor.blue]

        let data = LineChartData(dataSet: dataSet)
        lineChartsView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateObjects.compactMap { axisDateFormatter.string(from: $0.date) })
        lineChartsView.xAxis.labelPosition = .bottom
        lineChartsView.data = data

        lineChartsView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(lineChartsView)
        NSLayoutConstraint.activate([
            lineChartsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lineChartsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineChartsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineChartsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: Private

    private let lineChartsView = LineChartView()
    private let finService = FinanceService()
    private var costs = RealmSwift.List<Costs>()
}
