//
//  IncomesTableViewCell.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 23.02.2024.
//

import UIKit

class IncomesTableViewCell: UITableViewCell {
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

    func setupCell(cellModel: IncomesTableViewCellModel) {
        labelDate.text = "\(cellModel.Date)"
        labelSum.text = "\(cellModel.cost)"
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

    private let labelDate = UILabel()
    private let labelSum = UILabel()
}

// MARK: - Setup ui

extension IncomesTableViewCell {
    private func setupUI() {
        prepareUI()
        prepareLayout()
    }

    private func prepareUI() {
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelDate)

        labelSum.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelSum)
    }

    private func prepareLayout() {
        NSLayoutConstraint.activate([
            labelDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            labelDate.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            labelSum.leadingAnchor.constraint(greaterThanOrEqualTo: labelDate.trailingAnchor, constant: 8),
            labelSum.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            labelSum.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
