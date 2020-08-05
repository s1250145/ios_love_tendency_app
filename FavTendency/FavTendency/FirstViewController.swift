//
//  FirstViewController.swift
//  FavTendency
//
//  Created by 山口瑞歩 on 2020/06/25.
//  Copyright © 2020 山口瑞歩. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let mainColor = UIColor(red: 136/255, green: 191/255, blue: 191/255, alpha: 1.0)
    let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
    let sprashView = UIView(frame: CGRect.zero)

    let order = ["印象を選ぶ", "繰り返す", "結果を見る"]
    let caption = ["スライドバーを動かして回答します", "印象回答しないと次の人に進めません", "その傾向にある人をさらにく詳しく見れます"]
    let image = ["Step1", "Step2", "Step3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        // sprash screen animation
        sprashView.backgroundColor = mainColor
        sprashView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "推し隊")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        sprashView.addSubview(logoImageView)
        view.addSubview(sprashView)

        let heading = SetupObj.headingLabel(title: "LuvTendency", size: 40)
        view.addSubview(heading)

        let lead = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.6, height: 15))
        lead.translatesAutoresizingMaskIntoConstraints = false
        lead.text = "あなたの推しの傾向を分析します🧙🏻‍♀️\n傾向を知ってもっと好きになりましょう💯\n推し被りは殺す"
        lead.font = UIFont.systemFont(ofSize: 15)
        lead.numberOfLines = 3
        view.addSubview(lead)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        let operationList = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        operationList.translatesAutoresizingMaskIntoConstraints = false
        operationList.delegate = self
        operationList.dataSource = self
        operationList.backgroundColor = UIColor.white
        operationList.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        view.addSubview(operationList)

        let startButton = SetupObj.tabButton(title: "やってみる", bgColor: mainColor, isBorder: false)
        view.addSubview(startButton)

        startButton.addTarget(self, action: #selector(startButtonTapped(sender:)), for: .touchUpInside)

        NSLayoutConstraint.activate([
            sprashView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sprashView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            sprashView.widthAnchor.constraint(equalTo: view.widthAnchor),
            sprashView.heightAnchor.constraint(equalTo: view.heightAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: sprashView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: sprashView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 250),
            logoImageView.heightAnchor.constraint(equalToConstant: 250),
            heading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            heading.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height*0.08),
            lead.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lead.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 5),
            operationList.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            operationList.topAnchor.constraint(equalTo: lead.bottomAnchor, constant: 10),
            operationList.widthAnchor.constraint(equalToConstant: view.frame.width*0.8),
            operationList.heightAnchor.constraint(equalToConstant: view.frame.height*0.7),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            startButton.widthAnchor.constraint(equalToConstant: view.frame.width*0.7)
        ])

        view.bringSubviewToFront(sprashView)
    }

    @objc func startButtonTapped(sender: UIButton) {
        let vc = MainViewController()
        vc.isFromFirstVC = true
        self.show(vc, sender: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return order.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        cell.backgroundColor = mainColor
        cell.layer.cornerRadius = 25.0

        let cellText = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.5, height: 25))
        cellText.text = order[indexPath.row]
        cellText.font = UIFont.systemFont(ofSize: 25)
        cellText.translatesAutoresizingMaskIntoConstraints = false

        let cellImage = UIImageView(frame: CGRect.zero)
        cellImage.image = UIImage(named: image[indexPath.row])
        cellImage.layer.borderWidth = 5
        cellImage.layer.borderColor = UIColor.white.cgColor
        cellImage.translatesAutoresizingMaskIntoConstraints = false

        let cellCaption = UILabel(frame: CGRect.zero)
        cellCaption.text = caption[indexPath.row]
        cellCaption.font = UIFont.systemFont(ofSize: 10)
        cellCaption.adjustsFontSizeToFitWidth = true
        cellCaption.translatesAutoresizingMaskIntoConstraints = false

        cell.contentView.addSubview(cellText)
        cell.contentView.addSubview(cellImage)
        cell.contentView.addSubview(cellCaption)

        NSLayoutConstraint.activate([
            cellText.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            cellText.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            cellImage.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            cellImage.topAnchor.constraint(equalTo: cellText.bottomAnchor, constant: 5),
            cellImage.heightAnchor.constraint(equalToConstant: cell.contentView.frame.height*0.5),
            cellImage.widthAnchor.constraint(equalToConstant: cell.contentView.frame.width*0.6),
            cellCaption.topAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: 10),
            cellCaption.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 25)
        ])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // cell size
        let width = view.frame.width*0.7
        let height = 180 as CGFloat
        return CGSize(width: width, height: height)
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
}
