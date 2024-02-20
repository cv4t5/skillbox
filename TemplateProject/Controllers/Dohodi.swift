//
//  Dohodi.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 19.02.2024.
//

import Foundation
import RealmSwift

class Dohodi: Object {
    @objc dynamic var amount: Float = 0.0
    @objc dynamic var date: Date = Date()
}
