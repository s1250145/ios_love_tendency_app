//
//  ResultTableViewController.swift
//  FavTendency
//
//  Created by 山口瑞歩 on 2020/06/12.
//  Copyright © 2020 山口瑞歩. All rights reserved.
//

import UIKit

class ResultTableViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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

        let oneMoreButton = SetupObj.tabButton(title: "もういっかい", bgColor: UIColor.luvColor.mainColor, isBorder: false)
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
        cell.backgroundColor = UIColor.luvColor.mainColor
        cell.layer.cornerRadius = 25.0

        let cellText = SetupObj.cellText(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.5, height: 25), size: 15, text: result[indexPath.row]["tendency"] as! String)
        let persons = result[indexPath.row]["persons"]! as! [Person]
        let cellImage = SetupObj.cellImage(image: persons[0].image.b64ToImage!)

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
            cellImage.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            cellImage.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 10),
            cellImage.widthAnchor.constraint(equalToConstant: cell.contentView.frame.width*0.5),
            cellImage.heightAnchor.constraint(equalToConstant: cell.contentView.frame.width*0.5),
            cellText.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 75),
            cellText.leftAnchor.constraint(equalTo: cellImage.rightAnchor, constant: 10),
            viewMoreLabel.topAnchor.constraint(equalTo: cellText.bottomAnchor, constant: 10),
            viewMoreLabel.leftAnchor.constraint(equalTo: cellImage.rightAnchor, constant: 10)
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
