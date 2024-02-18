import UIKit

class ViewController: UIViewController {
    var arrayOfNumbers: [Int] = [5, 2, 4, 6, 89, 1, 3, 14, 77, 66]

    override func viewDidLoad() {
        super.viewDidLoad()

        sortAndPrintArray(array: arrayOfNumbers)
    }

    func sortAndPrintArray(array: [Any]) {
        if let array = array as? [Int] {
            let sortedArray = array.sorted(by: >)
            print(sortedArray)
        }
    }
}
