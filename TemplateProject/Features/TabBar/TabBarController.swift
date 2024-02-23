//
//  TabBarController.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 23.02.2024.
//

import UIKit

class TabBarController: UITabBarController {
    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        tabBar.tintColor = .black
        tabBar.barTintColor = .systemGray
        tabBar.backgroundColor = .systemGray6
    }

    // MARK: Private

    // MARK: - Tab Setup

    private func setupTabs() {
        let income = createNavigationController(title: "Доходи", image: nil, vc: IncomesController())
        let costs = createNavigationController(title: "Витрати", image: nil, vc: CostsController())
        setViewControllers([income, costs], animated: true)
    }

    private func createNavigationController(title: String, image: UIImage?, vc: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)

        navController.tabBarItem.title = title
        navController.tabBarItem.image = image

        if navController.viewControllers.first != nil && navController.viewControllers.first is IncomesController {
            let navView = NavigationIncomes(title: "Доходи")
            navController.viewControllers.first?.navigationItem.titleView = navView
        } else {
            navController.viewControllers.first?.navigationItem.title = title
        }

        return navController
    }
}
