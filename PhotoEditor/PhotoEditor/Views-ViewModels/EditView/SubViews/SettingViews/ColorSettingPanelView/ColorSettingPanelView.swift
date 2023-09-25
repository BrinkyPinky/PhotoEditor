//
//  BottomColorSettingPanelView.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 04.07.2023.
//

import SwiftUI

// MARK: Нижняя панель с настройками цвета изображения
struct ColorSettingPanelView: View {
    @Binding var currentPickedColorSetting: ColorSettingType
    @Binding var sliderValue: CGFloat
    @Binding var colorSettings: [ColorSettingModel]
    let onSliderEndInteractAction: () -> ()
    let onDragSliderAction: (CGFloat) -> ()
    
    var body: some View {
        if currentPickedColorSetting != .none {
            CustomColorSliderView(
                sliderValue: $sliderValue,
                height: 20,
                color: .white,
                onEndAction: {
                    onSliderEndInteractAction()
                },
                onDragSliderAction: { sliderValue in
                    onDragSliderAction(sliderValue)
                })
            .padding([.top, .leading, .trailing])
            .transition(.move(edge: .bottom).combined(with: .scale))
        }
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(colorSettings) { settingModel in
                    ColorSettingCircleView(
                        value: settingModel.intensity,
                        settingName: settingModel.type.name,
                        color: currentPickedColorSetting == settingModel.type ? .orange : .white
                    )
                    .onTapGesture {
                        guard currentPickedColorSetting != settingModel.type else {
                            currentPickedColorSetting = .none
                            return
                        }
                        currentPickedColorSetting = settingModel.type
                    }
                }
            }
            .padding()
        }
    }
}
