//
//  GraphicCellView.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 22.02.2024.
//

import Foundation
import UIKit

class GraphicCellView: UITableViewCell {
    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    func setup(cellModel: GraphicCellModel) {
        labelDate.text = "Дата: " + serviceMain.getStringDateTimeNow(date: cellModel.date)
        labelSum.text = "Сума: \(cellModel.sum) ₴"
    }

    // MARK: Private

    private let labelDate = UILabel()
    private let labelSum = UILabel()
    private let serviceMain = MainService()
}

// MARK: setup UI

extension GraphicCellView {
    private func setupUI() {
        prepareUI()
        prepareLayout()
    }

    private func prepareUI() {
        labelSum.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelSum)

        labelDate.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelDate)
    }

    private func prepareLayout() {
        NSLayoutConstraint.activate([
            labelDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            labelDate.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            labelSum.leadingAnchor.constraint(equalTo: labelSum.leadingAnchor, constant: 40),
            labelSum.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            labelSum.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
