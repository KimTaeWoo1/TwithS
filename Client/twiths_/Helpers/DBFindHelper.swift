//
//  DBFindHelper.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 25..
//

import Foundation

let Empty_Tour:Tour = Tour(NAME: "", ID: 0, User: User(ID: "", PWD: "", NICK: ""), Created: Date_ymd(year: 1970, month: 1, day: 1), Updated: Date_ymd(year: 1970, month: 1, day: 1), Limit: 0, Image: [], descrip: "", MapImage: "")

// 투어 아이디를 인수로 받아서 투어를 반환하는 함수
func find_tour(tourID:Int) -> Tour {
    for tour in DummyData.Tours {
        if tour.TourID == tourID { return tour }
    }
    return Empty_Tour
}

// 투어를 인수로 받아서 랜드마크의 목록을 반환하는 함수
func Tour_LandmarkList(A:Tour) -> [Landmark] {
    var B:[Landmark] = []
    for landmark in DummyData.Landmarks {
        if landmark.Tour.TourID == A.TourID {
            B.append(landmark)
        }
    }
    return B
}
