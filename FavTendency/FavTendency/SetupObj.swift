//
//  SetupObj.swift
//  FavTendency
//
//  Created by 山口瑞歩 on 2020/08/04.
//  Copyright © 2020 山口瑞歩. All rights reserved.
//

import Foundation
import UIKit

class SetupObj {
    static func headingLabel(title: String, size: Int) -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.text = title
        label.font = UIFont.systemFont(ofSize: CGFloat(size))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    static func tabButton(title: String, bgColor: UIColor, isBorder: Bool) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 45))
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = bgColor
        button.layer.borderWidth = isBorder ? 1 : 0
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 2.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
