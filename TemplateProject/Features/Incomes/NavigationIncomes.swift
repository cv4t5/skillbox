//
//  NavigationIncomes.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 23.02.2024.
//

import UIKit

class NavigationIncomes: UIView {
    // MARK: Lifecycle

    init(title: String) {
        super.init(frame: CGRect())

        labelTitle.text = title

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    let labelBalance = UILabel()

    override var intrinsicContentSize: CGSize {
        UIView.layoutFittingExpandedSize
    }

    // MARK: Private

    private let labelTextCurrBalance = UILabel()
    private let labelTitle = UILabel()
}

// MARK: - Setup UI

extension NavigationIncomes {
    private func setupUI() {
        prepareUI()
        prepareLayout()
    }

    private func prepareUI() {
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.font = UIFont.boldSystemFont(ofSize: 28)
        addSubview(labelTitle)

        labelBalance.text = "0 ₴"
        labelBalance.font = UIFont.boldSystemFont(ofSize: 20)
        labelBalance.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelBalance)

        labelTextCurrBalance.text = "Загальний баланс"
        labelTextCurrBalance.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelTextCurrBalance)
    }

    private func prepareLayout() {
        NSLayoutConstraint.activate([
            labelTextCurrBalance.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            labelTextCurrBalance.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        ])

        NSLayoutConstraint.activate([
            labelBalance.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            labelBalance.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
            labelBalance.leadingAnchor.constraint(greaterThanOrEqualTo: labelTextCurrBalance.trailingAnchor, constant: 16),
            labelBalance.lastBaselineAnchor.constraint(equalTo: labelTextCurrBalance.lastBaselineAnchor)
        ])

        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: labelBalance.bottomAnchor, constant: 16),
            labelTitle.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
