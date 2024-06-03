//
//  ColorUtils.swift
//  DemoNew
//
//  Created by 吴伟 on 6/3/24.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        let a = CGFloat(1.0)

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

struct ColorUtils {
    static func color(from string: String) -> UIColor? {
        switch string.lowercased() {
        case "red":
            return UIColor.red
        case "blue":
            return UIColor.blue
        case "green":
            return UIColor.green
        case "yellow":
            return UIColor.yellow
        case "black":
            return UIColor.black
        case "white":
            return UIColor.white
        case "gray":
            return UIColor.gray
        case "cyan":
            return UIColor.cyan
        case "magenta":
            return UIColor.magenta
        case "orange":
            return UIColor.orange
        case "purple":
            return UIColor.purple
        case "brown":
            return UIColor.brown
        default:
            return nil
        }
    }
}
