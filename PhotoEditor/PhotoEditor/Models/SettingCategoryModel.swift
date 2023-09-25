//
//  SettingCategoryModel.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 01.07.2023.
//

import Foundation

enum SettingType {
    case color, effect, crop
}

struct SettingCategoryModel: Identifiable {
    let id = UUID()
    let imageSystemName: String
    let settingType: SettingType
}
