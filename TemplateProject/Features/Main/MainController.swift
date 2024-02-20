//
//  MainController.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 07.02.2024.
//

import RealmSwift
import UIKit

class ViewController: UIViewController {
    // MARK: Internal

    var incomes = List<Income>()
    var costs = List<Costs>()
    // var Category = List<Category>()
    var bottomView: UIView?
    var textFieldOperationName: UITextField?
    var textFieldOperationSum: UITextField?
    let service = MainService()
    let header = UIView()
    let stackView = UIStackView()
    var logoView = UIView()

    @IBOutlet weak var stackViewCell: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        logoView = LogoVIew.loadViewFromNib()!
        view.addSubview(logoView)

        setupUI()

        costs = service.getCosts()
        incomes = service.getIncomes()

        mainTableView.reloadData()
        labelBalance.text = "Баланс: \(service.getUserBalance()) ₴"
    }

    @IBAction
    func buttonOperationAddTouchUp(_ sender: Any) {
        bottomView = generateAddOperationViewBottom()
        if let bottomView = bottomView {
            view.addSubview(bottomView)
        }
    }

    @IBAction
    func buttonOperationDeleteTouchUp(_ sender: Any) {
        if let index = mainTableView.indexPathForSelectedRow?.row {
            if segmentStatement.selectedSegmentIndex == 0 {
                service.deleteIncome(index: index)
                labelBalance.text = "Баланс: \(service.getUserBalance()) ₴"
            } else {
                service.deleteCosts(index: index)
            }
            updateArrayOfCostsAndIncomes()
            mainTableView.reloadData()
        }
    }

    @IBAction
    func segmentStateIndexChanged(_ sender: Any) {
        labelKindOfCost.isHidden = segmentStatement.selectedSegmentIndex == 0
        mainTableView.reloadData()
    }

    @objc
    func buttonAddBottomViewTouchUp() {
        guard let textFieldName = textFieldOperationName, let textFieldSum = textFieldOperationSum else { return }
        guard let strName = textFieldName.text, let amountStr = textFieldSum.text, let amount = Float(amountStr) else { return }
        if segmentStatement.selectedSegmentIndex == 0 {
            service.saveIncome(amount: amount)
            labelBalance.text = "Баланс: \(service.getUserBalance()) ₴"
        } else {
            service.saveCost(amount: amount, name: strName)
        }
        updateArrayOfCostsAndIncomes()

        bottomView?.removeFromSuperview()
        mainTableView.reloadData()
    }

    func updateArrayOfCostsAndIncomes() {
        if segmentStatement.selectedSegmentIndex == 0 {
            incomes = service.getIncomes()
        } else {
            costs = service.getCosts()
        }
    }

    // MARK: Private

    @IBOutlet private weak var segmentStatement: UISegmentedControl!
    @IBOutlet private weak var mainTableView: UITableView!
    @IBOutlet private weak var buttonOperationDel: UIButton!
    @IBOutlet private weak var buttonOperationAdd: UIButton!
    @IBOutlet private weak var labelBalance: UILabel!

    private let labelKindOfCost: UILabel = {
        let label = UILabel()
        label.text = "На що"
        label.isHidden = true
        return label
    }()

    private let labelDateCost: UILabel = {
        let label = UILabel()
        label.text = "Дата"
        return label
    }()

    private let labelAmount: UILabel = {
        let label = UILabel()
        label.text = "Скільки"
        return label
    }()
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        segmentStatement.selectedSegmentIndex == 0 ? incomes.count : costs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "operationCell") as? DataTableViewCell else { return UITableViewCell() }

        if segmentStatement.selectedSegmentIndex == 1 {
            cell.labelKindOfCost.text = costs[indexPath.row].name
            cell.labelKindOfCost.isHidden = false
        } else {
            cell.labelKindOfCost.isHidden = true
        }

        cell.labelCost.text = segmentStatement.selectedSegmentIndex == 0 ? "\(incomes[indexPath.row].amount)" : "\(costs[indexPath.row].amount)"
        var dateStr = segmentStatement.selectedSegmentIndex == 0 ? service.getStringDateTimeNow(date: incomes[indexPath.row].date) : service.getStringDateTimeNow(date: costs[indexPath.row].date)
        cell.labelDate.text = dateStr

        return cell
    }
}

// MARK: setup UI

extension ViewController {
    func setupUI() {
        prepareUI()
        prepareLayout()
    }

    func prepareUI() {
        mainTableView.translatesAutoresizingMaskIntoConstraints = false

        segmentStatement.translatesAutoresizingMaskIntoConstraints = false

        labelBalance.translatesAutoresizingMaskIntoConstraints = false
        labelBalance.textAlignment = .center

        buttonOperationDel.setTitle("Видалити", for: .normal)
        buttonOperationDel.translatesAutoresizingMaskIntoConstraints = false

        buttonOperationAdd.setTitle("Додати", for: .normal)
        buttonOperationAdd.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .horizontal
        stackView.spacing = 80
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(labelKindOfCost)
        stackView.addArrangedSubview(labelDateCost)
        stackView.addArrangedSubview(labelAmount)

        header.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(stackView)
        mainTableView.tableHeaderView = header
    }

    func prepareLayout() {
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: buttonOperationAdd.bottomAnchor, constant: 16),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65)
        ])

        NSLayoutConstraint.activate([
            segmentStatement.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentStatement.topAnchor.constraint(equalTo: labelBalance.bottomAnchor, constant: 16)
        ])

        NSLayoutConstraint.activate([
            labelBalance.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 16),
            labelBalance.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelBalance.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            buttonOperationDel.topAnchor.constraint(equalTo: segmentStatement.bottomAnchor, constant: 16),
            buttonOperationDel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            //            buttonOperationDel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            buttonOperationAdd.topAnchor.constraint(equalTo: segmentStatement.bottomAnchor, constant: 16),
            buttonOperationAdd.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
            //            buttonOperationAdd.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: mainTableView.topAnchor, constant: 0),
            header.leadingAnchor.constraint(equalTo: mainTableView.leadingAnchor, constant: 0),
            header.trailingAnchor.constraint(equalTo: mainTableView.trailingAnchor, constant: 0)
        ])
    }
}

// MARK: Generate some UIView items

extension ViewController {
    private func generateAddOperationViewBottom() -> UIView {
        let viewHeight: CGFloat = segmentStatement.selectedSegmentIndex == 0 ? 130 : 180
        let bottomView = UIView(frame: CGRect(x: 0, y: view.frame.size.height - viewHeight - 65, width: view.frame.width, height: viewHeight))
        bottomView.layer.borderWidth = 3
        bottomView.layer.borderColor = UIColor.black.cgColor
        bottomView.backgroundColor = .white

        textFieldOperationSum = UITextField()
        textFieldOperationName = UITextField()
        guard let textFieldOperationSum = textFieldOperationSum, let textFieldOperationName = textFieldOperationName else { return bottomView }

        if segmentStatement.selectedSegmentIndex == 0 {
            textFieldOperationSum.placeholder = "Введіть суму прибутку"
            textFieldOperationSum.borderStyle = .roundedRect

            bottomView.addSubview(textFieldOperationSum)

            textFieldOperationSum.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textFieldOperationSum.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
                textFieldOperationSum.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
                textFieldOperationSum.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16)
            ])
        } else {
            textFieldOperationName.placeholder = "Опис витрати"
            textFieldOperationName.borderStyle = .roundedRect

            textFieldOperationSum.placeholder = "Введіть суму витрати"
            textFieldOperationSum.borderStyle = .roundedRect
            textFieldOperationSum.keyboardType = .numberPad

            bottomView.addSubview(textFieldOperationName)
            bottomView.addSubview(textFieldOperationSum)

            textFieldOperationName.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textFieldOperationName.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
                textFieldOperationName.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
                textFieldOperationName.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16)
            ])

            textFieldOperationSum.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textFieldOperationSum.topAnchor.constraint(equalTo: textFieldOperationName.bottomAnchor, constant: 16),
                textFieldOperationSum.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
                textFieldOperationSum.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16)
            ])
        }

        let buttonAdd = UIButton()
        buttonAdd.setTitle(segmentStatement.selectedSegmentIndex == 0 ? "Додати прибуток" : "Додати витрату", for: .normal)
        buttonAdd.backgroundColor = .blue
        buttonAdd.layer.cornerRadius = 15
        buttonAdd.addTarget(self, action: #selector(buttonAddBottomViewTouchUp), for: .touchUpInside)
        bottomView.addSubview(buttonAdd)

        buttonAdd.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonAdd.topAnchor.constraint(equalTo: textFieldOperationSum.bottomAnchor, constant: 16),
            buttonAdd.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            buttonAdd.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16)
        ])

        return bottomView
    }
}
