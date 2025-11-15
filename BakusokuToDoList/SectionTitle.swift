//
//  SectionTitle.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/22.
//

import Foundation

enum SectionTitle: CaseIterable {
    case STAR
    case ALL
    case NORMAL
    case CHECKED
    case CURRENTLY_DETLETED
    case SETTING
    
    var titleText: String {
        switch self {
        case .STAR: return "★"
        case .ALL: return String(localized: "すべて", comment: "All section title")
        case .NORMAL: return String(localized: "未達成", comment: "Uncompleted section title")
        case .CHECKED: return String(localized: "チェック済", comment: "Checked section title")
        case .CURRENTLY_DETLETED: return String(localized: "最近削除した項目", comment: "Recently deleted items section title")
        case .SETTING: return String(localized: "設定", comment: "Settings section title")
        }
    }
}
