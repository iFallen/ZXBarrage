//
//  SLDanmuInfo.swift
//  SwiftDanmuView
//
//  Created by liusilan on 2017/4/17.
//  Copyright © 2017年 silan. All rights reserved.
//

import Foundation
import UIKit

let ZXHDanmTintColor    = UIColor(red: 59 / 255.0, green: 135 / 255.0, blue: 239 / 255.0, alpha: 1.0)
let ZXHDanmBGColor      = UIColor.init(white: 1.0, alpha: 0.5)

class SLDanmuInfo {
    var text: String
    var textColor: UIColor = ZXHDanmTintColor
    var itemViewClass: AnyClass = SLDanmuItemView.self
    
    init(text aText: String) {
        text = aText
    }
    
    init(text aText: String, textColor aTextColor: UIColor) {
        text = aText
        textColor = aTextColor
    }
    
    init(text aText: String, textColor aTextColor: UIColor = ZXHDanmTintColor, itemViewClass aItemViewClass: AnyClass) {
        text = aText
        textColor = aTextColor
        itemViewClass = aItemViewClass
    }
}

class SLBgDanmuInfo: SLDanmuInfo {
    var bgColor: UIColor
    
    init(text aText: String, textColor aTextColor: UIColor = ZXHDanmTintColor, itemViewClass aItemViewClass: AnyClass, bgColor aBgColor: UIColor = ZXHDanmBGColor) {
        bgColor = aBgColor

        super.init(text: aText, textColor: aTextColor, itemViewClass: aItemViewClass)
    }
}
