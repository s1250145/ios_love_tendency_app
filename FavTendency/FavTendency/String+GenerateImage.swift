//
//  String+GenerateImage.swift
//  FavTendency
//
//  Created by 山口瑞歩 on 2020/08/05.
//  Copyright © 2020 山口瑞歩. All rights reserved.
//

import Foundation
import UIKit

extension String {
    private func base64ToImage(imageString: String) -> UIImage? {
        let decodeBase64: NSData? = NSData(base64Encoded: imageString, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        if decodeBase64 != nil {
            let image = UIImage(data: decodeBase64! as Data)
            return image
        }
        return nil
    }

    private func emojiToImage(text: String, size: CGFloat) -> UIImage {

        let outputImageSize = CGSize.init(width: size, height: size)
        let baseSize = text.boundingRect(with: CGSize(width: 2048, height: 2048),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [.font: UIFont.systemFont(ofSize: size / 2)], context: nil).size
        let fontSize = outputImageSize.width / max(baseSize.width, baseSize.height) * (outputImageSize.width / 2)
        let font = UIFont.systemFont(ofSize: fontSize)
        let textSize = text.boundingRect(with: CGSize(width: outputImageSize.width, height: outputImageSize.height),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [.font: font], context: nil).size

        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        style.lineBreakMode = NSLineBreakMode.byClipping

        let attr : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : font,
                                                     NSAttributedString.Key.paragraphStyle: style,
                                                     NSAttributedString.Key.backgroundColor: UIColor.clear ]

        UIGraphicsBeginImageContextWithOptions(outputImageSize, false, 0)
        text.draw(in: CGRect(x: (size - textSize.width) / 2,
                             y: (size - textSize.height) / 2,
                             width: textSize.width,
                             height: textSize.height),
                  withAttributes: attr)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    var b64ToImage: UIImage? {
        return base64ToImage(imageString: self)
    }

    var emojiToImage: UIImage? {
        return emojiToImage(text: self, size: 20)
    }
}
