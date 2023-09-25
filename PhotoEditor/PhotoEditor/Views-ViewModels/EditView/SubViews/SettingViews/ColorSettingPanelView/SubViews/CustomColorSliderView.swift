//
//  CustomSlider.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 21.06.2023.
//

import SwiftUI

struct CustomColorSliderView: View {
    @Binding var sliderValue: CGFloat
    @State private var sliderTranslation: CGFloat = 0
    @State private var sliderIsDragging = false
    let height: CGFloat
    let color: Color
    let onEndAction: () -> ()
    let onDragSliderAction: (CGFloat) -> ()
    
    var body: some View {
        GeometryReader { geometryProxy in
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(color)
                    .opacity(0.2)
                RoundedRectangle(cornerRadius: 20)
                    .trim(
                        from: 1-((sliderIsDragging ? sliderValue + sliderTranslation : sliderValue)/2+0.5),
                        to: (sliderIsDragging ? sliderValue + sliderTranslation : sliderValue)/2+0.5)
                    .foregroundColor(color)
            }
            .gesture(DragGesture()
                .onChanged({ value in
                    sliderIsDragging = true
                    let calculatedSliderTranslation = value.translation.width / geometryProxy.size.width
                    
                    switch calculatedSliderTranslation + sliderValue {
                    case 0...1:
                        sliderTranslation = calculatedSliderTranslation
                    case -CGFloat.greatestFiniteMagnitude..<0:
                        sliderTranslation = -sliderValue
                    default:
                        sliderTranslation = 1 - sliderValue
                    }
                    
                    onDragSliderAction(sliderValue + sliderTranslation)
                }).onEnded({ _ in
                    sliderValue += sliderTranslation
                    sliderIsDragging = false
                    onEndAction()
                })
            )
        }
        .frame(height: height)
    }
}

struct CustomSlider_Previews: PreviewProvider {
    static var previews: some View {
        CustomColorSliderView(sliderValue: .constant(0.25), height: 30, color: .cyan, onEndAction: {}, onDragSliderAction: { _ in })
    }
}
