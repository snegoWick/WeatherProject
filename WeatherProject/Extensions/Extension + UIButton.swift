//
//  Extension + UIButton.swift
//  WeatherProject
//
//  Created by Aleksandr Makarov on 02.06.2022.
//

import UIKit

extension UIButton {
    class func setupButton(title: String, backgroundColor: UIColor = .transparentWhite(), textColor: UIColor = .grafit(), font: UIFont = .systemFont(ofSize: 16)) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(textColor, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 8
        return button
    }
}
