//
//  UIColor.swift
//  HyVal
//
//  Created by Egor Syrtcov on 5/6/21.
//

import UIKit

extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func pink() -> UIColor {
        return UIColor(red: 171, green: 127, blue: 176)
    }
    
    static func pink2() -> UIColor {
        return UIColor(red: 163, green: 140, blue: 176)
    }
    
    static func pink3() -> UIColor {
        return UIColor(red: 166, green: 138, blue: 176)
    }
    
    static func pink4() -> UIColor {
        return UIColor(red: 158, green: 143, blue: 176)
    }
    
    static func pink5() -> UIColor {
        return UIColor(red: 153, green: 148, blue: 176)
    }
    
    static func pink6() -> UIColor {
        return UIColor(red: 148, green: 150, blue: 176)
    }
    
    static func blue() -> UIColor {
        return UIColor(red: 145, green: 153, blue: 171)
    }
    
    static func green() -> UIColor {
        return UIColor(red: 127, green: 158, blue: 168)
    }
    
    static func green2() -> UIColor {
        return UIColor(red: 125, green: 168, blue: 171)
    }
    
    static func green3() -> UIColor {
        return UIColor(red: 117, green: 168, blue: 168)
    }
    
    static func green4() -> UIColor {
        return UIColor(red: 115, green: 168, blue: 168)
    }
    
    static func green5() -> UIColor {
        return UIColor(red: 94, green: 168, blue: 158)
    }
    
    static func green6() -> UIColor {
        return UIColor(red: 87, green: 168, blue: 156)
    }
    
    static func green7() -> UIColor {
        return UIColor(red: 105, green: 181, blue: 168)
    }
    
    static func green8() -> UIColor {
        return UIColor(red: 130, green: 179, blue: 161)
    }
    
    static func green9() -> UIColor {
        return UIColor(red: 163, green: 179, blue: 153)
    }
    
    static func yellow() -> UIColor {
        return UIColor(red: 171, green: 181, blue: 150)
    }
    
    static func yellow2() -> UIColor {
        return UIColor(red: 184, green: 181, blue: 140)
    }
    
    static func yellow3() -> UIColor {
        return UIColor(red: 199, green: 184, blue: 133)
    }
}
