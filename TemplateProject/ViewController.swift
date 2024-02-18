import UIKit

class ViewController: UIViewController {
    typealias MyAlias = () -> Void

    var arrayOfNumbers = [5, 2, 4, 6, 89, 1, 3, 14, 77, 66]
    var arrayOfNames = ["Roma", "Sanya", "Vladik", "Vasya", "Pertya"]

    override func viewDidLoad() {
        super.viewDidLoad()

        sortAnyArray(array: arrayOfNumbers, sortAlghoritm: { (a: Int, b: Int) in a > b })
        print(convertArrayNumbersToArrayString(array: arrayOfNumbers))
        print(convertStringArrayToSingleString(array: arrayOfNames))
        executeSomeFunc(someFunc: { print("hello") })

        var x = getReferenceForExecuteTwoFunc(func1: { print("123") }, func2: { print("321") })
        x()
    }

    func sortAnyArray(array: [Any], sortAlghoritm: @escaping (Int, Int) -> Bool) {
        if let array = array as? [Int] {
            let sortedArray = array.sorted(by: sortAlghoritm)
            print(sortedArray)
        }
    }

    func convertArrayNumbersToArrayString(array: [Int]) -> [String] {
        let strNumbers = array.map { "\($0)" }
        return strNumbers
    }

    func convertStringArrayToSingleString(array: [String]) -> String {
        let singleString = array.reduce("") { $0 + "\($1) " }
        return singleString
    }

    func executeSomeFunc(someFunc: @escaping () -> Void) {
        print("Main func execute at \(getStringDateTimeNow())")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("Some func execute at \(self.getStringDateTimeNow())")
            someFunc()
        }
    }

    func getReferenceForExecuteTwoFunc(func1: @escaping MyAlias, func2: @escaping MyAlias) -> MyAlias {
        { func1()
            func2()
        }
    }

    func getStringDateTimeNow() -> String {
        // get the current date and time
        let currentDateTime = Date()

        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        return formatter.string(from: currentDateTime) // "10:52:30"
    }
}
