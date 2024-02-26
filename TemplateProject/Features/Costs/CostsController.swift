//
//  CostsController.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 23.02.2024.
//

import Foundation
import RealmSwift
import SwiftUI
import UIKit

class CostsController: UIViewController {
    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()

        categories = financeService.getCategories()
        tableView.reloadData()
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        if tableView.indexPathForSelectedRow != nil {
//            let costsCategoryController = CostsCategoryController()
//            navigationController?.pushViewController(costsCategoryController, animated: true)
//        }
//    }

    // MARK: Private

    private var bottomView = UIView()
    private let textFieldWithLabel = TextFieldWithLabel(text: "Назва категорії")
    private let buttonAdd = UIButton()
    private let tableView = UITableView()
    private var categories = RealmSwift.List<Category>()
    private let buttonAddCategory = UIButton()
    private let financeService = FinanceService()

    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: CostsController.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: CostsController.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: CostsController.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: CostsController.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func keyboardShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[CostsController.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y = 0
            view.frame.origin.y -= keyboardSize.height

            NSLayoutConstraint.activate([
                bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
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
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        registerForKeyboardNotification()

        let constHeight = bottomView.heightAnchor.constraint(equalToConstant: 160)
        constHeight.priority = .init(748)
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            constHeight
        ])
    }
}

// MARK: - Setup UI

extension CostsController {
    private func setupUI() {
        prepareUI()
        prepareLayout()
    }

    private func prepareUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoriesTableViewCell.self, forCellReuseIdentifier: "cellCategory")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        buttonAddCategory.setTitle("Додати категорію витрат", for: .normal)
        buttonAddCategory.layer.cornerRadius = 15
        buttonAddCategory.backgroundColor = .blue
        buttonAddCategory.translatesAutoresizingMaskIntoConstraints = false
        buttonAddCategory.addTarget(self, action: #selector(buttonAddCategoryTouchUp), for: .touchUpInside)
        view.addSubview(buttonAddCategory)
    }

    private func prepareLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            buttonAddCategory.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            buttonAddCategory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonAddCategory.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonAddCategory.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension CostsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory") as? CategoriesTableViewCell else { return UITableViewCell() }

        let cellModel = CategoriesTableViewCellModel(name: categories[indexPath.row].name)
        cell.setupCell(cellModel: cellModel)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let costsCategoryController = CostsCategoryController()
        costsCategoryController.selectedCategory = categories[indexPath.row]
        navigationController?.pushViewController(costsCategoryController, animated: true)
    }
}

// MARK: Generate bottom view

extension CostsController {
    private func generateAddOperationViewBottom() -> UIView {
        bottomView.backgroundColor = .white

        textFieldWithLabel.translatesAutoresizingMaskIntoConstraints = false
        textFieldWithLabel.textField.addTarget(self, action: #selector(textFieldWithLabelEditChanged), for: .editingChanged)
        bottomView.addSubview(textFieldWithLabel)

        NSLayoutConstraint.activate([
            textFieldWithLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 8),
            textFieldWithLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 0),
            textFieldWithLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: 0)
        ])

        buttonAdd.setTitle("Додати категорію витрат", for: .normal)
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
            buttonAdd.topAnchor.constraint(equalTo: textFieldWithLabel.bottomAnchor, constant: 16),
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
    private func textFieldWithLabelEditChanged() {
        buttonAdd.isEnabled = !(textFieldWithLabel.textField.text?.isEmpty ?? true)
    }

    @objc
    private func buttonAddBottomViewTouchUp() {
        guard let strName = textFieldWithLabel.textField.text else { return }

        financeService.saveCategory(name: strName)
        categories = financeService.getCategories()

        tableView.reloadData()
        bottomView.removeFromSuperview()
        removeKeyboardNotifications()
    }

    @objc
    private func buttonCloseBottomViewTouchUp() {
        keyboardHide()
        removeKeyboardNotifications()
        bottomView.removeFromSuperview()
    }
}

// MARK: Representable

struct CostControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CostsController

    func makeUIViewController(context: Context) -> CostsController {
        CostsController()
    }

    func updateUIViewController(_ uiViewController: CostsController, context: Context) {}
}

struct CostPreviews: PreviewProvider {
    static var previews: some View {
        CostControllerRepresentable()
    }
}
