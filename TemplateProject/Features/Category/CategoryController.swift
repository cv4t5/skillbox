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
    // MARK: Lifecycle

    deinit {
        removeKeyboardNotifications()
    }

    // MARK: Internal

    override func viewDidLoad() {
        setupUI()

        categories = service.getCategories()
        categoryTable.reloadData()
    }

    // MARK: Private

    private var categories = RealmSwift.List<Category>()

    private var logoView = UIView()
    private let labelTitle = UILabel()
    private let categoryTable = UITableView()
    private let buttonAddCategory = UIButton()
    private let buttonDelCategory = UIButton()
    private var textFieldOperationName = UITextField()
    private let service = CategoryService()
    private var bottomView = UIView()

    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: CategoryController.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: CategoryController.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: CategoryController.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: CategoryController.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func keyboardShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[CategoryController.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y -= keyboardSize.height

            NSLayoutConstraint.activate([
                bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            ])
        }
    }

    @objc
    private func keyboardHide() {
        view.frame.origin.y = 0
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }

    @objc
    private func buttonAddCategoryTouchUp() {
        bottomView = generateAddOperationViewBottom()
        registerForKeyboardNotification()
        view.addSubview(bottomView)

        let constheight = bottomView.heightAnchor.constraint(equalToConstant: 180)
        constheight.priority = .init(747)
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            constheight
        ])
    }

    @objc
    private func buttonDelCategoryTouchUp() {
        if let index = categoryTable.indexPathForSelectedRow?.row {
            service.deleteCategory(index: index)
            categories = service.getCategories()
            categoryTable.reloadData()
        }
    }
}

// MARK: setup UI

extension CategoryController {
    private func setupUI() {
        prepareUI()
        prepareLayout()
    }

    private func prepareUI() {
        logoView = LogoVIew.loadViewFromNib()!
        logoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoView)

        labelTitle.text = "Список категорій"
        labelTitle.textAlignment = .center
        labelTitle.font = UIFont.boldSystemFont(ofSize: 26)
        labelTitle.textColor = .white
        view.addSubview(labelTitle)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false

        categoryTable.translatesAutoresizingMaskIntoConstraints = false
        categoryTable.dataSource = self
        categoryTable.delegate = self
        categoryTable.register(CategoryCellView.self, forCellReuseIdentifier: "CategoryCell")
        categoryTable.backgroundColor = .gray
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

    private func prepareLayout() {
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
            categoryTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            categoryTable.bottomAnchor.constraint(equalTo: buttonDelCategory.topAnchor, constant: -16)
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

        let cellModel = CategoryCellModel(name: categories[indexPath.row].name)
        cell.setup(categoryModel: cellModel)

        return cell
    }
}

// MARK: Generate some UIView items

extension CategoryController {
    private func generateAddOperationViewBottom() -> UIView {
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        bottomView.translatesAutoresizingMaskIntoConstraints = false

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

        let buttonClose = UIButton()
        buttonClose.setTitle("Закрити", for: .normal)
        buttonClose.backgroundColor = .blue
        buttonClose.layer.cornerRadius = 15
        buttonClose.addTarget(self, action: #selector(buttonCloseBottomViewTouchUp), for: .touchUpInside)
        bottomView.addSubview(buttonClose)

        buttonAdd.translatesAutoresizingMaskIntoConstraints = false
        buttonClose.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonAdd.topAnchor.constraint(equalTo: textFieldOperationName.bottomAnchor, constant: 16),
            buttonAdd.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            buttonAdd.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16)
        ])

        NSLayoutConstraint.activate([
            buttonClose.topAnchor.constraint(equalTo: buttonAdd.bottomAnchor, constant: 16),
            buttonClose.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            buttonClose.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            buttonClose.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16)
        ])

        return bottomView
    }

    @objc
    private func buttonAddBottomViewTouchUp() {
        guard let strName = textFieldOperationName.text else { return }

        service.saveCategory(name: strName)
        categories = service.getCategories()

        bottomView.removeFromSuperview()
        removeKeyboardNotifications()
        categoryTable.reloadData()
    }

    @objc
    private func buttonCloseBottomViewTouchUp() {
        bottomView.removeFromSuperview()
        removeKeyboardNotifications()
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
