//
//  CategoriesTableViewCell.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 23.02.2024.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {
    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        accessoryType = .disclosureIndicator
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    func setupCell(cellModel: CategoriesTableViewCellModel) {
        labelName.text = cellModel.name
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: Private

    private let labelName = UILabel()
}

// MARK: - Setup ui

extension CategoriesTableViewCell {
    private func setupUI() {
        prepareUI()
        prepareLayout()
    }

    private func prepareUI() {
        labelName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelName)
    }

    private func prepareLayout() {
        NSLayoutConstraint.activate([
            labelName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            labelName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            labelName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
