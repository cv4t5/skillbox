//
//  GraphicService.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 22.02.2024.
//

import Foundation

class GraphicService {
    let serviceMain = MainService()

    func getFiltredCosts(category: Category) -> [GraphicCellModel] {
        var models: [GraphicCellModel] = []
        let costs = serviceMain.getCosts()

        let filtredCosts = costs.filter { $0.category == category }
        let tempAllDatesDays = filtredCosts.map { $0.date.get(.day) }
        let datesDays = Array(Set(tempAllDatesDays))

        for date in datesDays {
            let tempCost = filtredCosts.filter { $0.date.get(.day) == date }
            if !tempCost.isEmpty {
                let sumCostAmountDay: Float = tempCost.reduce(0) { $0 + $1.amount }
                models.append(GraphicCellModel(date: tempCost[0].date, sum: sumCostAmountDay))
            }
        }

        return models
    }
}

// MARK: Helpers

extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        calendar.component(component, from: self)
    }
}
