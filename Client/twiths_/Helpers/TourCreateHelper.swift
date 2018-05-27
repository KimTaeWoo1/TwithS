//
//  TourCreateHelper.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 5. 28..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
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
