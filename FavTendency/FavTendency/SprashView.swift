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

    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.backgroundColor = UIColor.luvColor.mainColor.cgColor
        logoImageView.image = UIImage(named: "推し隊")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 250),
            logoImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
}

extension UIView {
    func addConstraints(for childView: UIView, insets: UIEdgeInsets = .zero) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: childView.topAnchor, constant: insets.top).isActive = true
        bottomAnchor.constraint(equalTo: childView.bottomAnchor, constant: insets.bottom).isActive = true
        leadingAnchor.constraint(equalTo: childView.leadingAnchor, constant: insets.left).isActive = true
        trailingAnchor.constraint(equalTo: childView.trailingAnchor, constant: insets.right).isActive = true
    }
}
