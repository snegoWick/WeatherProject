//
//  WeeklyWeatherCell.swift
//  WeatherProject
//
//  Created by Aleksandr Makarov on 03.06.2022.
//

import UIKit

final class WeeklyWeatherCell: UICollectionViewCell {
    
    static var reuseID = "WeeklyWeatherCellReuseID"
    private let weekDayLabel = UILabel.setupLabel(text: "Week Day", fontSize: 16)
    private let cloudIconImageView = UIImageView()
    private let minTempLabel = UILabel.setupLabel(text: "MinTemp", fontSize: 14)
    private let maxTempLabel = UILabel.setupLabel(text: "MaxTemp", fontSize: 14)
    private let humidityLabel = UILabel.setupLabel(text: "Humidity", fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(value: List) {
        let jsonDate = Date(timeIntervalSince1970: Double(value.dt))
        self.weekDayLabel.text = getDayForDate(jsonDate)
        let jsonCloudsName = value.weather[0].main.rawValue
        let localString = NSLocalizedString(jsonCloudsName, comment: "")
        let cloudsImage = UIImage(systemName: localString)?.withRenderingMode(.alwaysOriginal)
        self.cloudIconImageView.image = cloudsImage
        self.minTempLabel.text = "мин: \(Int(value.main.tempMin))"
        self.maxTempLabel.text = "макс: \(Int(value.main.tempMax))"
        self.humidityLabel.text = "φ: \(value.main.humidity)"
    }
    
    private func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EE"
        return formatter.string(from: inputDate)
    }
    
    private func setupUI() {
        backgroundColor = .transparentWhite()
        layer.cornerRadius = 18
        cloudIconImageView.contentMode = .scaleAspectFit
        cloudIconImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [weekDayLabel, cloudIconImageView, minTempLabel, maxTempLabel, humidityLabel])
        stackView.distribution = .equalSpacing
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
}
