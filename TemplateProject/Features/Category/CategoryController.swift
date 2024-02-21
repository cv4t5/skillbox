//
//  CategoryController.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 21.02.2024.
//

import Foundation
import RealmSwift
import SwiftUI
import UIKit

class CategoryController: UIViewController {
    var logoView = UIView()
    let labelTitle = UILabel()
    let categoryTable = UITableView()
    let categoryCell = UITableViewCell()
    let buttonAddCategory = UIButton()
    let buttonDelCategory = UIButton()
    var textFieldOperationName = UITextField()
    let service = CategoryService()
    var bottomView = UIView()

    var categories = RealmSwift.List<Category>()

    override func viewDidLoad() {
        setupUI()

        categories = service.getCategories()
        categoryTable.reloadData()
    }

    @objc
    func buttonAddCategoryTouchUp() {
        bottomView = generateAddOperationViewBottom()
        view.addSubview(bottomView)
    }

    @objc
    func buttonDelCategoryTouchUp() {
        if let index = categoryTable.indexPathForSelectedRow?.row {
            service.deleteCategory(index: index)
            categories = service.getCategories()
            categoryTable.reloadData()
        }
    }
}

// MARK: setup UI

extension CategoryController {
    func setupUI() {
        prepareUI()
        prepareLayout()
    }

    func prepareUI() {
        logoView = LogoVIew.loadViewFromNib()!
        logoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoView)

        labelTitle.text = "Список категорій"
        labelTitle.textAlignment = .center
        labelTitle.font = UIFont.boldSystemFont(ofSize: 26)
        labelTitle.textColor = .white
        view.addSubview(labelTitle)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false

        categoryCell.translatesAutoresizingMaskIntoConstraints = false

        categoryTable.translatesAutoresizingMaskIntoConstraints = false
        categoryTable.dataSource = self
        categoryTable.delegate = self
        categoryTable.register(CategoryCellView.self, forCellReuseIdentifier: "CategoryCell")
        categoryTable.backgroundColor = .gray
        categoryTable.addSubview(categoryCell)
        view.addSubview(categoryTable)

        buttonAddCategory.setTitle("Додати", for: .normal)
        buttonAddCategory.translatesAutoresizingMaskIntoConstraints = false
        buttonAddCategory.backgroundColor = .blue
        buttonAddCategory.layer.cornerRadius = 15
        buttonAddCategory.addTarget(self, action: #selector(buttonAddCategoryTouchUp), for: .touchUpInside)
        view.addSubview(buttonAddCategory)

        buttonDelCategory.setTitle("Видалити", for: .normal)
        buttonDelCategory.translatesAutoresizingMaskIntoConstraints = false
        buttonDelCategory.backgroundColor = .blue
        buttonDelCategory.layer.cornerRadius = 15
        buttonDelCategory.addTarget(self, action: #selector(buttonDelCategoryTouchUp), for: .touchUpInside)
        view.addSubview(buttonDelCategory)
    }

    func prepareLayout() {
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            logoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            logoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])

        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 16),
            labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            buttonAddCategory.topAnchor.constraint(equalTo: categoryTable.bottomAnchor, constant: 16),
            buttonAddCategory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonAddCategory.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            buttonDelCategory.topAnchor.constraint(equalTo: categoryTable.bottomAnchor, constant: 16),
            buttonDelCategory.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonDelCategory.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            categoryTable.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 16),
            categoryTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            categoryTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
            // categoryTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            categoryCell.topAnchor.constraint(equalTo: categoryTable.topAnchor, constant: 0),
            categoryCell.leadingAnchor.constraint(equalTo: categoryTable.leadingAnchor, constant: 0),
            categoryCell.trailingAnchor.constraint(equalTo: categoryTable.trailingAnchor, constant: 0),
            categoryCell.bottomAnchor.constraint(equalTo: categoryTable.bottomAnchor, constant: 0)
        ])
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension CategoryController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoryCellView else { return UITableViewCell() }

        cell.backgroundColor = .gray
        let cellModel = CategoryCellModel(name: categories[indexPath.row].name)
        cell.setup(categoryModel: cellModel)

        return cell
    }
}

// MARK: Generate some UIView items

extension CategoryController {
    private func generateAddOperationViewBottom() -> UIView {
        let viewHeight: CGFloat = 130
        let bottomView = UIView(frame: CGRect(x: 0, y: view.frame.size.height - viewHeight - 65, width: view.frame.width, height: viewHeight))
        bottomView.backgroundColor = .white

        textFieldOperationName.placeholder = "Назва категорії"
        textFieldOperationName.borderStyle = .roundedRect

        bottomView.addSubview(textFieldOperationName)

        textFieldOperationName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldOperationName.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            textFieldOperationName.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            textFieldOperationName.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16)
        ])

        let buttonAdd = UIButton()
        buttonAdd.setTitle("Додати категорію", for: .normal)
        buttonAdd.backgroundColor = .blue
        buttonAdd.layer.cornerRadius = 15
        buttonAdd.addTarget(self, action: #selector(buttonAddBottomViewTouchUp), for: .touchUpInside)
        bottomView.addSubview(buttonAdd)

        buttonAdd.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonAdd.topAnchor.constraint(equalTo: textFieldOperationName.bottomAnchor, constant: 16),
            buttonAdd.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            buttonAdd.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16)
        ])

        return bottomView
    }

    @objc
    func buttonAddBottomViewTouchUp() {
        guard let strName = textFieldOperationName.text else { return }

        service.saveCategory(name: strName)
        categories = service.getCategories()

        bottomView.removeFromSuperview()
        categoryTable.reloadData()
    }
}

// MARK: Representable

struct CategoryControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CategoryController

    func makeUIViewController(context: Context) -> CategoryController {
        CategoryController()
    }

    func updateUIViewController(_ uiViewController: CategoryController, context: Context) {}
}

struct CategoryControllerPreviews: PreviewProvider {
    static var previews: some View {
        CategoryControllerRepresentable()
    }
}
