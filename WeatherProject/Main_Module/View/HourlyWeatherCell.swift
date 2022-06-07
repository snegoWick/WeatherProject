//
//  HourlyWeatherCell.swift
//  WeatherProject
//
//  Created by Aleksandr Makarov on 03.06.2022.
//

import UIKit

final class HourlyWeatherCell: UICollectionViewCell {
    
    static var reuseID = "HourlyWeatherCellReuseID"
    private let timeLabel = UILabel.setupLabel(text: "Label", fontSize: 18)
    private let cloudsImageView = UIImageView()
    private let degreesLabel = UILabel.setupLabel(text: "Degrees", fontSize: 18)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(value: List) {
        let jsonCloudsName = value.weather[0].main.rawValue
        let localString = NSLocalizedString(jsonCloudsName, comment: "")
        let cloudsImage = UIImage(systemName: localString)?.withRenderingMode(.alwaysOriginal)
        self.cloudsImageView.image = cloudsImage
        let jsonDate = Double(value.dt)
        let convertedJSONDate = Date(timeIntervalSince1970: jsonDate)
        let date = Calendar.current.dateComponents([.hour, .day], from: convertedJSONDate)
        self.timeLabel.text = String(describing: date.hour ?? 0)
        self.degreesLabel.text = "\(Int(value.main.temp))°"
    }
    
    private func setupUI() {
        backgroundColor = .clear
        addSubview(timeLabel)
        timeLabel.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        cloudsImageView.contentMode = .scaleAspectFit
        addSubview(cloudsImageView)
        cloudsImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: .init(width: 30, height: 30))
        cloudsImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cloudsImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(degreesLabel)
        degreesLabel.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 6, right: 0))
        degreesLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 3).isActive = true
    }
}
