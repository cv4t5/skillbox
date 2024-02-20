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

    @IBOutlet weak var segmentStatement: UISegmentedControl!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var buttonOperationDel: UIButton!
    @IBOutlet weak var buttonOperationAdd: UIButton!
    @IBOutlet weak var labelBalance: UILabel!
    var realm = try? Realm()

    var Dohodi = List<Dohodi>()
    var Vitrati = List<Vitrati>()
    // var Category = List<Category>()
    var bottomView: UIView?
    var textFieldOperationName: UITextField?
    var textFieldOperationSum: UITextField?

    @IBAction
    func buttonOperationAddTouchUp(_ sender: Any) {
        bottomView = generateAddOperationViewBottom()
        if let bottomView = bottomView {
            view.addSubview(bottomView)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let logoView = LogoVIew.loadViewFromNib()!
        view.addSubview(logoView)

        setupLabelBalance(itemToAnchor: logoView)
        setupSegmentStatement()
        setupButtonAdd()
        setupButtonDel()
        setupTableView()

        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        let stackview = UIStackView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))

        setupStackViewLabels(stackview)
        header.addSubview(stackview)
        mainTableView.tableHeaderView = header

        realmLoad()
    }

    @IBAction
    func buttonOperationDeleteTouchUp(_ sender: Any) {
        if let index = mainTableView.indexPathForSelectedRow?.row {
            if segmentStatement.selectedSegmentIndex == 0 {
                var temp = Dohodi[index]
                Dohodi.remove(at: index)
                realmDelete(item: temp)
                labelBalance.text = "Баланс: \(getUserBalance()) ₴"
            } else {
                var temp = Vitrati[index]
                Vitrati.remove(at: index)
                realmDelete(item: temp)
            }
            mainTableView.reloadData()
        }
    }

    func realmLoad() {
        if let unwrapeRealm = realm {
            for t in unwrapeRealm.objects(TemplateProject.Dohodi.self) {
                Dohodi.append(t)
            }
            labelBalance.text = "Баланс: \(getUserBalance()) ₴"
        }

        if let unwrapeRealm = realm {
            for t in unwrapeRealm.objects(TemplateProject.Vitrati.self) {
                Vitrati.append(t)
            }
        }

        mainTableView.reloadData()
    }

    @IBAction
    func segmentStateIndexChanged(_ sender: Any) {
        labelKindOfCost.isHidden = segmentStatement.selectedSegmentIndex == 0
        mainTableView.reloadData()
    }

    @objc
    func buttonAddBottomViewTouchUp() {
        guard let textFieldName = textFieldOperationName, let textFieldSum = textFieldOperationSum else { return }
        if segmentStatement.selectedSegmentIndex == 0 {
            var tempDohod = TemplateProject.Dohodi()

            if let amountString = textFieldSum.text {
                if let amount = Float(amountString) {
                    tempDohod.amount = amount
                }
            }

            tempDohod.date = Date()
            Dohodi.append(tempDohod)
            realmSave(item: tempDohod)
        } else {
            var tempVitraty = TemplateProject.Vitrati()

            if let strName = textFieldName.text {
                tempVitraty.name = strName
            }

            if let amountString = textFieldSum.text {
                if let amount = Float(amountString) {
                    tempVitraty.amount = amount
                }
            }

            tempVitraty.date = Date()
            Vitrati.append(tempVitraty)
            realmSave(item: tempVitraty)
        }

        if segmentStatement.selectedSegmentIndex == 0 {
            labelBalance.text = "Баланс: \(getUserBalance()) ₴"
        }
        bottomView?.removeFromSuperview()
        mainTableView.reloadData()
//        print("123")
    }

    func realmSave(item: Object) {
        do {
            try realm?.write {
                realm?.add(item)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func realmDelete(item: Object) {
        do {
            try realm?.write {
                realm?.delete(item)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func getUserBalance() -> Float {
        var balance: Float = 0
        balance = Dohodi.reduce(0) { $0 + $1.amount }
        return balance
    }

    func getStringDateTimeNow(date: Date) -> String {
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter.string(from: date) // "10:52:30"
    }

    // MARK: Fileprivate

    fileprivate func setupStackViewLabels(_ stackview: UIStackView) {
        stackview.axis = .horizontal
        stackview.spacing = 80
        stackview.distribution = .equalSpacing
        stackview.alignment = .center

        stackview.translatesAutoresizingMaskIntoConstraints = false

        stackview.addArrangedSubview(labelKindOfCost)
        stackview.addArrangedSubview(labelDateCost)
        stackview.addArrangedSubview(labelAmount)
    }

    // MARK: Private

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

    private func setupButtonAdd() {
        buttonOperationAdd.setTitle("Додати", for: .normal)
        buttonOperationAdd.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonOperationAdd.topAnchor.constraint(equalTo: segmentStatement.bottomAnchor, constant: 16),
            buttonOperationAdd.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            buttonOperationAdd.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }

    private func setupButtonDel() {
        buttonOperationDel.setTitle("Видалити", for: .normal)
        buttonOperationDel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonOperationDel.topAnchor.constraint(equalTo: segmentStatement.bottomAnchor, constant: 16),
            buttonOperationDel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            buttonOperationDel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }

    private func setupLabelBalance(itemToAnchor: UIView) {
        labelBalance.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelBalance.topAnchor.constraint(equalTo: itemToAnchor.bottomAnchor, constant: 16),
            labelBalance.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelBalance.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        labelBalance.textAlignment = .center
    }

    private func setupSegmentStatement() {
        segmentStatement.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            segmentStatement.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentStatement.topAnchor.constraint(equalTo: labelBalance.bottomAnchor, constant: 16)
        ])
    }

    private func setupTableView() {
        mainTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: buttonOperationAdd.bottomAnchor, constant: 16),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65)
        ])
    }

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

// MARK: UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        segmentStatement.selectedSegmentIndex == 0 ? Dohodi.count : Vitrati.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "operationCell") as? DataTableViewCell else { return UITableViewCell() }

        if segmentStatement.selectedSegmentIndex == 1 {
            cell.labelKindOfCost.text = Vitrati[indexPath.row].name
            cell.labelKindOfCost.isHidden = false
        } else {
            cell.labelKindOfCost.isHidden = true
        }

        cell.labelCost.text = segmentStatement.selectedSegmentIndex == 0 ? "\(Dohodi[indexPath.row].amount)" : "\(Vitrati[indexPath.row].amount)"
        var dateStr = segmentStatement.selectedSegmentIndex == 0 ? getStringDateTimeNow(date: Dohodi[indexPath.row].date) : getStringDateTimeNow(date: Vitrati[indexPath.row].date)
        cell.labelDate.text = dateStr

        return cell
    }
}
