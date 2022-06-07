//
//  Extension + UIColor.swift
//  WeatherProject
//
//  Created by Aleksandr Makarov on 02.06.2022.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha/1)
    }
    
    class func grafit() -> UIColor {
        return .rgb(red: 41, green: 41, blue: 41, alpha: 1)
    }
    
    class func mateGreen() -> UIColor {
        return .rgb(red: 190, green: 223, blue: 189, alpha: 0.8)
    }
    
    class func transparentWhite() -> UIColor {
        return .rgb(red: 130, green: 130, blue: 140, alpha: 0.2)
    }
}
