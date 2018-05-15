//
//  TwithTest01.swift
//  
//
//  Created by Hong-Sik Kim on 2018. 5. 10..
//
//

import UIKit

class TwithTest01: UIButton {
    
}

class Tour {
    var TourName:String
    var TourID:Int
    var Landmarks:[Landmark]
    
    init (NAME:String, ID:Int) {
        self.TourName = NAME
        self.TourID = ID
        self.Landmarks = []
    }
}

class Landmark {
    var LandmarkName:String
    var LandmarkID:Int
    var LandmarkImage:String // image file name
    var CreatedUser:User
    
    init (NAME:String, ID:Int, IMAGE:String, USER:User) {
        self.LandmarkName = NAME
        self.LandmarkID = ID
        self.LandmarkImage = IMAGE
        self.CreatedUser = USER
    }
}

class User {
    var UserName:String
    var UserID:Int
    var Score:Int
    
    init (NAME:String, ID:Int) {
        self.UserName = NAME
        self.UserID = ID
        self.Score = 0
    }
}

func initialize () {
    var TwithAdmin:User = User("TwithAdmin", "admin", 1000)
    var User1:User = User("SoonHee", "soonhee", 100)
    
    var HanyangUniv:Landmark = Landmark("Hanyang University", 1, "HYU.png", "TwithAdmin")
    var EnterSix:Landmark = Landmark("Enter6", 2, "Enter6.png", "TwithAdmin")
    var WSLStation:Landmark = Landmark("Wangsimni Station", 3, "Station.png", "TwithAdmin")
    var SeoulCityHall:Landmark = Landmark("City Hall of Seoul", 4, "Hall.png", "TwithAdmin")
    var DDP:Landmark = Landmark("Dongdaemun Design Plaza", 5, "DDP.png", "TwithAdmin")
    
    var Tour1:Tour = Tour("Tour No 1", 1, [HanyangUniv, EnterSix, DDP])
    var Tour2:Tour = Tour("Tour No 2", 2, [WSLStation, EnterSix, DDP, SeoulCityHall])
    var Tour3:Tour = Tour("Tour No 3", 3, [WSLStation, DDP, HanyangUniv])
}
