//
//  FinanceService.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 23.02.2024.
//

import Foundation
import RealmSwift

class FinanceService {
    let realmService = RealmService()

    func saveIncome(amount: Float) {
        let income = Income()
        income.amount = amount
        income.date = Date()
        income.id = "\(income.date)"

        try? realmService.saveOrUpdateObject(object: income)
    }

    func getIncomes() -> List<Income> {
        let incomes = List<Income>()
        incomes.append(objectsIn: realmService.fetch(by: Income.self))
        return incomes
    }

    func deleteIncome(index: Int) {
        let incomes = getIncomes()

        if !incomes.isEmpty {
            try? realmService.delete(object: incomes[index])
        }
    }

    func saveCost(amount: Float, name: String, category: Category) {
        let cost = Costs()
        cost.amount = amount
        cost.date = Date()
        cost.name = name
        cost.id = "\(cost.date)"
        cost.category = category

        try? realmService.saveOrUpdateObject(object: cost)
    }

    func getCosts() -> List<Costs> {
        let costs = List<Costs>()
        costs.append(objectsIn: realmService.fetch(by: Costs.self))

        return costs
    }

    func deleteCosts(index: Int) {
        let costs = getCosts()

        if !costs.isEmpty {
            try? realmService.delete(object: costs[index])
        }
    }

    func getStringDateTimeNow(date: Date) -> String {
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter.string(from: date) // "10:52:30"
    }

    func getUserBalance() -> Float {
        var balance: Float = 0
        balance = getIncomes().reduce(0) { $0 + $1.amount }
        return balance
    }

    func saveCategory(name: String) {
        let category = Category()
        category.name = name
        category.id = "\(Date())"

        try? realmService.saveOrUpdateObject(object: category)
    }

    func getCategories() -> List<Category> {
        let categories = List<Category>()
        categories.append(objectsIn: realmService.fetch(by: Category.self))

        return categories
    }

    func deleteCategory(index: Int) {
        let categories = realmService.fetch(by: Category.self)

        if !categories.isEmpty {
            try? realmService.delete(object: categories[index])
        }
    }

    func getCostsOfCategory(category: Category) -> List<Costs> {
        let costs = getCosts()

        let filtredCosts = costs.filter { $0.category == category }
        var categoryCosts = List<Costs>()
        categoryCosts.append(objectsIn: filtredCosts)

        return categoryCosts
    }

    func getFiltredCosts(category: Category) -> List<Costs> {
        let filtredCosts = getCostsOfCategory(category: category)

        let tempAllDatesDays = filtredCosts.map { $0.date.get(.day) }
        var datesDays = Array(Set(tempAllDatesDays))
        datesDays.sort(by: <)
        var resultFiltred = List<Costs>()

        for date in datesDays {
            let tempCost = filtredCosts.filter { $0.date.get(.day) == date }
            if !tempCost.isEmpty {
                let tempcost = Costs()
                let sumCostAmountDay: Float = tempCost.reduce(0) { sum, cost in
                    tempcost.date = cost.date
                    return sum + cost.amount }

                tempcost.amount = sumCostAmountDay
                resultFiltred.append(tempcost)
            }
        }

        return resultFiltred
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
