//
//  SelectCityViewController.swift
//  WeatherProject
//
//  Created by Aleksandr Makarov on 02.06.2022.
//

import UIKit

final class WeatherViewController: UIViewController {

    private enum Sections: Int, CaseIterable {
        case currentWeather, hourlyWeather, weeklyWeather
    }
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Sections, AnyHashable>?
    private let backgroundImageView = UIImageView()
    private var networkService: MainNetworkService
    private let city: SearchCityElement
    private var weatherModel: [WeatherModel] = []
    private var weatherList: [List] = []
    private let hourlySectionBackground = UIView()
    
    init(city: SearchCityElement, networkService: MainNetworkService) {
        self.city = city
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
        setupCollectionView()
        setupUI()
        setupDataSource()
        reloadData()
        fetchWeatherData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetchWeatherData() {
        networkService.getWeatherData(lat: city.lat, lon: city.lon) { result in
            switch result {

            case .success(let weatherModel):
                self.weatherModel.append(weatherModel)
                self.weatherList = weatherModel.list
                self.reloadData()

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Reload Data
    @objc private func reloadData() {
        let currentDate = Int(Date().timeIntervalSince1970) + 108000
        let currentDayComponents = Calendar.current.dateComponents([.day], from: Date())
        
        let hourlyWeatherArray = weatherList.filter { element in
            let jsonDate = element.dt
            return currentDate > jsonDate
        }
        
        let weeklyWeatherArray = weatherList.filter { element in
            let jsonFormatedDate = Date(timeIntervalSince1970: Double(element.dt))
            let jsonDateComponents = Calendar.current.dateComponents([.hour], from: jsonFormatedDate)
            let jsonDayComponents = Calendar.current.dateComponents([.day], from: jsonFormatedDate)
            let noonTime = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date())
            let noonTimeComponents = Calendar.current.dateComponents([.hour], from: noonTime ?? Date())
            let jsonDate = element.dt
            return currentDate < jsonDate && jsonDateComponents == noonTimeComponents && currentDayComponents != jsonDayComponents
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Sections, AnyHashable>()
        snapshot.appendSections([.currentWeather, .hourlyWeather, .weeklyWeather])
        snapshot.appendItems(weatherModel, toSection: .currentWeather)
        snapshot.appendItems(hourlyWeatherArray, toSection: .hourlyWeather)
        snapshot.appendItems(weeklyWeatherArray, toSection: .weeklyWeather)
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }
        
    //MARK: - Setup CollectionView
    private func setupCollectionView() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupCompositionalLayout())
        self.collectionView.backgroundColor = .clear
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: CurrentWeatherCell.reuseID)
        self.collectionView.register(HourlyWeatherCell.self, forCellWithReuseIdentifier: HourlyWeatherCell.reuseID)
        self.collectionView.register(WeeklyWeatherCell.self, forCellWithReuseIdentifier: WeeklyWeatherCell.reuseID)
    }

    //MARK: - Setup Layout
    private func setupUI() {
        let backgroundImage = UIImage(named: "backgroundImage")
        self.backgroundImageView.image = backgroundImage
       
        self.view.addSubview(backgroundImageView)
        self.backgroundImageView.fillSuperview()
        self.addBlurEffect()
        
        self.view.addSubview(collectionView)
        self.collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        
        let point = view.frame.size.width - 45
        self.hourlySectionBackground.backgroundColor = .transparentWhite()
        self.hourlySectionBackground.layer.cornerRadius = 18
        self.collectionView.addSubview(hourlySectionBackground)
        self.hourlySectionBackground.anchor(top: collectionView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: point, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 120))
    }
}

//MARK: - Setup Compositional Layout
extension WeatherViewController {
    
    private func setupCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            guard let section = Sections(rawValue: sectionIndex ) else {
                fatalError("Получена неизвестная секция")
            }
            switch section {
                
            case .currentWeather:
                return NSCollectionLayoutSection.currentWeatherCellLayout()
                
            case .hourlyWeather:
                return NSCollectionLayoutSection.hourlyWeatherCellLayout()
                
            case .weeklyWeather:
                return NSCollectionLayoutSection.weeklyWeatherCellLayout()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
}

//MARK: - Setup CollectionView DataSource
extension WeatherViewController {
    
    private func setupDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Sections, AnyHashable>(collectionView: collectionView, cellProvider: { collectionView, indexPath, weather -> UICollectionViewCell? in
            guard let section = Sections(rawValue: indexPath.section) else {
                fatalError("Error Create Section")
            }
            switch section {
                
            case .currentWeather:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCell.reuseID, for: indexPath) as! CurrentWeatherCell
                guard let weatherModel: WeatherModel = weather as? WeatherModel else { return cell }
                cell.configure(value: weatherModel)
                return cell
                
            case .hourlyWeather:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCell.reuseID, for: indexPath) as! HourlyWeatherCell
                guard let weatherList: List = weather as? List else { return cell }
                cell.configure(value: weatherList)
                return cell
                
            case .weeklyWeather:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyWeatherCell.reuseID, for: indexPath) as! WeeklyWeatherCell
                guard let weatherList: List = weather as? List else { return cell }
                cell.configure(value: weatherList)
                return cell
            }
        })
    }
}
