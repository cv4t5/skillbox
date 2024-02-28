//
//  ViewController.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 07.02.2024.
//

import UIKit

struct Dick {
    let cm: Int
}

// MARK: CustomStringConvertible

extension Dick: CustomStringConvertible {
    var description: String {
        "Dick is \(cm) cm"
    }
}

class ViewController: UIViewController, UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let tableView = UITableView()
        var d = 6
        var x = 9
        var xz = [1, 2, 44, 4, 5, 4]
        print(itemsEqual(item1: d, item2: x))
        print(getMaxItem(item1: d, item2: x))
        equalAndRewriteItems(item1: &d, item2: &x)
        print(d, x)
        print(xz.MaxItem)
        print(xz.Distinct)
        print(2 ^^ 3)
        var a = 0
        x ^* a
        print(a)
        tableView ~> self

        let myDick = Dick(cm: 25)
        let myDick2 = Dick(cm: 28)
        print(myDick +++ myDick2)
    }

    // a) получает на вход два Equatable-объекта и, в зависимости от того, равны ли они друг другу, выводит разные сообщения в лог;
    func itemsEqual<T: Equatable>(item1: T, item2: T) -> Bool {
        item1 == item2
    }

    // b) получает на вход два сравниваемых (Comparable) друг с другом значения, сравнивает их и выводит в лог наибольшее;
    func getMaxItem<T: Comparable>(item1: T, item2: T) -> T {
        item1 > item2 ? item1 : item2
    }

    //   c) получает на вход два сравниваемых (Comparable) друг с другом значения, сравнивает их и перезаписывает первый входной параметр меньшим из двух значений, а второй параметр — большим;
    func equalAndRewriteItems<T: Comparable>(item1: inout T, item2: inout T) {
        if item1 > item2 {
            let temp = item1
            item1 = item2
            item2 = temp
        }
    }
}

//   a) возведения Int-числа в степень: оператор ^^, работает 2^3, возвращает 8;
infix operator ^^
func ^^ (numb: Int, pow: Int) -> Int {
    var result = 0

    for _ in 1 ..< pow {
        result += numb * numb
    }

    return result
}

// b) копирования во второе Int-числа удвоенного значения первого 4 ~> a, после этого a = 8;
infix operator ^*
func ^* (leftNumber: Int, rightNumber: inout Int) {
    rightNumber = leftNumber * 2
}

//   c) присваивания в экземпляр tableView делегата: myController <* tableView, поле этого myController становится делегатом для tableView;
infix operator ~>
func ~> (table: UITableView, delegate: UITableViewDelegate) {
    table.delegate = delegate
}

// d) суммирует описание двух объектов с типом CustomStringConvertable и возвращает их описание: 7 + “ string” вернет “7 string”.
infix operator +++
func +++ (leftObj: CustomStringConvertible, rightObj: CustomStringConvertible) -> String {
    leftObj.description + rightObj.description
}

//    a) Array, у которого элементы имеют тип Comparable, и добавьте генерируемое свойство, которое возвращает максимальный элемент;
//      b) Array, у которого элементы имеют тип Equatable, и добавьте функцию, которая удаляет из массива идентичные элементы.
extension Array where Element: Comparable, Element: Equatable {
    var MaxItem: Element? {
        if isEmpty { return nil }

        var max = self[0]
        for value in enumerated() {
            if max < value.element {
                max = value.element
            }
        }
        return max
    }

    var Distinct: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}
