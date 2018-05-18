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
    var Image:[String] // 대표사진. 예를 들어 A.img
    var description:String // 투어정보
    var MapImage:String // 지도 이미지
    var Score:Double // 별점
    
    init(NAME:String, ID:Int, User:User, Created:Date, Updated:Date, Limit:Int, Image:[String], descrip:String, MapImage:String) {
        self.Name = NAME
        self.TourID = ID
        self.Admin = User
        self.Created = Created
        self.Updated = Updated
        self.TimeLimit = Limit
        self.Image = Image
        self.description = descrip
        self.Reviews = []
        self.Jjim = []
        self.Image = []
        self.Score = 0
    }
}

// 맛집, 관광, 액티비티 ... var Tag:[Theme] = [맛집, 관광]
// enum Theme {
//}

// 랜드마크 테이블
// 각 랜드마크에 대응되는 투어는 1개이므로 랜드마크를 복제한다고 생각하고 같은 랜드마크를 여러 개 생성할 수 있음.
class Landmark {
    var Name:String // 랜드마크 이름
    var Tour:Tour // 투어이름
    var Location:String // 랜드마크의 위치
    var GPSAddress:(WD:Double, KD:Double) // 위치정보
    //var LandmarkType:Int // 랜드마크의 종류
    var description:String // 랜드마크 상세 정보
    var Image:[String] // 랜드마크 이미지
    
    init(NAME:String, TOUR:Tour, LOC:String, GPS:(WD:Double, KD:Double), descrip:String, Image:[String]) {
        self.Name = NAME
        self.Tour = TOUR
        self.Location = LOC
        self.GPSAddress = (WD, KD)
        self.description = descrip
        self.Image = Image
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
        self.JjimTours = []
        self.ProceedingTours = []
    }
}

/* 사용자-투어 테이블. 사용자와 투어는 데이터베이스에서 N:M 관계이기 때문에
   개별 테이블로 만들어야 함. */
class UserTour { // 사용자가 특정 투어를 진행하는 상황 표시
    var User:User // 사용자
    var Tour:Tour // 투어
    var State:Int // 상태를 나타내는 값(성공, 실패, 투어 중 등)
    var Started:Date // 투어 시작 날짜
    
    init(USER:User, TOUR:Tour, STATE:Int, START:Date) {
        self.User = USER
        self.Tour = TOUR
        self.State = STATE
        self.Started = START
    }
}

// 사용자가 진행하는 각 투어(class UserTour)에 있는 랜드마크에 대한 정보임.
class UserTourLandMark {
    var userTour:UserTour // 진행중인 투어
    var Landmark:Landmark // 랜드마크
    var State:Int // 랜드마크 상태
    var Image:String // 이미지
    var Comment:String // 코멘트
    var SuccessTime:Date // 성공 시각
    
    init(UT:UserTour, PLACE:Landmark, STATE:Int, IMAGE:String, COMMENT:String, SUCTIME:Date) {
        self.UserTour = UT
        self.Landmark = PLACE
        self.State = STATE
        self.Image = IMAGE
        self.Comment = COMMENT
        self.SuccessTime = SUCTIME
    }
}

// 리뷰 테이블
class Review {
    var ReviewID:Int // 리뷰 식별번호
    var WriteUser:User // 리뷰를 작성한 사용자
    var Stars:Int // 별점
    var Content:String // 리뷰의 내용
    var ReviewImage:[String] // 리뷰에 사용되는 이미지
    var Created:Date // 작성 날짜
    var Updated:Date // 수정 날짜
    
    init(ID:Int, User:User, Star:Int, Cont:String, RevImg:[String], Create:Date, Update:Date) {
        self.ReviewID = ID
        self.WriteUser = User
        self.Stars = Star
        self.Content = Cont
        self.ReviewImage = RevImg
        self.Created = Create
        self.Updated = Update
    }
}

// 더미 데이터
/* 1) 랜드마크, 사용자, 투어, 사용자-투어, 리뷰의 각 테이블에 들어갈 항목(튜플)
   2) 각 테이블에 들어갈 항목(튜플)들을 정리한 각각의 배열 */

func dummydatas() { // 더미 데이터
    
    /* 1) 랜드마크, 사용자, 투어, 사용자-투어, 리뷰의 각 테이블에 들어갈 항목(튜플) */
    
    // 사용자 테이블에 들어갈 항목
    var Jimin:User = User("JiminGoddess", "1234", "Jimin")
    var Umanle:User = User("umanle_SRL", "12345", "namuwiki")
    var TION:User = User("Ho Yeong Kim", "123456", "hoyeong")
    var Marker:User = User("Seo yeong", "12345", "seoyeong")
    var XMAN:User = User("XX", "345678", "KimXMan")
    
    // 투어 테이블에 들어갈 항목
    var TOUR1:Tour = Tour("TOUR1", 1, Jimin, Date(year:2018, month:5, day:12), Date(year: 2018, month:5, day:12), 210, ["testimg.jpg", "testimg2.jpg"], "지민 여신의 멋진 투어, 함께해 볼까요?", "mapimage.jpg")
    var TOUR2:Tour = Tour("TOUR2", 2, Umanle, Date(year:2018, month:5, day:13), Date(year: 2018, month:5, day:13), 450, ["testimg.jpg", "testimg2.jpg"], "역대급으로 멋진 투어, 가즈아~!", "mapimage.jpg")
    var TOUR3:Tour = Tour("TOUR3", 3, Marker, Date(year:2018, month:5, day:13), Date(year: 2018, month:5, day:15), 300, ["testimg.jpg", "testimg2.jpg"], "이렇게 맛있는 맛집들이 있다니, 이거 실화냐?", "mapimage.jpg")
    var NARUTOUR:Tour = Tour("NARU", 4, XMAN, Date(year:2018, month:5, day:17), Date(year: 2018, month:5, day:18), 300, ["testimg.jpg", "testimg2.jpg"], "지민 여신의 일상 투어, 함께해 볼까요?", "mapimage.jpg")
    
    // 랜드마크 테이블에 들어갈 항목(튜플)
    var HYU:Landmark = Landmark("Hanyang University", TOUR1, "Haengdang", (37.5, 127.5), "80년 전통의 명문 한양대학교", ["testimg.jpg", "testimg2.jpg"])
    var ENTER6:Landmark = Landmark("Enter SIX", TOUR1, "Haengdang", (37.5, 127.5), "한양대생의 성지, 갓갓갓 엔터식스", ["testimg.jpg", "testimg2.jpg"])
    var CITYHALL:Landmark = Landmark("Seoul City Hall", TOUR1, "Junggu", (37.5, 127.5), "시민과 소통하는 서울의 시청", ["testimg.jpg", "testimg2.jpg"])
    
    var NAMULIVE:Landmark = Landmark("Mapo NamuLIVE", TOUR2, "Mapo", (37.5, 127.5), "마포역 나무라이브~ 가즈아~~!", ["testimg.jpg", "testimg2.jpg"])
    var NAVER:Landmark = Landmark("NAVER Green Factory", TOUR2, "Bundang", (37.3, 127.5), "IT 인재의 진짜 성지, 네이버 본사, 그린팩토리", ["testimg.jpg", "testimg2.jpg"])
    var SNU:Landmark = Landmark("Seoul Nat'l University", TOUR2, "Kwanak", (37.4, 127.4), "대한민국 최고의 명문대, 서울대학교", ["testimg.jpg", "testimg2.jpg"])
    var NAMSAN:Landmark = Landmark("NAMSAN Mountain", TOUR2, "Junggu", (37.5, 127.5), "서울의 중심을 지키는 산, 남산", ["testimg.jpg", "testimg2.jpg"])
    var DonggukUniv:Landmark = Landmark("Dongguk Universitry", TOUR2, "Junggu", (37.5, 127.5), "남산 근처의 준명문대, 동국대학교", ["testimg.jpg", "testimg2.jpg"])
    var JangchungGYM:Landmark = Landmark("Jangchung GYM", TOUR2, "Junggu", (37.5, 127.5), "이번 주말엔 체육관 갈까? 답은 장충체육관!", ["testimg.jpg", "testimg2.jpg"])
    
    var ENTER6_2:Landmark = Landmark("Enter SIX", TOUR3, "Haengdang", (37.5, 127.5), "한양대생의 성지, 갓갓갓 엔터식스", ["testimg.jpg", "testimg2.jpg"])
    var NAMULIVE_2:Landmark = Landmark("Mapo NamuLIVE", TOUR3, "Mapo", (37.5, 127.5), "마포역 나무라이브~ 가즈아~~!", ["testimg.jpg", "testimg2.jpg"])
    
    var HYU_2:Landmark = Landmark("Hanyang University", TOUR4, "Haengdang", (37.5, 127.5), "80년 전통의 명문 한양대학교", ["testimg.jpg", "testimg2.jpg"])
    var NAVER_2:Landmark = Landmark("NAVER Green Factory", TOUR4, "Bundang", (37.3, 127.5), "IT 인재의 진짜 성지, 네이버 본사, 그린팩토리", ["testimg.jpg", "testimg2.jpg"])
    var SNU_2:Landmark = Landmark("Seoul Nat'l University", TOUR4, "Kwanak", (37.4, 127.4), "대한민국 최고의 명문대, 서울대학교", ["testimg.jpg", "testimg2.jpg"])
    var KHU_2:Landmark = Landmark("KyungHee University", TOUR4, "Dongdaemun", (37.5, 127.5), "누구나 인정하는 명문대 커트라인, 명문대의 문을 닫는 경희대학교", ["testimg.jpg", "testimg2.jpg"])
    
    // 사용자-투어 테이블에 들어갈 항목 (0: 성공, 1: 투어 중, 2: 실패)
    var TION_Jimin1:UserTour = UserTour(TION, TOUR1, 2, Date(year:2018, month:5, day:29))
    var TION_Jimin2:UserTour = UserTour(TION, TOUR3, 0, Date(year:2018, month:5, day:26))
    var Umanle_GAZUA:UserTour = UserTour(Jimin, TOUR2, 2, Date(year:2018, month:5, day:25))
    var WANNABE:UserTour = UserTour(Jimin, TOUR3, 0, Date(year:2018, month:5, day:29))
    var XX:UserTour = UserTour(XMAN, TOUR2, 1, Date(year:2018, month:6, day:4))
    
    // 사용자-투어-랜드마크 테이블에 들어갈 항목
    var A1:UserTourLandMark = UserTourLandMark(TION_Jimin1, HYU, 0, "testimg.jpg", "ㅇㅇ", Date(year: 2018, month: 5, day: 29))
    var A2:UserTourLandMark = UserTourLandMark(TION_Jimin1, ENTER6, 0, "testimg.jpg", "ㄴㄴ", Date(year: 2018, month: 5, day: 27))
    var A3:UserTourLandMark = UserTourLandMark(TION_Jimin1, CITYHALL, 1, "testimg2.jpg", "진행중임.", Date(year: 2018, month: 5, day: 29))
    var B1:UserTourLandMark = UserTourLandMark(TION_Jimin2, ENTER6_2, 0, "testimg2.jpg", "ㅇㅇ", Date(year: 2018, month: 5, day: 26))
    var B2:UserTourLandMark = UserTourLandMark(TION_Jimin2, NAMULIVE_2, 0, "testimg.jpg", "ㅇㅇ", Date(year: 2018, month: 5, day: 26))
    var C1:UserTourLandMark = UserTourLandMark(Umanle_GAZUA, NAMULIVE, 0, "testimg2.jpg", "ㅇ", Date(year: 2018, month: 5, day: 25))
    var C2:UserTourLandMark = UserTourLandMark(Umanle_GAZUA, NAVER, 0, "testimg.jpg", "코멘트를 입력하세요.", Date(year: 2018, month: 5, day: 25))
    var C3:UserTourLandMark = UserTourLandMark(Umanle_GAZUA, SNU, 0, "testimg2.jpg", "샤샷", Date(year: 2018, month: 5, day: 25))
    var C4:UserTourLandMark = UserTourLandMark(Umanle_GAZUA, NAMSAN, 0, "testimg2.jpg", "클라스 ㅋㅋㅋㅋ", Date(year: 2018, month: 5, day: 25))
    var C5:UserTourLandMark = UserTourLandMark(Umanle_GAZUA, DonggukUniv, 1, "testimg.jpg", "ㄹㅇ", Date(year: 2018, month: 5, day: 31))
    var C6:UserTourLandMark = UserTourLandMark(Umanle_GAZUA, JangchungGYM, 1, "testimg.jpg", "이거 실화냐", Date(year: 2018, month: 5, day: 31))
    var D1:UserTourLandMark = UserTourLandMark(WANNABE, ENTER6_2, 0, "testimg2.jpg", "ㅇㅇ", Date(year: 2018, month: 5, day: 29))
    var D2:UserTourLandMark = UserTourLandMark(WANNABE, NAMULIVE_2, 1, "testimg2.jpg", "fail.", Date(year: 2018, month: 5, day: 31))
    var E1:UserTourLandMark = UserTourLandMark(XX, NAMULIVE, 0, "testimg.jpg", "1234", Date(year: 2018, month: 5, day: 28))
    var E2:UserTourLandMark = UserTourLandMark(XX, NAVER, 0, "testimg2.jpg", "asdf", Date(year: 2018, month: 5, day: 28))
    var E3:UserTourLandMark = UserTourLandMark(XX, SNU, 0, "testimg2.jpg", "코멘트를 입력하세요.", Date(year: 2018, month: 5, day: 28))
    var E4:UserTourLandMark = UserTourLandMark(XX, NAMSAN, 0, "testimg.jpg", "ㅋㅋ", Date(year: 2018, month: 5, day: 28))
    var E5:UserTourLandMark = UserTourLandMark(XX, DonggukUniv, 0, "testimg2.jpg", "ㅇㅇ", Date(year: 2018, month: 6, day: 4))
    var E6:UserTourLandMark = UserTourLandMark(XX, JangchungGYM, 0, "testimg.jpg", "진행중 가즈아", Date(year: 2018, month: 6, day: 4))

    // 리뷰 테이블에 들어갈 항목
    var RV1:Review = Review(1, Jimin, 5, "와 진짜 이거 대박이닼ㅋㅋㅋㅋ", ["testimg.jpg", "testimg2.jpg"], Date(year: 2018, month: 5, day: 19), Date(year: 2018, month: 5, day: 21))
    var RV2:Review = Review(2, Umanle, 5, "클라스가 다른...", ["testimg.jpg", "testimg2.jpg"], Date(year: 2018, month: 5, day: 19), Date(year: 2018, month: 5, day: 19))
    var RV3:Review = Review(3, TION, 3, "블로그에 소개하면 대박나겠네요.", ["testimg.jpg", "testimg2.jpg"], Date(year: 2018, month: 5, day: 19), Date(year: 2018, month: 5, day: 19))
    var RV4:Review = Review(4, Marker, 4, "캬~!", ["testimg.jpg", "testimg2.jpg"], Date(year: 2018, month: 5, day: 20), Date(year: 2018, month: 5, day: 20))
    var RV5:Review = Review(5, XMAN, 4, "무난하네요.", ["testimg.jpg", "testimg2.jpg"], Date(year: 2018, month: 5, day: 22), Date(year: 2018, month: 5, day: 25))
    var RV6:Review = Review(6, Jimin, 5, "여신을 반하게 한 최고의 투어.", ["testimg.jpg", "testimg2.jpg"], Date(year: 2018, month: 5, day: 22), Date(year: 2018, month: 5, day: 22))
    var RV7:Review = Review(7, Jimin, 1, "노답. 더 이상의 자세한 설명은 생략한다.", ["testimg.jpg", "testimg2.jpg"], Date(year: 2018, month: 5, day: 31), Date(year: 2018, month: 6, day: 14))
    
    /* 2) 각 테이블에 들어갈 항목(튜플)들을 정리한 각각의 배열 */

    // 모든 랜드마크 목록
    var Landmarks_all:[Landmark] = [HYU, ENTER6, CITYHALL, NAMULIVE, NAVER, SNU, NAMSAN, DonggukUniv, JangchungGYM, ENTER6_2, NAMULIVE_2, HYU_2, NAVER_2, SNU_2, KHU_2]
    
    // 모든 사용자 목록
    var Users_all:[User] = [Jimin, Umanle, TION, Marker, XMAN]
    
    // 투어 목록
    var Tours_all:[Tour] = [TOUR1, TOUR2, TOUR3, NARUTOUR]
    
    // 사용자-투어 목록
    var UserTour_all:[UserTour] = [TION_Jimin1, TION_Jimin2, Umanle_GAZUA, WANNABE, XX]
    
    // 사용자-투어-랜드마크 목록
    var UserTourLandMark_all:[UserTourLandMark] = [A1, A2, A3, B1, B2, C1, C2, C3, C4, C5, C6, D1, D2, E1, E2, E3, E4, E5, E6]
    
    // 리뷰 목록
    var Reviews_all:[Review] = [RV1, RV2, RV3, RV4, RV5, RV6, RV7]
    
    /* 3) 각 투어를 찜한 사용자, 투어에 있는 리뷰, 사용자가 만든 투어, 사용자가 찜한 투어를
    빈 배열로 초기화되어 있는 속성에 추가함. */
    
    // 각 투어를 찜한 사용자
    TOUR1.Jjim = [Umanle, TION]
    TOUR2.Jjim = [Jimin]
    TOUR3.Jjim = []
    NARUTOUR.Jjim = [Jimin, Marker, TION, Umanle]
    
    // 투어에 있는 리뷰
    TOUR1.Reviews = [RV2, RV3]
    TOUR2.Reviews = [RV1, RV4]
    TOUR3.Reviews = [RV6, RV7]
    TOUR4.Reviews = [RV5]
    
    // 사용자가 만든 투어
    Jimin.CreatedTours = [TOUR1]
    Umanle.CreatedTours = [TOUR2]
    TION.CreatedTours = []
    Marker.CreatedTours = [TOUR3]
    XMAN.CreatedTours = [NARUTOUR]
    
    // 사용자가 찜한 투어
    Jimin.JjimTours = [TOUR2, NARUTOUR]
    Umanle.JjimTours = [TOUR1, NARUTOUR]
    TION.JjimTours = [TOUR1, NARUTOUR]
    Marker.JjimTours = [NARUTOUR]
}
