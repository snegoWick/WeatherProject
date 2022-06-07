//
//  Extension + UIViewController.swift
//  WeatherProject
//
//  Created by Aleksandr Makarov on 02.06.2022.
//

import UIKit

extension UIViewController {
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
}
