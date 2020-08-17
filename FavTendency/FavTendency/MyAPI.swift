//
//  TestMyAPI.swift
//  FavTendency
//
//  Created by 山口瑞歩 on 2020/06/15.
//  Copyright © 2020 山口瑞歩. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class MyAPI {
    var headers: [String: String] = ["Content-Type": "application/json"]

    func downloadImageDataSet(responseClosure: @escaping([Person]) -> ()) {
        var persons = [Person]()
        Alamofire.request("https://sunny-studio-254101.df.r.appspot.com/", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            guard let object = response.result.value else { return }
            let json = JSON(object)
            json.forEach { (i, json) in
                let person = Person(id: json["id"].intValue, name: json["name"].stringValue, group: json["group"].stringValue, copy: json["copy"].stringValue, image: json["image"].stringValue, isShown: json["isShown"].boolValue)
                persons.append(person)
            }
            responseClosure(persons)
        }
    }

    func clusteringResultGet(data: Any, responseClosure: @escaping([[[String: Any]]]) -> ()) {
        let parameters = ["data": data]
        var result: [[[String: Any]]] = []
        Alamofire.request("http://127.0.0.1:8018/cluster", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            guard let object = response.result.value else { return }
            let json = JSON(object)
            json.forEach { (_, json) in
                var tmp: [[String: Any]] = []
                json.forEach { (_, json) in
                    let data: [String: Any] = ["id": json["id"].intValue, "tendency": json["tendency"].stringValue]
                    tmp.append(data)
                }
                result.append(tmp)
            }
            responseClosure(result)
        }
    }
// sunny-studio-254101.df.r.appspot.com/clustering
    func clustering(data: Any, responseClosure: @escaping([[String: [Int]]]) -> ()) {
        let parameters = ["data": data]
        Alamofire.request("http://127.0.0.1:8018/clustering", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            guard let obj = response.result.value else { return }
            let json = JSON(obj)
            var arr: [[String: [Int]]] = []
            json.forEach { (_, d) in
                let label = d.dictionaryValue.keys.first!
                var list: [Int] = []
                d[label].forEach { (_, v) in
                    list.append(v.intValue)
                }
                arr.append([label: list])
            }
            responseClosure(arr)
        }
    }
}
