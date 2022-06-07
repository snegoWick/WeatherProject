//
//  Extension + UILable.swift
//  WeatherProject
//
//  Created by Aleksandr Makarov on 02.06.2022.
//

import UIKit

extension UILabel {
    class func setupLabel(text: String?, fontSize: CGFloat, textColor: UIColor = .grafit(), textAlignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.text = text
        label.textAlignment = textAlignment
        label.textColor = textColor
        label.font = .systemFont(ofSize: fontSize)
        label.clipsToBounds = true
        return label
    }
}
