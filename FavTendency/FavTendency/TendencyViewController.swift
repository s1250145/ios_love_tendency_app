//
//  TendencyViewController.swift
//  FavTendency
//
//  Created by 山口瑞歩 on 2020/07/21.
//  Copyright © 2020 山口瑞歩. All rights reserved.
//

import UIKit

class TendencyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var result: [String: Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let heading = UILabel(frame: CGRect.zero)
        heading.text = result["tendency"] as? String
        heading.translatesAutoresizingMaskIntoConstraints = false
        heading.adjustsFontSizeToFitWidth = true
        heading.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(heading)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        let tendencyList = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        tendencyList.translatesAutoresizingMaskIntoConstraints = false
        tendencyList.delegate = self
        tendencyList.dataSource = self
        tendencyList.backgroundColor = .white
        tendencyList.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        view.addSubview(tendencyList)

        let backButton = UIButton(frame: CGRect.zero)
        backButton.setTitle("もどる", for: .normal)
        backButton.setTitleColor(.blue, for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped(sender:)), for: .touchUpInside)
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            heading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            heading.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height*0.1),
            tendencyList.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tendencyList.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 10),
            tendencyList.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            tendencyList.widthAnchor.constraint(equalToConstant: view.frame.width*0.9),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30)
        ])
    }

    @objc func backButtonTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // cell数
        return (result["persons"]! as! [Person]).count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // section数
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        cell.backgroundColor = UIColor.luvColor.mainColor
        cell.layer.cornerRadius = 25.0

        let cellImage = UIImageView(frame: CGRect.zero)
        let persons = result["persons"]! as! [Person]
        cellImage.image = persons[indexPath.row].image.b64ToImage
        cellImage.layer.borderWidth = 6
        cellImage.layer.borderColor = UIColor.white.cgColor
        cellImage.layer.cornerRadius = 25
        cellImage.clipsToBounds = true
        cellImage.translatesAutoresizingMaskIntoConstraints = false

        let cellName = UILabel(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.width*0.5, height: 25))
        cellName.text = persons[indexPath.row].name
        cellName.font = UIFont.systemFont(ofSize: 25)
        cellName.adjustsFontSizeToFitWidth = true
        cellName.translatesAutoresizingMaskIntoConstraints = false

        let cellGroup = UILabel(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.width*0.5, height: 15))
        cellGroup.text = persons[indexPath.row].group
        cellGroup.font = UIFont.systemFont(ofSize: 15)
        cellGroup.adjustsFontSizeToFitWidth = true
        cellGroup.translatesAutoresizingMaskIntoConstraints = false

        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }

        cell.contentView.addSubview(cellImage)
        cell.contentView.addSubview(cellName)
        cell.contentView.addSubview(cellGroup)

        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 17.25),
            cellImage.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 10),
            cellImage.widthAnchor.constraint(equalToConstant: cell.contentView.frame.width*0.5),
            cellImage.heightAnchor.constraint(equalToConstant: cell.contentView.frame.width*0.5),
            cellName.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 75),
            cellName.leftAnchor.constraint(equalTo: cellImage.rightAnchor, constant: 10),
            cellGroup.topAnchor.constraint(equalTo: cellName.bottomAnchor, constant: 10),
            cellGroup.leftAnchor.constraint(equalTo: cellImage.rightAnchor, constant: 10)
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
