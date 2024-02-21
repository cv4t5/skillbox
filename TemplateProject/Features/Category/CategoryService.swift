//
//  CategoryService.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 21.02.2024.
//

import Foundation
import RealmSwift

class CategoryService {
    let realmService = RealmService()

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
}
