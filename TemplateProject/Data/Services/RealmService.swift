//
//  RealmService.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 20.02.2024.
//

import Foundation
import RealmSwift

class RealmService {
    // MARK: Lifecycle

    init() {
        storage = try? Realm()
    }

    // MARK: Internal

    func saveOrUpdateObject(object: Object) throws {
        guard let storage else { return }
        try? storage.write {
            storage.add(object, update: .all)
        }
    }

    func saveOrUpdateAllObjects(objects: [Object]) throws {
        try objects.forEach {
            try saveOrUpdateObject(object: $0)
        }
    }

    func delete(object: Object) throws {
        guard let storage else { return }
        try storage.write {
            storage.delete(object)
        }
    }

    func deleteAll() throws {
        guard let storage else { return }
        try storage.write {
            storage.deleteAll()
        }
    }

    func fetch<T: Object>(by type: T.Type) -> [T] {
        guard let storage else { return [] }
        return storage.objects(T.self).toArray()
    }

    // MARK: Private

    private let storage: Realm?
}

extension Results {
    func toArray() -> [Element] {
        .init(self)
    }
}
