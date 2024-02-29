//
//  ViewController.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 07.02.2024.
//

import Bond
import Foundation
import ReactiveKit
import UIKit

class ViewController: UIViewController {
    // MARK: Internal

    var names = MutableObservableArray(["sanya", "roma", "vlad", "andrey", "misha", "sanya", "roma", "vlad", "andrey", "misha", "sanya", "roma", "vlad", "andrey", "misha", "sanya", "roma", "vlad", "andrey", "misha"])
    var counter = Property(0)
    var someText = Property("Rocket on moscow started")
    var startRocket = Property(false)
    var confirmRocket = Property(false)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // a) Два текстовых поля. Логин и пароль, под ними лейбл и ниже кнопка «Отправить». В лейбл выводится «некорректная почта», если введённая почта некорректна. Если почта корректна, но пароль меньше шести символов, выводится: «Слишком короткий пароль». В противном случае ничего не выводится. Кнопка «Отправить» активна, если введена корректная почта и пароль не менее шести символов.
        textFieldLogin.reactive.text.ignoreNils().map { $0.firstIndex(of: "@") == nil ? "Invalid mail" : "" }.bind(to: labelError.reactive.text)
        textFieldPass.reactive.text.ignoreNils().map { $0.count ?? 0 < 6 ? "Password cant be less a 6 characters" : "" }.bind(to: labelError.reactive.text)

        combineLatest(textFieldLogin.reactive.text, textFieldPass.reactive.text) { mail, pass in mail?.firstIndex(of: "@") != nil && pass?.count ?? 0 >= 6 }.bind(to: btnSend.reactive.isEnabled)

        // b) Текстовое поле для ввода поисковой строки. Реализуйте симуляцию «отложенного» серверного запроса при вводе текста: если не было внесено никаких изменений в текстовое поле в течение 0,5 секунд, то в консоль должно выводиться: «Отправка запроса для <введенный текст в текстовое поле>».
        tbSearch.reactive.text.ignoreNils().throttle(seconds: 0.5).observeNext { text in print("Отправка запроса для " + text) }

        // c) UITableView с выводом 20 разных имён людей и две кнопки. Одна кнопка добавляет новое случайное имя в начало списка, вторая — удаляет последнее имя. Список реактивно связан с UITableView.
        names.bind(to: tableView) { dataSource, indexPath, tableView in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "namescell") as? NamesTableViewCell else { return UITableViewCell() }

            cell.lblName.text = dataSource[indexPath.row]
            return cell
        }

        // d) Лейбл и кнопку. В лейбле выводится значение counter (по умолчанию 0), при нажатии counter увеличивается на 1.
        counter.map { "Counter is \($0)" }.bind(to: lblCounter)

        //     e) Две кнопки и лейбл. Когда на каждую кнопку нажали хотя бы один раз, в лейбл выводится: «Ракета запущена».
        startRocket.combineLatest(with: confirmRocket).observeNext { start, confirm in
            self.someText.map { start && confirm ? $0 : "" }.bind(to: self.lblRocker)
        }.dispose(in: reactive.bag)
    }

    @IBAction
    func btnStartRocket(_ sender: Any) {
        startRocket.value = !startRocket.value
    }

    @IBAction
    func btnConfirmStartRocket(_ sender: Any) {
        confirmRocket.value = !confirmRocket.value
    }

    @IBAction
    func btnAddNameTouchUp(_ sender: Any) {
        names.append("vasya")
    }

    @IBAction
    func btnCounterTouchUp(_ sender: Any) {
        counter.value += 1
    }

    @IBAction
    func btnRemoveNameTouchUp(_ sender: Any) {
        if !names.isEmpty {
            names.removeLast()
        }
    }

    // MARK: Private

    @IBOutlet private weak var lblRocker: UILabel!
    @IBOutlet private weak var btnAddName: UIButton!
    @IBOutlet private weak var btnRemoveName: UIButton!
    @IBOutlet private weak var btnCounter: UIButton!
    @IBOutlet private weak var lblCounter: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var textFieldPass: UITextField!
    @IBOutlet private weak var labelError: UILabel!
    @IBOutlet private weak var textFieldLogin: UITextField!
    @IBOutlet private weak var btnSend: UIButton!
    @IBOutlet private weak var tbSearch: UITextField!
}
