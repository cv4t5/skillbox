//
//  CategoryCellView.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 21.02.2024.
//

import Foundation
import UIKit

class CategoryCellView: UITableViewCell {
    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupUI()
    }

    // MARK: Internal

    func setup(categoryModel: CategoryCellModel) {
        label.text = categoryModel.name
    }

    // MARK: Private

    private let label = UILabel()
}

// MARK: setup UI cell

extension CategoryCellView {
    private func setupUI() {
        prepareUI()
        prepareLayout()
    }

    private func prepareUI() {
        contentView.backgroundColor = .gray

        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
    }

    private func prepareLayout() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
