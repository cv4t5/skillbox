//
//  Category.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 19.02.2024.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
}
