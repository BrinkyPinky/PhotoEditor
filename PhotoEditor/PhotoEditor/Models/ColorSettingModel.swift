//
//  EditSettingModel.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 21.06.2023.
//

import Foundation

enum ColorSettingType {
    case none, hue, exposure, saturation, brightness, contrast, vignette, gamma
    
    var name: String {
        switch self {
        case .exposure: return "Exposure"
        case .hue: return "Hue"
        case .brightness: return "Brightness"
        case .contrast: return "Contrast"
        case .saturation: return "Saturation"
        case .vignette: return "Vignette"
        case .gamma: return "Gamma"
        case .none: return ""
        }
    }
}

struct ColorSettingModel: Identifiable {
    let id = UUID()
    let type: ColorSettingType
    var intensity: CGFloat
}
