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
    let imageView = SetupObj.imageView(frame: CGRect.zero)
    let copy = SetupObj.titleLabel(title: "", size: 25)

    let impressionSlider = SetupObj.slider(minEmoji: "🍐", maxEmoji: "💚")
    let attributeSlider = SetupObj.slider(minEmoji: "😍", maxEmoji: "🙂")

    let impression = SetupObj.titleLabel(title: "", size: 20)
    let attribute = SetupObj.titleLabel(title: "", size: 20)

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

        persons = PersonAction.getPersons()
        // first showing
        setData(persons[0])

        view.addSubview(name)
        view.addSubview(group)
        view.addSubview(imageView)
        view.addSubview(copy)

        view.addSubview(impressionSlider)
        impressionSlider.addTarget(self, action: #selector(impressionSliderDidChangeValue(_:)), for: .valueChanged)
        view.addSubview(attributeSlider)
        attributeSlider.addTarget(self, action: #selector(attributeSliderDidChangeValue(_:)), for: .valueChanged)

        let barAttention = SetupObj.titleLabel(title: "バーを動かして印象を回答", size: 10)
        view.addSubview(barAttention)

        view.addSubview(attribute)
        view.addSubview(impression)

        view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(nextButtonTapped(sender:)), for: .touchUpInside)

        finishButton.isEnabled = false
        if(!finishButton.isEnabled) {
            finishButton.layer.borderWidth = 0
            finishButton.backgroundColor = UIColor.luvColor.enableColor
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

            barAttention.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            barAttention.topAnchor.constraint(equalTo: copy.bottomAnchor, constant: 5),

            impressionSlider.widthAnchor.constraint(equalToConstant: view.frame.width*0.7),
            impressionSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            impressionSlider.topAnchor.constraint(equalTo: barAttention.bottomAnchor, constant: 15),
            impression.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            impression.topAnchor.constraint(equalTo: impressionSlider.bottomAnchor, constant: 10),

            attributeSlider.widthAnchor.constraint(equalToConstant: view.frame.width*0.7),
            attributeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            attributeSlider.topAnchor.constraint(equalTo: impression.bottomAnchor, constant: 10),
            attribute.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            attribute.topAnchor.constraint(equalTo: attributeSlider.bottomAnchor, constant: 10),
            
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: attribute.bottomAnchor, constant: 30),
            nextButton.widthAnchor.constraint(equalToConstant: view.frame.width*0.7),
            finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finishButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 10),
            finishButton.widthAnchor.constraint(equalToConstant: view.frame.width*0.7),
            attention.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            attention.topAnchor.constraint(equalTo: finishButton.bottomAnchor, constant: 5),
            ])

        if(!isFromFirstVC) {
            // sprash screen animation
            sprashView.backgroundColor = UIColor.luvColor.mainColor
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
        if(impression.text == "" || attribute.text == "") {
            let dialog = UIAlertController(title: "", message: "印象を回答してください", preferredStyle: .alert)
            self.present(dialog, animated: true, completion: { () in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    dialog.dismiss(animated: true, completion: nil)
                })
            })
        } else {
            if(totalTendency == 119) {
                record(id: personId, impression: Int(impressionSlider.value), attribute: Int(attributeSlider.value))
            } else {
                record(id: personId, impression: Int(impressionSlider.value), attribute: Int(attributeSlider.value))
                setData(PersonAction.selectPerson(persons))
            }
        }
    }

    func record(id: Int, impression: Int, attribute: Int) {
        persons[id-1].isShown = true
        let data = ["id": id, "impression": impression, "attribute": attribute]
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
            nextButton.backgroundColor = UIColor.luvColor.enableColor
            attention.text = "全員終わりました。結果を見てみましょう👩🏻‍🔬"
        }
    }

    func setData(_ person: Person) {
        personId = person.id
        name.text = person.name
        group.text = person.group
        copy.text = person.copy
        imageView.image = person.image.b64ToImage
        impressionSlider.value = 3.0
        impression.text = ""
        attributeSlider.value = 3.0
        attribute.text = ""
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

    @objc func attributeSliderDidChangeValue(_ sender: UISlider) {
        let list = ["かっこいい💎", "かわいい💗", "セクシー⚡️", "おもしろい👏🏻", "ふつう"]
        attribute.text = list[Int(floor(sender.value))-1]
    }

    @objc func impressionSliderDidChangeValue(_ sender: UISlider) {
        let list = ["これは推せない😠", "DD!🤙🏻", "ふつう", "気になる🦆", "本命だょ🥺"]
        impression.text = list[Int(floor(sender.value))-1]
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
