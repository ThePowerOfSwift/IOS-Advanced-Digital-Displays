//
//  colors.swift
//  test-push-app
//
//  Created by Keegan Cruickshank on 29/3/17.
//  Copyright © 2017 Keegan Cruickshank. All rights reserved.
//

import Foundation
import UIKit


class Color {
    func colorList() -> [UIColor] {
        return Array(arrayLiteral: red(),offblack(),blue(),yellow(),grey(),green(),purple(),darkgreen(),orange(),darkblue())
    }
    
    func red() -> UIColor {
        return UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
    }
    
    func offblack() -> UIColor {
        return UIColor(red: 34/255, green: 49/255, blue: 63/255, alpha: 1.0)
    }
    
    func blue() -> UIColor {
        return UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    }
    
    func purple() -> UIColor {
        return UIColor(red: 155/255, green: 89/255, blue: 182/255, alpha: 1.0)
    }
    
    func verifiedColor(verified: String) -> UIColor {
        switch verified {
        case "verified":
            return green()
        case "verifying":
            return yellow()
        case "rejected":
            return red()
        default:
            return UIColor.white
        }
    }
    
    func yellow() -> UIColor {
        return UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0)
    }
    
    func orange() -> UIColor {
        return UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1.0)
    }
    
    func darkblue() -> UIColor {
        return UIColor(red: 52/255, green: 73/255, blue: 64/255, alpha: 1.0)
    }
    
    func green() -> UIColor {
        return UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
    }
    
    func darkgreen() -> UIColor {
        return UIColor(red: 26/255, green: 188/255, blue: 156/255, alpha: 1.0)
    }
    
    func grey() -> UIColor {
        return UIColor(red: 127/255, green: 140/255, blue: 141/255, alpha: 1.0)
    }
    
    func generateColorFromArray(number: Int) -> UIColor {
        let lastDigit = number % 10
        return colorList()[lastDigit]
    }
}

