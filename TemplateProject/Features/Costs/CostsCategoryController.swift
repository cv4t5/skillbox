//
//  CostsCategoryController.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 25.02.2024.
//

import Foundation
import RealmSwift
import UIKit

class CostsCategoryController: UIViewController {
    // MARK: Internal

    var selectedCategory = Category()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()

        costs = finService.getCostsOfCategory(category: selectedCategory)
        tableView.reloadData()
    }

    // MARK: Private

    private let button = UIButton()
    private let tableView = UITableView()
    private let stackview = UIStackView()
    private let labelName = UILabel()
    private let labelDate = UILabel()
    private let labelAmount = UILabel()
    private let buttonAddCost = UIButton()
    private let labelButtonAddDescription = UILabel()
    private let textFieldWithLabelName = TextFieldWithLabel(text: "Назва")
    private let textFieldWithLabelAmount = TextFieldWithLabel(text: "Сума")
    private var bottomView = UIView()
    private let buttonAdd = UIButton()
    private var costs = RealmSwift.List<Costs>()
    private let finService = FinanceService()

    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: CostsCategoryController.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: CostsCategoryController.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: CostsCategoryController.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: CostsCategoryController.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func keyboardShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[CostsCategoryController.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
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
    private func buttonAddCostTouchUp() {
        bottomView = generateAddOperationViewBottom()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        registerForKeyboardNotification()
        view.addSubview(bottomView)

        let constheight = bottomView.heightAnchor.constraint(equalToConstant: 200)
        constheight.priority = .init(748)
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            constheight
        ])
    }
}

// MARK: UITableViewDataSource

extension CostsCategoryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        costs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryandcostCell") as? CategoryAndCostsTableViewCell else { return UITableViewCell() }

        let cost = costs[indexPath.row]
        let cellModel = CategoryAndCostsTableViewCellModel(name: cost.name, date: finService.getStringDateTimeNow(date: cost.date), amount: cost.amount)
        cell.setupCell(cellModel: cellModel)

        return cell
    }
}

// MARK: - Setup UI

extension CostsCategoryController {
    private func setupUI() {
        prepareUI()
        prepareLayout()
    }

    private func prepareUI() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Графік платіжок", for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .blue
        view.addSubview(button)

        labelName.text = "На що"
        labelName.textColor = .systemGray3
        labelName.font = UIFont.boldSystemFont(ofSize: 12)

        labelDate.text = "Коли"
        labelDate.textColor = .systemGray3
        labelDate.font = UIFont.boldSystemFont(ofSize: 12)

        labelAmount.text = "Скільки"
        labelAmount.textColor = .systemGray3
        labelAmount.font = UIFont.boldSystemFont(ofSize: 12)

        stackview.addArrangedSubview(labelName)
        stackview.addArrangedSubview(labelDate)
        stackview.addArrangedSubview(labelAmount)
        stackview.axis = .horizontal
        stackview.distribution = .equalCentering
        stackview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackview)

        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CategoryAndCostsTableViewCell.self, forCellReuseIdentifier: "categoryandcostCell")
        view.addSubview(tableView)

        buttonAddCost.setTitle("+", for: .normal)
        buttonAddCost.backgroundColor = .blue
        buttonAddCost.titleLabel?.font = UIFont.boldSystemFont(ofSize: 35)
        buttonAddCost.layer.cornerRadius = 40
        buttonAddCost.addTarget(self, action: #selector(buttonAddCostTouchUp), for: .touchUpInside)
        buttonAddCost.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonAddCost)

        labelButtonAddDescription.translatesAutoresizingMaskIntoConstraints = false
        labelButtonAddDescription.text = "Додати витрату"
        labelButtonAddDescription.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(labelButtonAddDescription)
    }

    private func prepareLayout() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            stackview.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 30),
            stackview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: stackview.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            buttonAddCost.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            buttonAddCost.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonAddCost.heightAnchor.constraint(equalToConstant: 80),
            buttonAddCost.widthAnchor.constraint(equalToConstant: 80)
        ])

        NSLayoutConstraint.activate([
            labelButtonAddDescription.topAnchor.constraint(equalTo: buttonAddCost.bottomAnchor, constant: 16),
            labelButtonAddDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelButtonAddDescription.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

extension CostsCategoryController {
    private func generateAddOperationViewBottom() -> UIView {
        bottomView.backgroundColor = .white

        textFieldWithLabelName.translatesAutoresizingMaskIntoConstraints = false
        textFieldWithLabelName.textField.addTarget(self, action: #selector(textFieldWithLabelEditChanged), for: .editingChanged)
        bottomView.addSubview(textFieldWithLabelName)

        NSLayoutConstraint.activate([
            textFieldWithLabelName.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 8),
            textFieldWithLabelName.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 0),
            textFieldWithLabelName.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: 0)
        ])

        textFieldWithLabelAmount.translatesAutoresizingMaskIntoConstraints = false
        textFieldWithLabelAmount.textField.keyboardType = .numberPad
        bottomView.addSubview(textFieldWithLabelAmount)

        NSLayoutConstraint.activate([
            textFieldWithLabelAmount.topAnchor.constraint(equalTo: textFieldWithLabelName.bottomAnchor, constant: 8),
            textFieldWithLabelAmount.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 0),
            textFieldWithLabelAmount.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: 0)
        ])

        buttonAdd.setTitle("Додати витрату", for: .normal)
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
            buttonAdd.topAnchor.constraint(equalTo: textFieldWithLabelAmount.bottomAnchor, constant: 16),
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
        buttonAdd.isEnabled = !(textFieldWithLabelName.textField.text?.isEmpty ?? true)
    }

    @objc
    private func buttonAddBottomViewTouchUp() {
        guard let strAmount = textFieldWithLabelAmount.textField.text, let amount = Float(strAmount), let strName = textFieldWithLabelName.textField.text else { return }
        finService.saveCost(amount: amount, name: strName, category: selectedCategory)
        costs = finService.getCostsOfCategory(category: selectedCategory)
        tableView.reloadData()
        bottomView.removeFromSuperview()
        removeKeyboardNotifications()
    }

    @objc
    private func buttonCloseBottomViewTouchUp() {
        removeKeyboardNotifications()
        keyboardHide()
        bottomView.removeFromSuperview()
    }
}
