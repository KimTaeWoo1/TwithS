//
//  StringExtension.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 6. 24..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
