//
//  Tour.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 5. 24..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
// asdfs

// 투어 관계에서 state 값이 0이면 진행안함, 1이면 찜, 2면 진행중, 3이면 진행완료
//

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
    
    init(){}
}

class Landmark_ {
    var id = ""
    var tour = Tour_()
    var name: String = ""
    var detail:String = ""
    var image: String = ""
    
    init(){}
}


class UserTourLandMark_ {
    var id = ""
    var user = ""
    var userTourRelation = UserTourRelation_()
    var state = 0
    var image: String = ""
    var comment = ""
    var successTime: Date = Date()
    
    init(){
    }
}


class UserProfile_{
    var user:Int = 0
    var createTours:[Int] = []
    var displayName:String = ""
    
    init(){}
}


class UserTourRelation_ {
    var id = ""
    var tour = Tour_()
    var user = ""
    
    var state = 0
    var startTime: Date = Date()
    var endTime: Date = Date()
    
    init(){}
}


class Review_ {
    var id = 0
    var creator = ""
    var tour = Tour_()
    var stars = 0
    var createTime:Date = Date()
    var updateTime:Date = Date()
    var image:String = ""
    
    init(){}
}

