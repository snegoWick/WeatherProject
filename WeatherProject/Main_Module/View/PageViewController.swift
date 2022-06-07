//
//  PageViewController.swift
//  WeatherProject
//
//  Created by Aleksandr Makarov on 04.06.2022.
//

import UIKit

final class PageViewController: UIPageViewController {
    
    private let welcomeLabel = UILabel.setupLabel(text: "Выберите город", fontSize: 20, textColor: .white)
    private let networkService = MainNetworkService()
    private var cities: [SearchCityElement] = []
    private var arrayViewControllers: [WeatherViewController] = []
    private var currentShowIndex = 0
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: nil)
        self.cities = CitiesArrayCache.get()
        self.dataSource = self
        self.delegate = self
        createViewControllers()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - External Functions
    func appendCity(_ city: SearchCityElement) {
        self.cities.append(city)
        let index = cities.endIndex - 1
        self.currentShowIndex = index
        let city = self.cities[index]
        self.arrayViewControllers.append(WeatherViewController(city: city, networkService: self.networkService))
        self.goToPage(index: index)
        self.updateWelcomeLabelState()
        CitiesArrayCache.save(cities)
    }
    
    func deleteCity(index: Int) {
        self.cities.remove(at: index)
        self.arrayViewControllers.remove(at: index)
        if !self.cities.isEmpty {
            self.currentShowIndex = 0
            self.setViewControllers([arrayViewControllers[0]], direction: .forward, animated: false)
        } else if self.cities.isEmpty {
            self.currentShowIndex = 0
            self.setViewControllers([UIViewController()], direction: .forward, animated: false)
        }
        CitiesArrayCache.save(cities)
        self.updateWelcomeLabelState()
    }
    
    func goToPage(index: Int) {
        if index <= arrayViewControllers.count {
            self.currentShowIndex = index
            self.setViewControllers([arrayViewControllers[index]], direction: .forward, animated: false)
        }
    }
    
    //MARK: - Private Functions
    private func updateWelcomeLabelState() {
        self.cities.isEmpty ? (welcomeLabel.isHidden = false) : (welcomeLabel.isHidden = true)
    }
    
    private func createViewControllers() {
        for i in cities {
            let index = cities.firstIndex(of: i)
            let cityName = cities[index ?? 0]
            arrayViewControllers.append(WeatherViewController(city: cityName, networkService: self.networkService))
            if !arrayViewControllers.isEmpty {
                self.currentShowIndex = 0
                setViewControllers([arrayViewControllers[0]], direction: .forward, animated: false)
            }
        }
    }
    
    //MARK: - Selectors
    @objc private func navRightButtonPressed() {
        let citiesNavVC = CitiesNavigationViewController(cities: self.cities, pageVC: self)
        let navController = UINavigationController(rootViewController: citiesNavVC)
        navController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(navController, animated: true)
    }
    
    @objc private func navLeftbuttonPressed() {
        let searchCityVC = SearchCityViewController(pageVC: self)
        let navController = UINavigationController(rootViewController: searchCityVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        self.view.backgroundColor = .grafit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navLeftbuttonPressed))
        let rightButtonImage = UIImage(systemName: "list.bullet")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightButtonImage, style: .plain, target: self, action: #selector(navRightButtonPressed))
        
        view.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 50, left: 0, bottom: 0, right: 0))
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        updateWelcomeLabelState()
    }
}

//MARK: - Self DataSource, Delegate
extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? WeatherViewController else { return nil}
        if let index = arrayViewControllers.firstIndex(of: vc) {
            if index > 0 {
                return arrayViewControllers[index - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? WeatherViewController else { return nil}
        if let index = arrayViewControllers.firstIndex(of: vc) {
            if index < self.cities.count - 1 {
                return arrayViewControllers[index + 1]
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return cities.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentShowIndex
    }
}
