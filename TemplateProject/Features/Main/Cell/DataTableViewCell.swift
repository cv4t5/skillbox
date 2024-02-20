//
//  DataTableViewCell.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 19.02.2024.
//

import UIKit

class DataTableViewCell: UITableViewCell {
    // MARK: Internal

    func setup(cellModel: DataTableViewCellModel) {
        labelKindOfCost.isHidden = true
        labelKindOfCost.text = cellModel.kindOfCost
        labelCost.text = "\(cellModel.cost)"
        labelDate.text = cellModel.Date
    }

    // MARK: Private

    @IBOutlet private weak var labelKindOfCost: UILabel!
    @IBOutlet private weak var labelCost: UILabel!
    @IBOutlet private weak var labelDate: UILabel!
}
