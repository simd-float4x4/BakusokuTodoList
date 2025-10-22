//
//  Color.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/22.
//

import SwiftUI

extension Color {
    static func getRawColor(hex: String) -> Color {
        var red = 0
        var green = 0
        var blue = 0
        if let hexNumber = Int(hex, radix: 16) {
            red = (hexNumber >> 16) & 0xFF
            green = (hexNumber >> 8) & 0xFF
            blue = hexNumber & 0xFF
        }
        return Color(
            red: Double(red) / 255.0,
            green: Double(green) / 255.0,
            blue: Double(blue) / 255.0,
            opacity: 1.0
        )
    }
}
