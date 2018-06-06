//
//  TourCreateHelper.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 5. 28..
//  Copyright © 2018년 Hanyang University Software Studio 1 TwithS Team. All rights reserved.
//

import Foundation
import UIKit

func makeBorderToTextField(_ uiTextField:UITextView) {
    uiTextField.layer.borderWidth = 1.0
    uiTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
    uiTextField.layer.cornerRadius = 5.0;
}

func makeLimitToMinite(day:Int, hour:Int, min:Int) -> Int {
    return day * 1440 + hour * 60 + min
}

// 사진 앨범을 띄우는 함수
//func showImgAlbum (imgPicker:UIImagePickerController, TourCreate:TourCreateVC) {
//    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
//        imgPicker.delegate = TourCreate
//        imgPicker.sourceType = .savedPhotosAlbum
//        imgPicker.allowsEditing = false
//        
//        TourCreate.present(imgPicker, animated: true, completion: nil)
//    }
//}

func getProceedTime(_ userTourRelation:UserTourRelation_) -> String {
    let now = NSDate()
    let DHM: Set<Calendar.Component> = [.day, .hour, .minute]
    let proceedTime = NSCalendar.current.dateComponents(DHM, from: userTourRelation.startTime, to: now as Date);
    let day = "\(proceedTime.day!)"
    let hour = "\(proceedTime.hour!)"
    let minute = "\(proceedTime.minute!)"
    
    let timeLeft = (proceedTime.day!) * 1440 + (proceedTime.hour!) * 60 + (proceedTime.minute!)
    
    let dayLeft = "\(timeLeft / 1440)"
    let hourLeft = "\((timeLeft % 1440) / 60)"
    let minuteLeft = "\(timeLeft % 60)"

    if timeLeft >= 0 {
        if timeLeft >= 1440 {
            return dayLeft + "일 " + hourLeft + "시간 " + minuteLeft + "분"
        } else if timeLeft >= 60 {
            return hourLeft + "시간 " + minuteLeft + "분"
        } else{
            return minuteLeft + "분"
        }
    }
    return ""
}
