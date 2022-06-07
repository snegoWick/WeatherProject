//
//  SearchCityViewController.swift
//  WeatherProject
//
//  Created by Aleksandr Makarov on 05.06.2022.
//

import UIKit

final class SearchCityViewController: UIViewController, UISearchControllerDelegate {
    
    private enum Sections {
        case search
    }
    
    private let networkService = SearchCityNetworkService()
    private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Sections, SearchCityElement>!
    private var cityArray: [SearchCityElement] = []
    private let spinner = UIActivityIndicatorView()
    private let pageVC: PageViewController
    private var timer: Timer?
    
    init(pageVC: PageViewController) {
        self.pageVC = pageVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        setupDataSource()
        reloadData()
        setupUI()
    }
    
    //MARK: - TableView ReloadData
    @objc private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, SearchCityElement>()
        snapshot.appendSections([.search])
        snapshot.appendItems(cityArray, toSection: .search)
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    //MARK: - Private Functions
    @objc private func backButtonPressed() {
        self.navigationController?.dismiss(animated: true)
        self.dismiss(animated: false)
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupUI() {
        self.view.addSubview(spinner)
        self.spinner.centerInSuperview()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonPressed))
    }
}

//MARK: - Setup TableView & DataSource
extension SearchCityViewController {
    private func setupTableView() {
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView.register(SearchCityCell.self, forCellReuseIdentifier: SearchCityCell.reuseID)
        self.tableView.delegate = self
        self.tableView.contentInset = .init(top: 20, left: 0, bottom: 30, right: 0)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .white
        self.view.addSubview(tableView)
    }
    
    private func setupDataSource() {
        self.dataSource = UITableViewDiffableDataSource<Sections, SearchCityElement>(tableView: self.tableView, cellProvider: { [weak self] _, indexPath, itemIdentifier -> UITableViewCell? in
            
            let cell = self?.tableView.dequeueReusableCell(withIdentifier: SearchCityCell.reuseID, for: indexPath) as! SearchCityCell
            cell.selectionStyle = .none
            let cityName = self?.cityArray[indexPath.item].displayName
            cell.setLabelText(cityName ?? "")
            return cell
        })
    }
}

//MARK: - TableView Delegate
extension SearchCityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pageVC.appendCity(cityArray[indexPath.item])
        self.dismiss(animated: false)
        self.navigationController?.dismiss(animated: true)
    }
}

//MARK: - SearchBar Delegate
extension SearchCityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.spinner.startAnimating()
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { (_) in
            
            self.networkService.getCity(searchText: searchText) { cityModel in
                self.spinner.stopAnimating()
                self.cityArray = cityModel
                self.reloadData()
                self.tableView.reloadData()
            }
        })
    }
}
