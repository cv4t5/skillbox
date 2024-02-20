//
//  Costs.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 19.02.2024.
//

import Foundation
import RealmSwift

class Costs: Object {
    // @objc dynamic var category: Category = Category()

    @Persisted(primaryKey: true) var id = ""
    @Persisted var name = ""
    @Persisted var amount: Float = 0
    @Persisted var date: Date = Date()
}
