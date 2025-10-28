//
//  SettingSharedManager.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/28.
//

import Foundation
import SwiftUI

final public class SettingSharedManager {
    public static let shared = SettingSharedManager()
    
    private init() {}
    
    func changeIsShakingEnabledStatus(newValue: Bool) {
        UserDefaults.standard.set(newValue, forKey: "isShakingEnabled")
    }

    func getShakingEnabledStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: "isShakingEnabled")
    }
}
