//
//  Database_test.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 21..
//

import Foundation

// 데이터베이스 테이블은 투어, 랜드마크, 사용자, 사용자-투어, 리뷰가 있음.
/* 사용자-투어 테이블은 사용자와 투어를 연결하는 테이블로,
 사용자와 투어가 데이터베이스의 N:M 관계이기 때문에 만들었음. */

class Date {
    var year:Int
    var month:Int
    var day:Int
    
    init(year:Int, month:Int, day:Int) {
        self.year = year
        self.month = month
        self.day = day
    }
}

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
        self.MapImage = MapImage
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
        self.GPSAddress = GPS
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
        self.userTour = UT
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

/* 1) 랜드마크, 사용자, 투어, 사용자-투어, 리뷰의 각 테이블에 들어갈 항목(튜플) */

// 사용자 테이블에 들어갈 항목
var Jimin:User = User(ID: "JiminGoddess", PWD: "1234", NICK: "Jimin")
var Umanle:User = User(ID: "umanle_SRL", PWD: "12345", NICK: "namuwiki")
var TION:User = User(ID: "Ho Yeong Kim", PWD: "123456", NICK: "hoyeong")
var Marker:User = User(ID: "Seo yeong", PWD: "12345", NICK: "seoyeong")
var XMAN:User = User(ID: "XX", PWD: "345678", NICK: "KimXMan")

// 투어 테이블에 들어갈 항목
var TOUR1:Tour = Tour(NAME: "TOUR1", ID: 1, User: Jimin, Created: Date(year:2018, month:5, day:12), Updated: Date(year: 2018, month:5, day:12), Limit: 210, Image: ["testimg.jpg", "testimg2.jpg"], descrip: "지민 여신의 멋진 투어, 함께해 볼까요?", MapImage: "mapimage.jpg")
var TOUR2:Tour = Tour(NAME: "TOUR2", ID: 2, User: Umanle, Created: Date(year:2018, month:5, day:13), Updated: Date(year: 2018, month:5, day:13), Limit: 450, Image: ["testimg.jpg", "testimg2.jpg"], descrip: "역대급으로 멋진 투어, 가즈아~!", MapImage: "mapimage.jpg")
var TOUR3:Tour = Tour(NAME: "TOUR3", ID: 3, User: Marker, Created: Date(year:2018, month:5, day:13), Updated: Date(year: 2018, month:5, day:15), Limit: 300, Image: ["testimg.jpg", "testimg2.jpg"], descrip: "이렇게 맛있는 맛집들이 있다니, 이거 실화냐?", MapImage: "mapimage.jpg")
var NARUTOUR:Tour = Tour(NAME: "NARU", ID: 4, User: XMAN, Created: Date(year:2018, month:5, day:17), Updated: Date(year: 2018, month:5, day:18), Limit: 300, Image: ["testimg.jpg", "testimg2.jpg"], descrip: "지민 여신의 일상 투어, 함께해 볼까요?", MapImage: "mapimage.jpg")

// 랜드마크 테이블에 들어갈 항목(튜플)
var HYU:Landmark = Landmark(NAME: "Hanyang University", TOUR: TOUR1, LOC: "Haengdang", GPS: (37.5, 127.5), descrip: "80년 전통의 명문 한양대학교", Image: ["testimg.jpg", "testimg2.jpg"])
var ENTER6:Landmark = Landmark(NAME: "Enter SIX", TOUR: TOUR1, LOC: "Haengdang", GPS: (37.5, 127.5), descrip: "한양대생의 성지, 갓갓갓 엔터식스", Image: ["testimg.jpg", "testimg2.jpg"])
var CITYHALL:Landmark = Landmark(NAME: "Seoul City Hall", TOUR: TOUR1, LOC: "Junggu", GPS: (37.5, 127.5), descrip: "시민과 소통하는 서울의 시청", Image: ["testimg.jpg", "testimg2.jpg"])

var NAMULIVE:Landmark = Landmark(NAME: "Mapo NamuLIVE", TOUR: TOUR2, LOC: "Mapo", GPS: (37.5, 127.5), descrip: "마포역 나무라이브~ 가즈아~~!", Image: ["testimg.jpg", "testimg2.jpg"])
var NAVER:Landmark = Landmark(NAME: "NAVER Green Factory", TOUR: TOUR2, LOC: "Bundang", GPS: (37.3, 127.5), descrip: "IT 인재의 진짜 성지, 네이버 본사, 그린팩토리", Image: ["testimg.jpg", "testimg2.jpg"])
var SNU:Landmark = Landmark(NAME: "Seoul Nat'l University", TOUR: TOUR2, LOC: "Kwanak", GPS: (37.4, 127.4), descrip: "대한민국 최고의 명문대, 서울대학교", Image: ["testimg.jpg", "testimg2.jpg"])
var NAMSAN:Landmark = Landmark(NAME: "NAMSAN Mountain", TOUR: TOUR2, LOC: "Junggu", GPS: (37.5, 127.5), descrip: "서울의 중심을 지키는 산, 남산", Image: ["testimg.jpg", "testimg2.jpg"])
var DonggukUniv:Landmark = Landmark(NAME: "Dongguk University", TOUR: TOUR2, LOC: "Junggu", GPS: (37.5, 127.5), descrip: "남산 근처의 준명문대, 동국대학교", Image: ["testimg.jpg", "testimg2.jpg"])
var JangchungGYM:Landmark = Landmark(NAME: "Jangchung GYM", TOUR: TOUR2, LOC: "Junggu", GPS: (37.5, 127.5), descrip: "이번 주말엔 체육관 갈까? 답은 장충체육관!", Image: ["testimg.jpg", "testimg2.jpg"])

var ENTER6_2:Landmark = Landmark(NAME: "Enter SIX", TOUR: TOUR3, LOC: "Haengdang", GPS: (37.5, 127.5), descrip: "한양대생의 성지, 갓갓갓 엔터식스", Image: ["testimg.jpg", "testimg2.jpg"])
var NAMULIVE_2:Landmark = Landmark(NAME: "Mapo NamuLIVE", TOUR: TOUR3, LOC: "Mapo", GPS: (37.5, 127.5), descrip: "마포역 나무라이브~ 가즈아~~!", Image: ["testimg.jpg", "testimg2.jpg"])

var HYU_2:Landmark = Landmark(NAME: "Hanyang University", TOUR: NARUTOUR, LOC: "Haengdang", GPS: (37.5, 127.5), descrip: "80년 전통의 명문 한양대학교", Image: ["testimg.jpg", "testimg2.jpg"])
var NAVER_2:Landmark = Landmark(NAME: "NAVER Green Factory", TOUR: NARUTOUR, LOC: "Bundang", GPS: (37.3, 127.5), descrip: "IT 인재의 진짜 성지, 네이버 본사, 그린팩토리", Image: ["testimg.jpg", "testimg2.jpg"])
var SNU_2:Landmark = Landmark(NAME: "Seoul Nat'l University", TOUR: NARUTOUR, LOC: "Kwanak", GPS: (37.4, 127.4), descrip: "대한민국 최고의 명문대, 서울대학교", Image: ["testimg.jpg", "testimg2.jpg"])
var KHU_2:Landmark = Landmark(NAME: "KyungHee University", TOUR: NARUTOUR, LOC: "Dongdaemun", GPS: (37.5, 127.5), descrip: "누구나 인정하는 명문대 커트라인, 명문대의 문을 닫는 경희대학교", Image: ["testimg.jpg", "testimg2.jpg"])

// 사용자-투어 테이블에 들어갈 항목 (0: 성공, 1: 투어 중, 2: 실패)
var TION_Jimin1:UserTour = UserTour(USER: TION, TOUR: TOUR1, STATE: 2, START: Date(year:2018, month:5, day:29))
var TION_Jimin2:UserTour = UserTour(USER: TION, TOUR: TOUR3, STATE: 0, START: Date(year:2018, month:5, day:26))
var Umanle_GAZUA:UserTour = UserTour(USER: Jimin, TOUR: TOUR2, STATE: 2, START: Date(year:2018, month:5, day:25))
var WANNABE:UserTour = UserTour(USER: Jimin, TOUR: TOUR3, STATE: 0, START: Date(year:2018, month:5, day:29))
var XX:UserTour = UserTour(USER: XMAN, TOUR: TOUR2, STATE: 1, START: Date(year:2018, month:6, day:4))

// 사용자-투어-랜드마크 테이블에 들어갈 항목
var A1:UserTourLandMark = UserTourLandMark(UT: TION_Jimin1, PLACE: HYU, STATE: 0, IMAGE: "testimg.jpg", COMMENT: "ㅇㅇ", SUCTIME: Date(year: 2018, month: 5, day: 29))
var A2:UserTourLandMark = UserTourLandMark(UT: TION_Jimin1, PLACE: ENTER6, STATE: 0, IMAGE: "testimg.jpg", COMMENT: "ㄴㄴ", SUCTIME: Date(year: 2018, month: 5, day: 27))
var A3:UserTourLandMark = UserTourLandMark(UT: TION_Jimin1, PLACE: CITYHALL, STATE: 1, IMAGE: "testimg2.jpg", COMMENT: "진행중임.", SUCTIME: Date(year: 2018, month: 5, day: 29))
var B1:UserTourLandMark = UserTourLandMark(UT: TION_Jimin2, PLACE: ENTER6_2, STATE: 0, IMAGE: "testimg2.jpg", COMMENT: "ㅇㅇ", SUCTIME: Date(year: 2018, month: 5, day: 26))
var B2:UserTourLandMark = UserTourLandMark(UT: TION_Jimin2, PLACE: NAMULIVE_2, STATE: 0, IMAGE: "testimg.jpg", COMMENT: "ㅇㅇ", SUCTIME: Date(year: 2018, month: 5, day: 26))
var C1:UserTourLandMark = UserTourLandMark(UT: Umanle_GAZUA, PLACE: NAMULIVE, STATE: 0, IMAGE: "testimg2.jpg", COMMENT: "ㅇ", SUCTIME: Date(year: 2018, month: 5, day: 25))
var C2:UserTourLandMark = UserTourLandMark(UT: Umanle_GAZUA, PLACE: NAVER, STATE: 0, IMAGE: "testimg.jpg", COMMENT: "코멘트를 입력하세요.", SUCTIME: Date(year: 2018, month: 5, day: 25))
var C3:UserTourLandMark = UserTourLandMark(UT: Umanle_GAZUA, PLACE: SNU, STATE: 0, IMAGE: "testimg2.jpg", COMMENT: "샤샷", SUCTIME: Date(year: 2018, month: 5, day: 25))
var C4:UserTourLandMark = UserTourLandMark(UT: Umanle_GAZUA, PLACE: NAMSAN, STATE: 0, IMAGE: "testimg2.jpg", COMMENT: "클라스 ㅋㅋㅋㅋ", SUCTIME: Date(year: 2018, month: 5, day: 25))
var C5:UserTourLandMark = UserTourLandMark(UT: Umanle_GAZUA, PLACE: DonggukUniv, STATE: 1, IMAGE: "testimg.jpg", COMMENT: "ㄹㅇ", SUCTIME: Date(year: 2018, month: 5, day: 31))
var C6:UserTourLandMark = UserTourLandMark(UT: Umanle_GAZUA, PLACE: JangchungGYM, STATE: 1, IMAGE: "testimg.jpg", COMMENT: "이거 실화냐", SUCTIME: Date(year: 2018, month: 5, day: 31))
var D1:UserTourLandMark = UserTourLandMark(UT: WANNABE, PLACE: ENTER6_2, STATE: 0, IMAGE: "testimg2.jpg", COMMENT: "ㅇㅇ", SUCTIME: Date(year: 2018, month: 5, day: 29))
var D2:UserTourLandMark = UserTourLandMark(UT: WANNABE, PLACE: NAMULIVE_2, STATE: 1, IMAGE: "testimg2.jpg", COMMENT: "fail.", SUCTIME: Date(year: 2018, month: 5, day: 31))
var E1:UserTourLandMark = UserTourLandMark(UT: XX, PLACE: NAMULIVE, STATE: 0, IMAGE: "testimg.jpg", COMMENT: "1234", SUCTIME: Date(year: 2018, month: 5, day: 28))
var E2:UserTourLandMark = UserTourLandMark(UT: XX, PLACE: NAVER, STATE: 0, IMAGE: "testimg2.jpg", COMMENT: "asdf", SUCTIME: Date(year: 2018, month: 5, day: 28))
var E3:UserTourLandMark = UserTourLandMark(UT: XX, PLACE: SNU, STATE: 0, IMAGE: "testimg2.jpg", COMMENT: "코멘트를 입력하세요.", SUCTIME: Date(year: 2018, month: 5, day: 28))
var E4:UserTourLandMark = UserTourLandMark(UT: XX, PLACE: NAMSAN, STATE: 0, IMAGE: "testimg.jpg", COMMENT: "ㅋㅋ", SUCTIME: Date(year: 2018, month: 5, day: 28))
var E5:UserTourLandMark = UserTourLandMark(UT: XX, PLACE: DonggukUniv, STATE: 0, IMAGE: "testimg2.jpg", COMMENT: "ㅇㅇ", SUCTIME: Date(year: 2018, month: 6, day: 4))
var E6:UserTourLandMark = UserTourLandMark(UT: XX, PLACE: JangchungGYM, STATE: 0, IMAGE: "testimg.jpg", COMMENT: "진행중 가즈아", SUCTIME: Date(year: 2018, month: 6, day: 4))

// 리뷰 테이블에 들어갈 항목
var RV1:Review = Review(ID: 1, User: Jimin, Star: 5, Cont: "와 진짜 이거 대박이닼ㅋㅋㅋㅋ", RevImg: ["testimg.jpg", "testimg2.jpg"], Create: Date(year: 2018, month: 5, day: 19), Update: Date(year: 2018, month: 5, day: 21))
var RV2:Review = Review(ID: 2, User: Umanle, Star: 5, Cont: "클라스가 다른...", RevImg: ["testimg.jpg", "testimg2.jpg"], Create: Date(year: 2018, month: 5, day: 19), Update: Date(year: 2018, month: 5, day: 19))
var RV3:Review = Review(ID: 3, User: TION, Star: 3, Cont: "블로그에 소개하면 대박나겠네요.", RevImg: ["testimg.jpg", "testimg2.jpg"], Create: Date(year: 2018, month: 5, day: 19), Update: Date(year: 2018, month: 5, day: 19))
var RV4:Review = Review(ID: 4, User: Marker, Star: 4, Cont: "캬~!", RevImg: ["testimg.jpg", "testimg2.jpg"], Create: Date(year: 2018, month: 5, day: 20), Update: Date(year: 2018, month: 5, day: 20))
var RV5:Review = Review(ID: 5, User: XMAN, Star: 4, Cont: "무난하네요.", RevImg: ["testimg.jpg", "testimg2.jpg"], Create: Date(year: 2018, month: 5, day: 22), Update: Date(year: 2018, month: 5, day: 25))
var RV6:Review = Review(ID: 6, User: Jimin, Star: 5, Cont: "여신을 반하게 한 최고의 투어.", RevImg: ["testimg.jpg", "testimg2.jpg"], Create: Date(year: 2018, month: 5, day: 22), Update: Date(year: 2018, month: 5, day: 22))
var RV7:Review = Review(ID: 7, User: Jimin, Star: 1, Cont: "노답. 더 이상의 자세한 설명은 생략한다.", RevImg: ["testimg.jpg", "testimg2.jpg"], Create: Date(year: 2018, month: 5, day: 31), Update: Date(year: 2018, month: 6, day: 14))

/* 2) 각 테이블에 들어갈 항목(튜플)들을 정리한 각각의 배열 */

// 모든 랜드마크 목록
let Landmarks_all = [HYU, ENTER6, CITYHALL, NAMULIVE, NAVER, SNU, NAMSAN, DonggukUniv, JangchungGYM, ENTER6_2, NAMULIVE_2, HYU_2, NAVER_2, SNU_2, KHU_2]

// 모든 사용자 목록
let Users_all = [Jimin, Umanle, TION, Marker, XMAN]

// 투어 목록
let Tours_all = [TOUR1, TOUR2, TOUR3, NARUTOUR]

// 사용자-투어 목록
let UserTour_all = [TION_Jimin1, TION_Jimin2, Umanle_GAZUA, WANNABE, XX]

// 사용자-투어-랜드마크 목록
let UserTourLandMark_all = [A1, A2, A3, B1, B2, C1, C2, C3, C4, C5, C6, D1, D2, E1, E2, E3, E4, E5, E6]

// 리뷰 목록
let Reviews_all = [RV1, RV2, RV3, RV4, RV5, RV6, RV7]

// 데이터베이스 클래스. 이것을 이용하여 더미 데이터를 테스트함.
class DataBase {
    var Landmarks:[Landmark]
    var Users:[User]
    var Tours:[Tour]
    var UserTours:[UserTour]
    var UserTourLandmark:[UserTourLandMark]
    var Reviews:[Review]
    var Logined:User // 현재 로그인된 사용자
    
    init () {
        /* 3) 각 투어를 찜한 사용자, 투어에 있는 리뷰, 사용자가 만든 투어, 사용자가 찜한 투어를
         빈 배열로 초기화되어 있는 속성에 추가함. */
        
        self.Landmarks = Landmarks_all
        self.Users = Users_all
        self.Tours = Tours_all
        self.UserTours = UserTour_all
        self.UserTourLandmark = UserTourLandMark_all
        self.Reviews = Reviews_all
        
        // 각 투어를 찜한 사용자
        self.Tours[0].Jjim = [Umanle, TION]
        self.Tours[1].Jjim = [Jimin]
        self.Tours[2].Jjim = []
        self.Tours[3].Jjim = [Jimin, Marker, TION, Umanle]
        
        // 투어에 있는 리뷰
        self.Tours[0].Reviews = [RV2, RV3]
        self.Tours[1].Reviews = [RV1, RV4]
        self.Tours[2].Reviews = [RV6, RV7]
        self.Tours[3].Reviews = [RV5]
        
        // 사용자가 진행 중인 투어
        self.Users[0].ProceedingTours = [Umanle_GAZUA, WANNABE]
        self.Users[1].ProceedingTours = []
        self.Users[2].ProceedingTours = [TION_Jimin1, TION_Jimin2]
        self.Users[3].ProceedingTours = []
        self.Users[4].ProceedingTours = [XX]
        
        // 사용자가 찜한 투어
        self.Users[0].JjimTours = [TOUR2, NARUTOUR]
        self.Users[1].JjimTours = [TOUR1, NARUTOUR]
        self.Users[2].JjimTours = [TOUR1, NARUTOUR]
        self.Users[3].JjimTours = [NARUTOUR]
        self.Users[4].JjimTours = []
        
        // 현재 로그인된 사용자를 지정
        Logined = self.Users[2]
    }
}
var DummyData:DataBase = DataBase() // 더미 데이터베이스

