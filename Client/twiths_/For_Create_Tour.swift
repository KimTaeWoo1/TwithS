//
//  For_Create_Tour.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 21..
//

import Foundation

class New_Tour {
    var Landmarks:[Landmark] = []
    
    /*
    func get_picture_name(LMK:Landmark) -> String {
        for i in 0..<DummyData.Landmarks.count {
            if LMK.Name == DummyData.Landmarks[i].Name {
                if LMK.Image.count > 0 { // 해당 랜드마크의 이미지가 1개 이상이면
                    return LMK.Image[0]
                }
            }
        }
        return "no_image.png" // 해당 파일은 나중에 추가해야 함.
    }
    */
    
    // New_Tour를 초기화
    func initialize () {
        self.Landmarks = []
    }
}

let NewTour:New_Tour = New_Tour()
