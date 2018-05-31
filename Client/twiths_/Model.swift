//
//  Tour.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 5. 24..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
// asdfs

import Foundation

class Tour_ {
    var id = ""
    var name = ""
    var creator: String = ""
    var timeLimit:Int = 0
    var image:String = ""
    var detail = ""
    
    var mapImage:String = ""
    
    var createDate: Date = Date()
    var updateDate: Date = Date()
    
    var landmarks:[Landmark_] = []
    
    init(){}
}

class Landmark_ {
    var id = ""
    var tour: String = ""
    var name: String = ""
    var detail:String = ""
    var image: String = ""
    
    init(){}
}


class UserTourLandMark_ {
    var id = ""
    var tour: String = ""
    var landmark: String = ""
    var state = 0
    var image: String = ""
    var comment = ""
    var successTime: Date = Date()
    
    init(){
    }
}


class UserProfile_{
    var user:Int = 0
    var tours:[Int] = []
    var displayName:String = ""
    
    init(){}
}


class UserTourRelation_ {
    var id = ""
    var tour = ""
    var state = 0
    var startTime: Date?
    var endTime: Date?
    
    init(){}
}


class Review_ {
    var id = 0
    var creator = ""
    var tour = ""
    var stars = 0
    var createTime:Date = Date()
    var updateTime:Date = Date()
    var image:String = ""
    
    init(){}
}

