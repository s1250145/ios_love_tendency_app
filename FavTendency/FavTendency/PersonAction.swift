//
//  PersonAction.swift
//  FavTendency
//
//  Created by 山口瑞歩 on 2020/08/05.
//  Copyright © 2020 山口瑞歩. All rights reserved.
//

import Foundation

class PersonAction {
    static func getPersons() -> [Person] {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = UserDefaults.standard.data(forKey: "Persons"), let persons = try? jsonDecoder.decode([Person].self, from: data) else {
            return [Person]()
        }
        return persons
    }

    static func selectPerson(_ persons: [Person]) -> Person {
        let randomIndex = Int.random(in: 1..<120)
        return persons[randomIndex].isShown ? selectPerson(persons) : persons[randomIndex]
    }
}
