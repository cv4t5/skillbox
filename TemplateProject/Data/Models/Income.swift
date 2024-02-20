//
//  Income.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 19.02.2024.
//

import Foundation
import RealmSwift

class Income: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var amount: Float = 0.0
    @Persisted var date: Date = Date()
}
