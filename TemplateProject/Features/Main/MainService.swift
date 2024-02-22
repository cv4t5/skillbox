//
//  MainService.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 20.02.2024.
//

import Foundation
import RealmSwift

class MainService {
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
}
