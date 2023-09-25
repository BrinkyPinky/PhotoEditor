//
//  EditViewModel.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 19.06.2023.
//

import Foundation
import SwiftUI

class EditViewModel: ObservableObject {
    let defaultImage: UIImage
    @Published var effectedImage: UIImage
    
    //Подтвердить редактирование
    let imageEditingIsDone: (UIImage) -> ()
    
    // MARK: CropSettings Variables
    @Published var cropRect = CGRect.zero
    @Published var isImageCropped = false
    
    // MARK: General SettingCategory Constants and Variables
    //Все глобальные настройки (Цвет, эффект, crop)
    let settingsCategories: [SettingCategoryModel] = [
        .init(imageSystemName: "paintpalette", settingType: .color),
        .init(imageSystemName: "photo", settingType: .effect),
        .init(imageSystemName: "arrow.up.left.and.arrow.down.right", settingType: .crop)
    ]
    
    //Текущая выбранная глобальная настройка
    @Published var currentPickedSettingType: SettingType = .effect
    
    // MARK: EffectSetting Constants and Variables
    //Все настройки эффектов
    let effectSettings: [EffectSettingModel] = [
        .init(effectType: .def),
        .init(effectType: .chrome),
        .init(effectType: .fade),
        .init(effectType: .instant),
        .init(effectType: .mono),
        .init(effectType: .noir),
        .init(effectType: .process),
        .init(effectType: .tonal),
        .init(effectType: .transfer)
    ]
    
    //Текущая выбранная настройка эффектов
    @Published var currentPickedEffectSetting: EffectTypes = .def
    
    // MARK: ColorSetting Variables
    //Показан ли слайдер в настройках изображения
    @Published var isSliderPresented = false
    //Значение слайдера
    @Published var sliderValue: CGFloat = 0
    
    //Выбранная настройка цвета изображения
    @Published var currentPickedColorSetting: ColorSettingType = .none {
        didSet {
            updateSliderValueWhenPickedColorSettingChanged()
        }
    }
    //Все возможные настройки изображения
    @Published var colorSettings = [
        ColorSettingModel(type: .exposure, intensity: 0),
        ColorSettingModel(type: .brightness, intensity: 0),
        ColorSettingModel(type: .contrast, intensity: 1),
        ColorSettingModel(type: .saturation, intensity: 1),
        ColorSettingModel(type: .vignette, intensity: 0),
        ColorSettingModel(type: .gamma, intensity: 1),
        ColorSettingModel(type: .hue, intensity: 0)
    ]
    
    init(image: UIImage, imageEditingIsDone: @escaping (UIImage) -> ()) {
        self.effectedImage = image
        self.defaultImage = image
        self.imageEditingIsDone = imageEditingIsDone
    }
    
    // MARK: ColorSetting Methods
    //Обновляет значение конкретной настройки цвета
    func updateValueInColorSettingsArray(withValue value: CGFloat?) {
        guard let index = colorSettings.firstIndex(where: { $0.type == currentPickedColorSetting }) else { return }
        guard value != nil else {
            colorSettings[index].intensity = sliderValue
            return
        }
        colorSettings[index].intensity = value!
    }
    
    //Обновляет значение слайдера когда категория меняется
    private func updateSliderValueWhenPickedColorSettingChanged() {
        guard let index = colorSettings.firstIndex(where: { $0.type == currentPickedColorSetting }) else { return }
        sliderValue = colorSettings[index].intensity
    }
    
    // MARK: EffectSetting Methods
    func changePickedEffect(with elementNumber: Int) {
        if elementNumber < 0 {
            currentPickedEffectSetting = effectSettings[0].effectType
        } else if elementNumber > effectSettings.count - 1 {
            currentPickedEffectSetting = effectSettings[effectSettings.count - 1].effectType
        } else {
            currentPickedEffectSetting = effectSettings[elementNumber].effectType
        }
    }
    
    //применяет изменения изображения
    func applyImageChanges() {
        guard let image = FilterWorker().applyFilter(to: defaultImage, colorSettings: colorSettings, pickedEffect: currentPickedEffectSetting, croppedTo: cropRect) else { return }
        effectedImage = image
    }
}


