//
//  WeatherCell.swift
//  WeatherProject
//
//  Created by Aleksandr Makarov on 03.06.2022.
//

import UIKit

final class CurrentWeatherCell: UICollectionViewCell {
    
    static var reuseID = "CurrentWeatherCellReuseID"
    private let cityLabel = UILabel.setupLabel(text: "", fontSize: 22)
    private let cloudIconImageView = UIImageView()
    private let temperatureLabel = UILabel.setupLabel(text: "", fontSize: 62)
    private let cloudLabel = UILabel.setupLabel(text: "", fontSize: 18)
    private let minTempLabel = UILabel.setupLabel(text: "MinTemp", fontSize: 14)
    private let maxTempLabel = UILabel.setupLabel(text: "MaxTemp", fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(value: WeatherModel) {
        let jsonCloudsName = value.list[0].weather[0].main.rawValue
        let localString = NSLocalizedString(jsonCloudsName, comment: "")
        let cloudsImage = UIImage(systemName: localString)?.withRenderingMode(.alwaysOriginal)
        self.cloudIconImageView.image = cloudsImage
        self.cityLabel.text = value.city.name
        let tempToInt = Int(value.list[0].main.temp)
        self.temperatureLabel.text = "\(tempToInt)°"
        self.cloudLabel.text = value.list[0].weather[0].weatherDescription
        self.minTempLabel.text = "мин: \(Int(value.list[0].main.tempMin))°,"
        self.maxTempLabel.text = "макс: \(Int(value.list[0].main.tempMax))°"
    }
    
    private func setupUI() {
        backgroundColor = .transparentWhite()
        self.layer.cornerRadius = 18
        
        addSubview(cityLabel)
        cityLabel.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 24, left: 14, bottom: 0, right: 0))
        cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        cloudIconImageView.contentMode = .scaleAspectFit
        addSubview(cloudIconImageView)
        cloudIconImageView.anchor(top: cityLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 14, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 80))
        cloudIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(temperatureLabel)
        temperatureLabel.anchor(top: cloudIconImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil)
        temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 8).isActive = true
        
        addSubview(cloudLabel)
        cloudLabel.anchor(top: temperatureLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 14, left: 0, bottom: 0, right: 0))
        cloudLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        let minMaxTempStackView = UIStackView(arrangedSubviews: [minTempLabel, maxTempLabel])
        minMaxTempStackView.distribution = .equalSpacing
        minMaxTempStackView.spacing = 4
        
        addSubview(minMaxTempStackView)
        minMaxTempStackView.anchor(top: cloudLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        minMaxTempStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
