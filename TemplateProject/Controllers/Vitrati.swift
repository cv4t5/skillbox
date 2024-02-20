//
//  Vitrati.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 19.02.2024.
//

import Foundation
import RealmSwift

class Vitrati: Object {
    @objc dynamic var name = ""
    @objc dynamic var amount: Float = 0
    @objc dynamic var date: Date = Date()
    // @objc dynamic var category: Category = Category()
}
