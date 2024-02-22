//
//  GraphicsController.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 19.02.2024.
//

import Foundation
import RealmSwift
import SwiftUI
import UIKit

class GraphicsController: UIViewController {
    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        category = serviceCategory.getCategories()
    }

    // MARK: Private

    private var logoView = UIView()
    private let pickerView = UIPickerView()
    private let label = UILabel()
    private let serviceCategory = CategoryService()
    private let serviceGraphic = GraphicService()
    private var category = RealmSwift.List<Category>()
    private let segmentControl = UISegmentedControl()
    private let tableView = UITableView()
    private var graphicModels: [GraphicCellModel]?

    @objc
    private func segmentControlChangeIndex() {
        if segmentControl.selectedSegmentIndex != -1 && pickerView.selectedRow(inComponent: 0) != -1 {
            graphicModels = serviceGraphic.getFiltredCosts(category: category[pickerView.selectedRow(inComponent: 0)])
            tableView.reloadData()
        }
    }
}

// MARK: setup UI

extension GraphicsController {
    private func setupUI() {
        prepareUI()
        prepareLayout()
    }

    private func prepareUI() {
        logoView = LogoVIew.loadViewFromNib()!
        logoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoView)

        label.text = "Оберіть категорію"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        view.addSubview(label)

        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.setValue(UIColor.white, forKeyPath: "textColor")
        view.addSubview(pickerView)

        segmentControl.insertSegment(withTitle: "Тиждень", at: segmentControl.numberOfSegments, animated: false)
        segmentControl.insertSegment(withTitle: "Місяць", at: segmentControl.numberOfSegments, animated: false)
        segmentControl.insertSegment(withTitle: "Всі", at: segmentControl.numberOfSegments, animated: false)
        segmentControl.addTarget(self, action: #selector(segmentControlChangeIndex), for: .valueChanged)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentControl)

        tableView.dataSource = self
        tableView.register(GraphicCellView.self, forCellReuseIdentifier: "GraphicCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }

    private func prepareLayout() {
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            logoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            logoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.heightAnchor.constraint(equalToConstant: 150)
        ])

        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 8),
            segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8)
        ])
    }
}

// MARK: UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource

extension GraphicsController: UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        category.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        category[row].name
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let graphicModels = graphicModels {
            return graphicModels.count
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GraphicCell") as? GraphicCellView else { return UITableViewCell() }

        if let graphicModels = graphicModels {
            let modelCell = graphicModels[indexPath.row]

            cell.setup(cellModel: modelCell)
        }

        return cell
    }
}

// MARK: Representable

struct GraphicsControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = GraphicsController

    func makeUIViewController(context: Context) -> GraphicsController {
        GraphicsController()
    }

    func updateUIViewController(_ uiViewController: GraphicsController, context: Context) {}
}

struct GraphicsControllerPreviews: PreviewProvider {
    static var previews: some View {
        GraphicsControllerRepresentable()
    }
}
