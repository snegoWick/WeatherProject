//
//  SearchCityCell.swift
//  WeatherProject
//
//  Created by Aleksandr Makarov on 06.06.2022.
//

import UIKit

final class SearchCityCell: UITableViewCell {
    
    static var reuseID = "searchCityCellReuseID"
    private let label = UILabel.setupLabel(text: "label", fontSize: 18, textColor: .white)
    private let cellBackgroundView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelText(_ text: String) {
        self.label.text = text
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(cellBackgroundView)
        cellBackgroundView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 5, left: 16, bottom: 5, right: 16))
        cellBackgroundView.backgroundColor = .gray
        cellBackgroundView.layer.cornerRadius = 8
        
        addSubview(label)
        label.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 14, left: 32, bottom: 14, right: 32))
        label.numberOfLines = 5
    }
}
