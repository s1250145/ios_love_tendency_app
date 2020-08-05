//
//  MainViewController.swift
//  FavTendency
//
//  Created by 山口瑞歩 on 2020/06/09.
//  Copyright © 2020 山口瑞歩. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    let name = SetupObj.titleLabel(title: "", size: 40)
    let group = SetupObj.titleLabel(title: "", size: 20)
    let imageView = UIImageView(frame: CGRect.zero)
    let copy = SetupObj.titleLabel(title: "", size: 25)
    let slider = UISlider(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
    let impression = SetupObj.titleLabel(title: "", size: 20)
    let nextButton = SetupObj.tabButton(title: "Next", bgColor: .white, isBorder: true)
    let finishButton = SetupObj.tabButton(title: "Finish", bgColor: .white, isBorder: true)
    let attention = SetupObj.titleLabel(title: "一定回数やると結果を見ることができます", size: 10)
    let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
    let sprashView = UIView(frame: CGRect.zero)

    var personId = 0
    var totalTendency = 0
    var persons = [Person]()
    var impressions: [[String: Any]] = []

    var isFromFirstVC = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        let mainColor = UIColor(red: 136/255, green: 191/255, blue: 191/255, alpha: 1.0)
        let subColor = UIColor(red: 72/255, green: 102/255, blue: 102/255, alpha: 1.0)
        let enableColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)

        persons = PersonAction.getPersons()

        // first showing
        setData(persons[0])

        view.addSubview(name)
        view.addSubview(group)

        imageView.layer.borderWidth = 15
        imageView.layer.borderColor = mainColor.cgColor
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        view.addSubview(copy)

        slider.minimumValueImage = emojiToImage(text: "🍐", size: 20)
        slider.maximumValueImage = emojiToImage(text: "💚", size: 20)
        slider.minimumValue = 1.0
        slider.maximumValue = 5.0
        slider.value = 3.0
        slider.minimumTrackTintColor = mainColor
        slider.maximumTrackTintColor = subColor
        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)

        slider.addTarget(self, action: #selector(sliderDidChangeValue(_:)), for: .valueChanged)

        let barAttention = SetupObj.titleLabel(title: "バーを動かして印象を回答", size: 10)
        view.addSubview(barAttention)

        view.addSubview(impression)

        view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(nextButtonTapped(sender:)), for: .touchUpInside)

        finishButton.isEnabled = false
        if(!finishButton.isEnabled) {
            finishButton.layer.borderWidth = 0
            finishButton.backgroundColor = enableColor
        }
        finishButton.addTarget(self, action: #selector(finishButtonTapped(sender:)), for: .touchUpInside)
        view.addSubview(finishButton)

        view.addSubview(attention)

        NSLayoutConstraint.activate([
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            name.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height*0.08),
            group.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            group.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width*0.8),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.width*0.8),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: group.bottomAnchor, constant: 15),
            copy.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            copy.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            slider.widthAnchor.constraint(equalToConstant: view.frame.width*0.7),
            slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slider.topAnchor.constraint(equalTo: copy.bottomAnchor, constant: 20),
            barAttention.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            barAttention.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 5),
            impression.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            impression.topAnchor.constraint(equalTo: barAttention.bottomAnchor, constant: 30),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: impression.bottomAnchor, constant: 30),
            nextButton.widthAnchor.constraint(equalToConstant: view.frame.width*0.7),
            finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finishButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 10),
            finishButton.widthAnchor.constraint(equalToConstant: view.frame.width*0.7),
            attention.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            attention.topAnchor.constraint(equalTo: finishButton.bottomAnchor, constant: 5),
            ])

        if(!isFromFirstVC) {
            // sprash screen animation
            sprashView.backgroundColor = mainColor
            sprashView.translatesAutoresizingMaskIntoConstraints = false
            logoImageView.image = UIImage(named: "推し隊")
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            sprashView.addSubview(logoImageView)
            view.addSubview(sprashView)
            NSLayoutConstraint.activate([
                sprashView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                sprashView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                sprashView.widthAnchor.constraint(equalTo: view.widthAnchor),
                sprashView.heightAnchor.constraint(equalTo: view.heightAnchor),
                logoImageView.centerXAnchor.constraint(equalTo: sprashView.centerXAnchor),
                logoImageView.centerYAnchor.constraint(equalTo: sprashView.centerYAnchor),
                logoImageView.widthAnchor.constraint(equalToConstant: 250),
                logoImageView.heightAnchor.constraint(equalToConstant: 250)
                ])
            view.bringSubviewToFront(sprashView)
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 1.0,
                       options: .curveEaseOut,
                       animations: { () in
                        self.logoImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)},
                       completion: { (Bool) in })
        UIView.animate(withDuration: 0.4, delay: 1.3, options: .curveEaseOut, animations: { () in
            self.logoImageView.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
            self.logoImageView.alpha = 0},
                       completion: { (Bool) in
                        self.sprashView.removeFromSuperview() })
    }

    @objc func nextButtonTapped(sender: UIButton) {
        if(impression.text == "") {
            let dialog = UIAlertController(title: "", message: "印象を回答してください", preferredStyle: .alert)
            self.present(dialog, animated: true, completion: { () in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    dialog.dismiss(animated: true, completion: nil)
                })
            })
        } else {
            if(totalTendency == 119) {
                record(id: personId, value: Int(slider.value))
            } else {
                record(id: personId, value: Int(slider.value))
                setData(PersonAction.selectPerson(persons))
            }
        }
    }

    func record(id: Int, value: Int) {
        persons[id-1].isShown = true
        let data = ["id": id, "impression": value]
        impressions.append(data)
        totalTendency += 1
        if(totalTendency > 29) {
            finishButton.isEnabled = true
            finishButton.layer.borderWidth = 1
            finishButton.backgroundColor = UIColor.white
            attention.text = "結果をみることができます💁🏻‍♀️"
        }
        if(totalTendency == 120) {
            nextButton.isEnabled = false
            nextButton.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
            attention.text = "全員終わりました。結果を見てみましょう👩🏻‍🔬"
        }
    }

    func setData(_ person: Person) {
        personId = person.id
        name.text = person.name
        group.text = person.group
        copy.text = person.copy
        imageView.image = base64ToImage(imageString: person.image)
        slider.value = 3.0
        impression.text = ""
    }

    @objc func finishButtonTapped(sender: UIButton) {
        let api = MyAPI()
        api.clustering(data: impressions, responseClosure: { (responce) in
            let vc = ResultTableViewController()
            var list: [[String: Any]] = []
            for tmp in responce {
                let tendency = tmp.keys.first!
                var tendPersons = [Person]()
                tmp[tendency]!.forEach { (v) in
                    let person = self.persons.filter {
                        $0.id == v
                    }
                    tendPersons.append(person[0])
                }
                list.append(["tendency": tendency, "persons": tendPersons])
            }
            vc.result = list
            self.show(vc, sender: nil)
        })
    }

    @objc func sliderDidChangeValue(_ sender: UISlider) {
        let list = ["これは推せない😠", "DD!🤙🏻", "ふつう", "気になる🦆", "本命だょ🥺"]
        impression.text = list[Int(floor(sender.value))-1]
    }

    func emojiToImage(text: String, size: CGFloat) -> UIImage {

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

    func base64ToImage(imageString: String) -> UIImage? {
        let decodeBase64: NSData? = NSData(base64Encoded: imageString, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        if decodeBase64 != nil {
            let image = UIImage(data: decodeBase64! as Data)
            return image
        }
        return nil
    }
}

extension UISlider {
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return true
    }

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bounds.size.height += 10
        return bounds.contains(point)
    }
}
