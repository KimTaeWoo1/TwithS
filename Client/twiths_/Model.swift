//
//  Tour.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 5. 24..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import Foundation
import RealmSwift

class Tour: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var creator: User?
    @objc dynamic var timeLimit = 0
    @objc dynamic var image:Data
    @objc dynamic var description = ""
    
    @objc dynamic var mapImage:Data
    
    @objc dynamic var createDate: Date = Date()
    @objc dynamic var updateDate: Date = Date()
    
    @objc dynamic var landmarks = List<UserTourLandMark>()?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
}

class Landmark: Object {
    @objc dynamic var id = 0
    @objc dynamic var tour: Tour?
    @objc dynamic var description = ""
    @objc dynamic var image: Data
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
    
}


class UserTourLandMark: Object {
    @objc dynamic var tour: Tour?
    @objc dynamic var landmark: Landmark?
    @objc dynamic var state = 0
    @objc dynamic var image: Data
    @objc dynamic var comment = ""
    @objc dynamic var successTime: Date
}


class User: Object{
    
    @objc dynamic var tours = List<UserTourRelation>()?
    
}


class UserTourRelation: Object{
    @objc dynamic var tour: Tour?
    @objc dynamic var state = 0
    @objc dynamic var Started: Date?
}


class Review: Object {
    @objc dynamic var id = 0
    @objc dynamic var creator: User?
    @objc dynamic var tour: Tour?
    @objc dynamic var stars = 0
    @objc dynamic var createTime:Date = Date()
    @objc dynamic var updateTime:Date = Date()
    @objc dynamic var image:Data
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

