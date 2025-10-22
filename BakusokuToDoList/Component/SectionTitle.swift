//
//  SectionTitle.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/22.
//

enum SectionTitle: CaseIterable {
    case STAR
    case ALL
    case NORMAL
    case CHECKED
    case CURRENTLY_DETLETED
    
    var titleText: String {
        switch self {
        case .STAR: return "★"
        case .ALL: return "すべて"
        case .NORMAL: return "未達成"
        case .CHECKED: return "チェック済"
        case .CURRENTLY_DETLETED: return "最近削除した項目"
        }
    }
}
