//
//  ResultTableViewController.swift
//  FavTendency
//
//  Created by 山口瑞歩 on 2020/06/12.
//  Copyright © 2020 山口瑞歩. All rights reserved.
//

import UIKit

class ResultTableViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let mainColor = UIColor(red: 136/255, green: 191/255, blue: 191/255, alpha: 1.0)

    var result: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        let heading = SetupObj.headingLabel(title: "あなたのLuvな傾向は💘", size: 35)
        view.addSubview(heading)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        let resultList = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        resultList.translatesAutoresizingMaskIntoConstraints = false
        resultList.delegate = self
        resultList.dataSource = self
        resultList.backgroundColor = UIColor.white
        resultList.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        view.addSubview(resultList)

        let oneMoreButton = SetupObj.tabButton(title: "もういっかい", bgColor: mainColor, isBorder: false)
        view.addSubview(oneMoreButton)

        oneMoreButton.addTarget(self, action: #selector(tappedOneMoreButton(sender:)), for: .touchUpInside)

        NSLayoutConstraint.activate([
            heading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            heading.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height*0.08),
            resultList.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultList.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 10),
            resultList.bottomAnchor.constraint(equalTo: oneMoreButton.topAnchor, constant: -5),
            resultList.widthAnchor.constraint(equalToConstant: view.frame.width*0.85),
            oneMoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            oneMoreButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            oneMoreButton.widthAnchor.constraint(equalToConstant: view.frame.width*0.8)
        ])

    }

    @objc func tappedOneMoreButton(sender: UIButton) {
        let vc = MainViewController()
        vc.isFromFirstVC = true
        self.show(vc, sender: nil)
    }

    func base64ToImage(imageString: String) -> UIImage? {
        let decodeBase64: NSData? = NSData(base64Encoded: imageString, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        if decodeBase64 != nil {
            let image = UIImage(data: decodeBase64! as Data)
            return image
        }
        return nil
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let vc = TendencyViewController()
        vc.result = result[indexPath.row]
        self.show(vc, sender: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // cell数
        return result.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // section数
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        cell.backgroundColor = mainColor
        cell.layer.cornerRadius = 25.0

        let cellText = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.5, height: 25))
        cellText.text = result[indexPath.row]["tendency"] as? String
        cellText.font = UIFont.systemFont(ofSize: 15)
        cellText.adjustsFontSizeToFitWidth = true
        cellText.translatesAutoresizingMaskIntoConstraints = false

        let cellImage = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.width*0.7, height: cell.contentView.frame.width*0.7))
        let persons = result[indexPath.row]["persons"]! as! [Person]
        cellImage.image = base64ToImage(imageString: persons[0].image)
        cellImage.layer.borderWidth = 6
        cellImage.layer.borderColor = UIColor.white.cgColor
        cellImage.layer.cornerRadius = cellImage.frame.width*0.15
        cellImage.clipsToBounds = true
        cellImage.translatesAutoresizingMaskIntoConstraints = false

        let viewMoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
        viewMoreLabel.text = "view more...👀"
        viewMoreLabel.font = UIFont.systemFont(ofSize: 10)
        viewMoreLabel.translatesAutoresizingMaskIntoConstraints = false

        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }

        cell.contentView.addSubview(cellText)
        cell.contentView.addSubview(cellImage)
        cell.contentView.addSubview(viewMoreLabel)

        NSLayoutConstraint.activate([
            cellText.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            cellText.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            cellImage.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            cellImage.topAnchor.constraint(equalTo: cellText.bottomAnchor, constant: 10),
            cellImage.widthAnchor.constraint(equalToConstant: cell.contentView.frame.width*0.4),
            cellImage.heightAnchor.constraint(equalToConstant: cell.contentView.frame.width*0.4),
            viewMoreLabel.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -30),
            viewMoreLabel.topAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: 5)
        ])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // cell size
        let width = view.frame.width*0.8
        let height = 200 as CGFloat
        return CGSize(width: width, height: height)
    }
}
