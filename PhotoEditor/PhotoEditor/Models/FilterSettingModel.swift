//
//  FiltersModel.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 02.07.2023.
//

import Foundation

enum EffectTypes {
    case def, chrome, fade, instant, mono, noir, process, tonal, transfer
    
    var name: String {
        switch self {
        case .def: return "Default"
        case .chrome: return "Chrome"
        case .fade: return "Fade"
        case .instant: return "Instant"
        case .mono: return "Mono"
        case .noir: return "Noir"
        case .process: return "Process"
        case .tonal: return "Tonal"
        case .transfer: return "Transfer"
        }
    }
    
    var imageName: String {
        name.lowercased()
    }
}

struct EffectSettingModel: Identifiable {
    let id = UUID()
    let effectType: EffectTypes
}
