//
//  CitiesNavigationViewController.swift
//  WeatherProject
//
//  Created by Aleksandr Makarov on 06.06.2022.
//

import UIKit

final class CitiesNavigationViewController: UIViewController {
    
    private var tableView: UITableView!
    private var cities: [SearchCityElement]
    private let pageVC: PageViewController
    
    init(cities: [SearchCityElement], pageVC: PageViewController) {
        self.cities = cities
        self.pageVC = pageVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
    }
    
    //MARK: - Setup TableView
    private func setupTableView() {
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView.register(SearchCityCell.self, forCellReuseIdentifier: SearchCityCell.reuseID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .white
        self.view.addSubview(tableView)
    }
    
    //MARK: - Selectors
    @objc private func leftNavButtonPressed() {
        self.navigationController?.dismiss(animated: true)
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(leftNavButtonPressed))
    }
}

//MARK: - TableView DataSource & Delegate
extension CitiesNavigationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: SearchCityCell.reuseID, for: indexPath) as! SearchCityCell
        let cityName = self.cities[indexPath.row].displayName
        cell.setLabelText(cityName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pageVC.goToPage(index: indexPath.row)
        self.navigationController?.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.cities.remove(at: indexPath.row)
            self.pageVC.deleteCity(index: indexPath.row)
            self.tableView.reloadData()
        }
    }
}
