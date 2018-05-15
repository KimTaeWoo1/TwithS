//
//  Database_Hskim.swift
//  
//
//  Created by ㅇㅇ on 2018. 5. 13..
//
//

import Foundation

// 데이터베이스 테이블은 투어, 랜드마크, 사용자, 사용자-투어, 리뷰가 있음.
/* 사용자-투어 테이블은 사용자와 투어를 연결하는 테이블로,
   사용자와 투어가 데이터베이스의 N:M 관계이기 때문에 만들었음. */

// 투어 테이블
class Tour {
    var Name:String // 투어 이름
    var TourID:Int // 투어의 테마 번호
    var Admin:User // 투어를 만든 사용자
    var Created:Date // 투어를 만든 날짜
    var Updated:Date // 투어 수정 날짜
    var TimeLimit:Int // 투어의 제한시간(분단위)
    var Reviews:[Review] // 리뷰 목록
    var Jjim:[User] // 찜한 사용자 목록
    var Image:[String] // 대표사진
    var description:String // 투어정보
    var MapImage:String // 지도 이미지
    var Score:Double // 별점
    
    
    
    init(NAME:String, LOC:String, THEME:Int, USER:User, DT:DateComponents, TIME:(Hour:Int, Minute:Int, Second:Int), LDMS:[Landmark]) {
        self.Name = NAME
        self.Location = LOC
        self.ThemeNum = THEME
        self.CreatedUser = USER
        self.CreatedDT = DateComponents
        self.TimeLimit = TIME
        self.Landmarks = LDMS
        self.Review = []
        self.Jjim = []
    }
}

// 맛집, 관광, 액티비티 ... var Tag:[Theme] = [맛집, 관광]
// enum Theme {
//}

// 랜드마크 테이블
class Landmark {
    var Name:String // 랜드마크 이름
    var Tour:Tour // 투어이름
    var Location:String // 랜드마크의 위치
    var GPSAddress: // 위치정보
    //var LandmarkType:Int // 랜드마크의 종류
    var description:String // 랜드마크 상세 정보
    var Image:[String] // 랜드마크 이미지
    
    init(NAME:String, LOC:String, WD:Double, KD:Double, TYPE:Int) {
        self.Name = NAME
        self.Location = LOC
        self.Wido = WD
        self.Kyungdo = KD
        self.LandmarkType = TYPE
    }
}

// 사용자 테이블
class User {
    var UserID:String // 사용자 아이디
    var UserPWD:String // 비밀번호
    var Nickname:String // 앱에서 사용되는 별명
    var JjimTours:[Tour]
    var ProceedingTours:[UserTour] // 투어, 시간
    
    init(ID:String, PWD:String, NICK:String) {
        self.UserID = ID
        self.UserPWD = PWD
        self.Nickname = NICK
        self.CreatedTours = []
        self.JjimTours = []
    }
}

/* 사용자-투어 테이블. 사용자와 투어는 데이터베이스에서 N:M 관계이기 때문에
   개별 테이블로 만들어야 함. */
class UserTour { // 사용자가 특정 투어를 진행하는 상황 표시
    var User:User // 사용자
    var Tour:Tour // 투어
    var State:Int // 상태를 나타내는 값(성공, 실패, 투어 중 등)
    var Stared:Date
    
    init(USER:User, TOUR:Tour, STATE:Int) {
        self.User = USER
        self.Tour = TOUR
        self.State = STATE
    }
}

class UserTourLandMark {
    var userTour:UserTour // 진행중인 투어
    var Landmark:Landmark
    var State:Int
    var Image:String
    var Comment:String
    var SuccessTime:Date
}

// 리뷰 테이블
class Review {
    var ReviewID:Int
    var WriteUser:User // 리뷰를 작성한 사용자
    var Stars:Int // 별점
    var Content:String // 리뷰의 내용
    var ReviewImage:[String]
    var Created:Date
    var Updated:Date
    
    init(TOUR:Tour, USER:User, STAR:Int, CONTENT:String) {
        self.OnTour = TOUR
        self.WriteUser = USER
        self.Stars = STAR
        self.Content = CONTENT
    }
}

// 더미 데이터
/* 1) 랜드마크, 사용자, 투어, 사용자-투어, 리뷰의 각 테이블에 들어갈 항목(튜플)
   2) 각 테이블에 들어갈 항목(튜플)들을 정리한 각각의 배열
   3) 각 투어를 찜한 사용자, 투어에 있는 리뷰, 사용자가 만든 투어, 사용자가 찜한 투어를
      빈 배열로 초기화되어 있는 속성에 추가함. */




func dummydatas() { // 더미 데이터
    
    /* 1) 랜드마크, 사용자, 투어, 사용자-투어, 리뷰의 각 테이블에 들어갈 항목(튜플) */
    
    // 랜드마크 테이블에 들어갈 항목(튜플)
    var HYU:Landmark = Landmark("Hanyang University", "Haengdang", 37.5, 127.5, 0)
    var ENTER6:Landmark = Landmark("Enter SIX", "Haengdang", 37.5, 127.5, 1)
    var CITYHALL:Landmark = Landmark("Seoul City Hall", "Junggu", 37.5, 127.5, 2)
    var NAMULIVE:Landmark = Landmark("Mapo NamuLIVE", "Mapo", 37.5, 127.5, 1)
    var NAVER:Landmark = Landmark("NAVER Green Factory", "Bundang", 37.3, 127.5, 3)
    var SNU:Landmark = Landmark("Seoul Nat'l University", "Kwanak", 37.4, 127.4, 0)
    var NAMSAN:Landmark = Landmark("NAMSAN Mountain", "Junggu", 37.5, 127.5, 4)
    
    // 사용자 테이블에 들어갈 항목
    var Jimin:User = User("JiminGoddess", "1234", "Jimin")
    var Umanle:User = User("umanle_SRL", "12345", "namuwiki")
    var TION:User = User("Ho Yeong Kim", "123456", "hoyeong")
    
    // 투어 테이블에 들어갈 항목
    var TOUR1:Tour = Tour("TOUR1", "Seoul", 0, Jimin, (2018, 5, 12), (3, 30, 0), [HYU, ENTER6, CITYHALL, SNU])
    var TOUR2:Tour = Tour("NAMU", "Korea", 1, Umanle, (2018, 5, 13), (7, 30, 0), [CITYHALL, NAMULIVE, NAVER, NAMSAN, SNU])
    var TOUR3:Tour = Tour("Daily_routine_of_the_goddess", "Seoul", 1, Jimin, (2018, 5, 14), (5, 0, 0), [HYU, ENTER6, NAMSAN, NAVER])
    
    // 사용자-투어 테이블에 들어갈 항목
    var TION_Jimin1:UserTour = UserTour(TION, Tour1, 0)
    var TION_Jimin2:UserTour = UserTour(TION, Tour3, 0)
    var Umanle_GAZUA:UserTour = UserTour(Jimin, Tour2, 0)
    
    // 리뷰 테이블에 들어갈 항목
    var RV1:Review = Review(TOUR1, TION, 5, "Wow! Jimin is the goddess of traveling!")
    var RV2:Review = Review(TOUR2, Jimin, 1, "Turn off NAMUWIKI.")
    
    /* 2) 각 테이블에 들어갈 항목(튜플)들을 정리한 각각의 배열 */

    // 모든 랜드마크 목록
    var Landmarks_all:[Landmark] = [HYU, ENTER6, CITYHALL, NAMULIVE, NAVER, SNU, NAMSAN]
    
    // 모든 사용자 목록
    var Users_all:[User] = [Jimin, Umanle, TION]
    
    // 투어 목록
    var Tours_all:[Tour] = [TOUR1, TOUR2, TOUR3]
    
    // 사용자-투어 목록
    var UserTour_all:[UserTour] = [TION_Jimin1, TION_Jimin2, Umanle_GAZUA]
    
    // 리뷰 목록
    var Reviews_all:[Review] = [RV1, RV2]
    
    /* 3) 각 투어를 찜한 사용자, 투어에 있는 리뷰, 사용자가 만든 투어, 사용자가 찜한 투어를
    빈 배열로 초기화되어 있는 속성에 추가함. */
    
    // 각 투어를 찜한 사용자
    TOUR1.Jjim = [Umanle, TION]
    TOUR2.Jjim = [TION]
    TOUR3.Jjim = [Umanle]
    
    // 투어에 있는 리뷰
    TOUR1.Reviews = [RV1]
    TOUR2.Reviews = [RV2]
    
    // 사용자가 만든 투어
    Jimin.CreatedTours = [TOUR1, TOUR3]
    Umanle.CreatedTours = [TOUR2]
    
    // 사용자가 찜한 투어
    Umanle.JjimTours = [TOUR1, TOUR3]
    TION.JjimTours = [TOUR1, TOUR2]
}
