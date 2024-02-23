//
//  IncomesController.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 23.02.2024.
//

import Foundation
import SwiftUI
import UIKit

class IncomesController: UIViewController {
    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
    }

    // MARK: Private

    private var bottomView = UIView()
    private let textFieldWithLabel = TextFieldWithLabel(text: "Сума")
    private let buttonAddIncome = UIButton()

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
    private func buttonAddIncomeTouchUp() {
        bottomView = generateAddOperationViewBottom()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        registerForKeyboardNotification()
        view.addSubview(bottomView)

        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bottomView.heightAnchor.constraint(equalToConstant: 180)
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
    }

    private func prepareLayout() {
        NSLayoutConstraint.activate([
            buttonAddIncome.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonAddIncome.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonAddIncome.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: Generate bottom view

extension IncomesController {
    private func generateAddOperationViewBottom() -> UIView {
        // let bottomView = UIView()
        bottomView.backgroundColor = .white

        // textFieldWithLabel = TextFieldWithLabel(text: "Сума")
        textFieldWithLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(textFieldWithLabel)

        NSLayoutConstraint.activate([
            textFieldWithLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 8),
            textFieldWithLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 0),
            textFieldWithLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: 0)
        ])

        let buttonAdd = UIButton()
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
            buttonClose.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16)
        ])

        return bottomView
    }

    @objc
    private func buttonAddBottomViewTouchUp() {
//        guard let textFieldName = textFieldOperationName, let textFieldSum = textFieldOperationSum else { return }
//        guard let strName = textFieldName.text, let amountStr = textFieldSum.text, let amount = Float(amountStr) else { return }
//        if segmentStatement.selectedSegmentIndex == 0 {
//            service.saveIncome(amount: amount)
//            labelBalance.text = "Баланс: \(service.getUserBalance()) ₴"
//        } else {
//            if pickerview.selectedRow(inComponent: 0) != -1 {
//                let category = category[pickerview.selectedRow(inComponent: 0)]
//                service.saveCost(amount: amount, name: strName, category: category)
//            }
//        }
//        updateArrayOfCostsAndIncomes()
//
//        removeKeyboardNotifications()
//        bottomView.removeFromSuperview()
//        mainTableView.reloadData()
    }

    @objc
    private func buttonCloseBottomViewTouchUp() {
        removeKeyboardNotifications()
        bottomView.removeFromSuperview()
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
