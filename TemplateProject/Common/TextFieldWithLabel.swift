//
//  TextFieldWithLabel.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 22.02.2024.
//

import Foundation
import UIKit

class TextFieldWithLabel: UIView {
    // MARK: Lifecycle

    init(text: String) {
        super.init(frame: CGRect())
        label.text = text
        textField.placeholder = text
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    let label = UILabel()
    let textField = UITextField()

    // MARK: Private

    private func setupUI() {
        prepareUI()
        prepareLayout()
    }

    private func prepareUI() {
        label.font = label.font.withSize(13)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false

        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldEditChanged), for: .editingChanged)
    }

    @objc
    private func textFieldEditChanged() {
        var textFieldTextIsEmpty = true
        if let text = textField.text {
            textFieldTextIsEmpty = text.isEmpty
        }

        let labelIsAdded = !subviews.filter { $0 is UILabel }.isEmpty

        if textFieldTextIsEmpty && labelIsAdded {
            label.removeFromSuperview()

            NSLayoutConstraint.activate([
                getContraintTextFieldLowPriority()
            ])
        } else if !textFieldTextIsEmpty && !labelIsAdded {
            addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
            ])

            NSLayoutConstraint.activate([
                textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0)
            ])
        }
    }

    private func getContraintTextFieldLowPriority() -> NSLayoutConstraint {
        let topConst = textField.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        topConst.priority = .init(749)
        return topConst
    }

    private func prepareLayout() {
        NSLayoutConstraint.activate([
            getContraintTextFieldLowPriority(),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}
