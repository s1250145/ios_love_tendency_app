//
//  SplashView.swift
//  FavTendency
//
//  Created by 山口瑞歩 on 2020/06/25.
//  Copyright © 2020 山口瑞歩. All rights reserved.
//

import UIKit

class SprashView: UIView {
    let logoImageView = UIImageView(frame: CGRect.zero)
    let sprashView = UIView(frame: CGRect.zero)

    let mainColor = UIColor(red: 136/255, green: 191/255, blue: 191/255, alpha: 1.0)

    override func draw(_ rect: CGRect) {
        // Drawing code
        sprashView.backgroundColor = mainColor
        sprashView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "推し隊")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        sprashView.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: sprashView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: sprashView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 250),
            logoImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
}
