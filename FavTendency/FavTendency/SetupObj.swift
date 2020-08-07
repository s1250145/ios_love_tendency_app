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

    static func titleLabel(title: String, size: Int) -> UILabel {
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

    static func imageView(frame: CGRect) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        imageView.layer.borderWidth = 15
        imageView.layer.borderColor = UIColor.luvColor.mainColor.cgColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    static func slider(minEmoji: String, maxEmoji: String) -> UISlider {
        let slider = UISlider(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
        slider.minimumValueImage = minEmoji.emojiToImage
        slider.maximumValueImage = maxEmoji.emojiToImage
        slider.minimumValue = 1.0
        slider.maximumValue = 5.0
        slider.value = 3.0
        slider.minimumTrackTintColor = UIColor.luvColor.mainColor
        slider.maximumTrackTintColor = UIColor.luvColor.subColor
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }

    static func cellText(frame: CGRect, size: CGFloat, text: String) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = text
        label.font = UIFont.systemFont(ofSize: size)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    static func cellImage(image: UIImage) -> UIImageView {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.image = image
        imageView.layer.borderWidth = 6
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
