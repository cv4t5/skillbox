//
//  IncomesController.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 23.02.2024.
//

import Foundation
import RealmSwift
import SwiftUI
import UIKit

class IncomesController: UIViewController {
    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.titleView = navView

        setupUI()

        incomes = financeService.getIncomes()
        navView.labelBalance.text = "\(financeService.getUserBalance()) ₴"
        tableView.reloadData()
    }

    // MARK: Private

    private var bottomView = UIView()
    private let textFieldWithLabel = TextFieldWithLabel(text: "Сума")
    private let buttonAddIncome = UIButton()
    private let navView = NavigationIncomes(title: "Доходи")
    private let tableView = UITableView()
    private var incomes = RealmSwift.List<Income>()
    private let financeService = FinanceService()
    private let buttonAdd = UIButton()

    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: IncomesController.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: IncomesController.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: IncomesController.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: IncomesController.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func keyboardShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[IncomesController.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
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
    private func buttonAddIncomeTouchUp() {
        bottomView = generateAddOperationViewBottom()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        registerForKeyboardNotification()
        view.addSubview(bottomView)

        let constheight = bottomView.heightAnchor.constraint(equalToConstant: 160)
        constheight.priority = .init(748)
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            constheight
        ])
    }
}

// MARK: Setup UI

extension IncomesController {
    private func setupUI() {
        prepareUI()
        prepareLayout()
    }

    private func prepareUI() {
        buttonAddIncome.setTitle("Додати доход", for: .normal)
        buttonAddIncome.layer.cornerRadius = 15
        buttonAddIncome.addTarget(self, action: #selector(buttonAddIncomeTouchUp), for: .touchUpInside)
        buttonAddIncome.backgroundColor = .blue
        view.addSubview(buttonAddIncome)
        buttonAddIncome.translatesAutoresizingMaskIntoConstraints = false

        tableView.dataSource = self
        tableView.register(IncomesTableViewCell.self, forCellReuseIdentifier: "IncomeCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }

    private func prepareLayout() {
        NSLayoutConstraint.activate([
            buttonAddIncome.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            buttonAddIncome.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonAddIncome.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonAddIncome.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

// MARK: Generate bottom view

extension IncomesController {
    private func generateAddOperationViewBottom() -> UIView {
        bottomView.backgroundColor = .white

        textFieldWithLabel.translatesAutoresizingMaskIntoConstraints = false
        textFieldWithLabel.textField.keyboardType = .numberPad
        textFieldWithLabel.textField.addTarget(self, action: #selector(textFieldWithLabelEditChanged), for: .editingChanged)
        bottomView.addSubview(textFieldWithLabel)

        NSLayoutConstraint.activate([
            textFieldWithLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 8),
            textFieldWithLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 0),
            textFieldWithLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: 0)
        ])

        buttonAdd.setTitle("Додати доход", for: .normal)
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
        guard let strAmount = textFieldWithLabel.textField.text, let amount = Float(strAmount) else { return }

        financeService.saveIncome(amount: amount)
        navView.labelBalance.text = "\(financeService.getUserBalance()) ₴"
        incomes = financeService.getIncomes()
        tableView.reloadData()
        bottomView.removeFromSuperview()
    }

    @objc
    private func buttonCloseBottomViewTouchUp() {
        removeKeyboardNotifications()
        keyboardHide()
        bottomView.removeFromSuperview()
    }
}

// MARK: UITableViewDataSource

extension IncomesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        incomes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeCell") as? IncomesTableViewCell else { return UITableViewCell() }

        let modelCell = IncomesTableViewCellModel(cost: incomes[indexPath.row].amount, Date: financeService.getStringDateTimeNow(date: incomes[indexPath.row].date))
        cell.setupCell(cellModel: modelCell)

        return cell
    }
}

// MARK: Representable

struct IncomesControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = IncomesController

    func makeUIViewController(context: Context) -> IncomesController {
        IncomesController()
    }

    func updateUIViewController(_ uiViewController: IncomesController, context: Context) {}
}

struct IncomesPreviews: PreviewProvider {
    static var previews: some View {
        IncomesControllerRepresentable()
    }
}
