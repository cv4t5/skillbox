//
//  GraphicsController.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 19.02.2024.
//

import Foundation
import UIKit

class GraphicsController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        if let logoView = LogoVIew.loadViewFromNib() {
            view.addSubview(logoView)
        }
    }
}
