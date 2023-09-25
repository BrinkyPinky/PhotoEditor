//
//  EffectSettingPanelView.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 13.07.2023.
//

import SwiftUI

struct EffectSettingPanelView: View {
    var currentPickedEffectSetting: EffectTypes
    let effectSettings: [EffectSettingModel]
    let geometryProxy: GeometryProxy
    let changePickedEffect: (Int) -> ()
    let effectPicked: () -> ()
    
    var body: some View {
        VStack {
            ZStack {
                FilterSliderView(effectPicked: {
                    effectPicked()
                }, currentPickedEffectChanged: { number in
                    changePickedEffect(number)
                }, content: {
                    HStack {
                        ForEach(effectSettings) { effectSettingModel in
                            Image(effectSettingModel.effectType.imageName)
                                .resizable()
                                .aspectRatio(1.5, contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                    .offset(x: geometryProxy.size.width/2 - 64, y: 10)
                    .padding(.trailing, geometryProxy.size.width/2 + 64)
                    .padding()
                })
                .frame(height: geometryProxy.size.height/6)
                
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 5)
                    .foregroundColor(.white)
                    .frame(width: 100, height: 100)
            }
            Text(currentPickedEffectSetting.name)
                .foregroundColor(.white)
                .font(.system(size: 24, weight: Font.Weight.black, design: Font.Design.rounded))
                .animation(.easeInOut(duration: 0.15), value: currentPickedEffectSetting)
        }
        .transition(.move(edge: .bottom).combined(with: .scale))
    }
}
