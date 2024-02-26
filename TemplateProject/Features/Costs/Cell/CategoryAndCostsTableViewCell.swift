//
//  CategoryAndCostsTableViewCell.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 25.02.2024.
//

import UIKit

class CategoryAndCostsTableViewCell: UITableViewCell {
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

    func setupCell(cellModel: CategoryAndCostsTableViewCellModel) {
        labelName.text = cellModel.name
        labelDate.text = cellModel.date
        labelAmount.text = "\(cellModel.amount) ₴"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: Private

    private let labelName = UILabel()
    private let labelDate = UILabel()
    private let labelAmount = UILabel()
}

// MARK: - Setup ui

extension CategoryAndCostsTableViewCell {
    private func setupUI() {
        prepareUI()
        prepareLayout()
    }

    private func prepareUI() {
        labelName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelName)

        labelDate.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelDate)

        labelAmount.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelAmount)
    }

    private func prepareLayout() {
        NSLayoutConstraint.activate([
            labelName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            labelName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelName.trailingAnchor.constraint(equalTo: labelDate.leadingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            labelDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 140),
            labelDate.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            labelAmount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            labelAmount.leadingAnchor.constraint(equalTo: labelDate.trailingAnchor, constant: 8),
            labelAmount.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
