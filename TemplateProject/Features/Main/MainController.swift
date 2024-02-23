//
//  MainController.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 07.02.2024.
//

import RealmSwift
import SwiftUI
import UIKit

class MainController: UIViewController {
    // MARK: Lifecycle

    deinit {
        removeKeyboardNotifications()
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        costs = service.getCosts()
        incomes = service.getIncomes()
        category = serviceCategory.getCategories()

        mainTableView.reloadData()
        labelBalance.text = "Баланс: \(service.getUserBalance()) ₴"
    }

    // MARK: Private

    private var incomes = RealmSwift.List<Income>()
    private var costs = RealmSwift.List<Costs>()
    private var category = RealmSwift.List<Category>()
    private var bottomView = UIView()
    private var textFieldOperationName: UITextField?
    private var textFieldOperationSum: UITextField?
    private let service = MainService()
    private let serviceCategory = CategoryService()
    private let header = UIView()
    private let stackView = UIStackView()
    private var logoView = UIView()
    private let pickerview = UIPickerView()

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

    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: MainController.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: MainController.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: MainController.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: MainController.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func keyboardShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[MainController.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
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

    @IBAction
    private func buttonOperationAddTouchUp(_ sender: Any) {
        category = serviceCategory.getCategories()
        bottomView = generateAddOperationViewBottom()
        registerForKeyboardNotification()
        view.addSubview(bottomView)

        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bottomView.heightAnchor.constraint(equalToConstant: segmentStatement.selectedSegmentIndex == 0 ? 180 : 300)
        ])
    }

    @IBAction
    private func buttonOperationDeleteTouchUp(_ sender: Any) {
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
    private func segmentStateIndexChanged(_ sender: Any) {
        labelKindOfCost.isHidden = segmentStatement.selectedSegmentIndex == 0
        mainTableView.reloadData()
    }

    @objc
    private func buttonAddBottomViewTouchUp() {
        guard let textFieldName = textFieldOperationName, let textFieldSum = textFieldOperationSum else { return }
        guard let strName = textFieldName.text, let amountStr = textFieldSum.text, let amount = Float(amountStr) else { return }
        if segmentStatement.selectedSegmentIndex == 0 {
            service.saveIncome(amount: amount)
            labelBalance.text = "Баланс: \(service.getUserBalance()) ₴"
        } else {
            if pickerview.selectedRow(inComponent: 0) != -1 {
                let category = category[pickerview.selectedRow(inComponent: 0)]
                service.saveCost(amount: amount, name: strName, category: category)
            }
        }
        updateArrayOfCostsAndIncomes()

        removeKeyboardNotifications()
        bottomView.removeFromSuperview()
        mainTableView.reloadData()
    }

    @objc
    private func buttonCloseBottomViewTouchUp() {
        removeKeyboardNotifications()
        bottomView.removeFromSuperview()
    }

    private func updateArrayOfCostsAndIncomes() {
        if segmentStatement.selectedSegmentIndex == 0 {
            incomes = service.getIncomes()
        } else {
            costs = service.getCosts()
        }
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource

extension MainController: UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        segmentStatement.selectedSegmentIndex == 0 ? incomes.count : costs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "operationCell") as? DataTableViewCell else { return UITableViewCell() }

        let index = indexPath.row
        let cellModel = DataTableViewCellModel(kindOfCost: segmentStatement.selectedSegmentIndex == 0 ? "" : costs[index].name, cost: segmentStatement.selectedSegmentIndex == 0 ? incomes[index].amount : costs[index].amount, Date: service.getStringDateTimeNow(date: Date()))

        cell.setup(cellModel: cellModel)

        return cell
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        category.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        category[row].name
    }
}

// MARK: setup UI

extension MainController {
    private func setupUI() {
        prepareUI()
        prepareLayout()
    }

    private func prepareUI() {
        logoView = LogoVIew.loadViewFromNib()!
        view.addSubview(logoView)

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

    private func prepareLayout() {
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

extension MainController {
    private func generateAddOperationViewBottom() -> UIView {
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        bottomView.translatesAutoresizingMaskIntoConstraints = false

//        textFieldOperationSum = UITextField()
//        textFieldOperationName = UITextField()
//        guard let textFieldOperationSum = textFieldOperationSum, let textFieldOperationName = textFieldOperationName else { return bottomView }

        if segmentStatement.selectedSegmentIndex == 0 {
//            textFieldOperationSum.placeholder = "Введіть суму прибутку"
//            textFieldOperationSum.borderStyle = .roundedRect
//            textFieldOperationSum.clearButtonMode = .whileEditing
//
//            bottomView.addSubview(textFieldOperationSum)
//
//            textFieldOperationSum.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                textFieldOperationSum.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
//                textFieldOperationSum.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
//                textFieldOperationSum.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16)
//            ])
        } else {
//            let labelCategoryText = UILabel()
//            labelCategoryText.text = "Оберіть категорію"
//            labelCategoryText.textAlignment = .center
//            labelCategoryText.translatesAutoresizingMaskIntoConstraints = false
//            bottomView.addSubview(labelCategoryText)
//            NSLayoutConstraint.activate([
//                labelCategoryText.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
//                labelCategoryText.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
//                labelCategoryText.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16)
//            ])
//
//            pickerview.dataSource = self
//            pickerview.delegate = self
//            pickerview.translatesAutoresizingMaskIntoConstraints = false
//            bottomView.addSubview(pickerview)
//
//            NSLayoutConstraint.activate([
//                pickerview.topAnchor.constraint(equalTo: labelCategoryText.bottomAnchor, constant: 0),
//                pickerview.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
//                pickerview.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
//                pickerview.heightAnchor.constraint(equalToConstant: 50)
//            ])
//
//            textFieldOperationName.placeholder = "Опис витрати"
//            textFieldOperationName.borderStyle = .roundedRect
//            textFieldOperationName.clearButtonMode = .whileEditing
//
//            textFieldOperationSum.placeholder = "Введіть суму витрати"
//            textFieldOperationSum.borderStyle = .roundedRect
//            textFieldOperationSum.keyboardType = .numberPad
//
//            bottomView.addSubview(textFieldOperationName)
//            bottomView.addSubview(textFieldOperationSum)
//
//            let textFieldWithLabel = TextFieldWithLabel(text: "Description")
//            textFieldWithLabel.translatesAutoresizingMaskIntoConstraints = false
//            bottomView.addSubview(textFieldWithLabel)
//
//            textFieldOperationName.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                textFieldOperationName.topAnchor.constraint(equalTo: pickerview.bottomAnchor, constant: 16),
//                textFieldOperationName.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
//                textFieldOperationName.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16)
//            ])
//
//            textFieldOperationSum.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                textFieldOperationSum.topAnchor.constraint(equalTo: textFieldOperationName.bottomAnchor, constant: 16),
//                textFieldOperationSum.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
//                textFieldOperationSum.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16)
//            ])
//
//            NSLayoutConstraint.activate([
//                textFieldWithLabel.topAnchor.constraint(equalTo: textFieldOperationSum.bottomAnchor, constant: 16),
//                textFieldWithLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
//                textFieldWithLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16)
//            ])
        }

//        let buttonAdd = UIButton()
//        buttonAdd.setTitle(segmentStatement.selectedSegmentIndex == 0 ? "Додати прибуток" : "Додати витрату", for: .normal)
//        buttonAdd.backgroundColor = .blue
//        buttonAdd.layer.cornerRadius = 15
//        buttonAdd.addTarget(self, action: #selector(buttonAddBottomViewTouchUp), for: .touchUpInside)
//        bottomView.addSubview(buttonAdd)
//
//        let buttonClose = UIButton()
//        buttonClose.setTitle("Закрити", for: .normal)
//        buttonClose.backgroundColor = .blue
//        buttonClose.layer.cornerRadius = 15
//        buttonClose.addTarget(self, action: #selector(buttonCloseBottomViewTouchUp), for: .touchUpInside)
//        bottomView.addSubview(buttonClose)
//
//        buttonAdd.translatesAutoresizingMaskIntoConstraints = false
//        buttonClose.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            buttonAdd.topAnchor.constraint(equalTo: textFieldOperationSum.bottomAnchor, constant: 16),
//            buttonAdd.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
//            buttonAdd.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16)
//        ])
//
//        NSLayoutConstraint.activate([
//            buttonClose.topAnchor.constraint(equalTo: buttonAdd.bottomAnchor, constant: 16),
//            buttonClose.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
//            buttonClose.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16)
//        ])

        return bottomView
    }
}

// MARK: Representable

struct MainControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MainController

    func makeUIViewController(context: Context) -> MainController {
        MainController()
    }

    func updateUIViewController(_ uiViewController: MainController, context: Context) {}
}

struct MainControllerPreviews: PreviewProvider {
    static var previews: some View {
        MainControllerRepresentable()
    }
}
