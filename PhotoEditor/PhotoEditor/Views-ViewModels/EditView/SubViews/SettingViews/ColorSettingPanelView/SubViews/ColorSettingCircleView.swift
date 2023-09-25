//
//  BottomSettingCircle.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 21.06.2023.
//

import SwiftUI

struct ColorSettingCircleView: View {
    var value: CGFloat
    let settingName: String
    let color: Color
    
    let circleSize: CGFloat = 50
    
    var body: some View {
        GeometryReader { geometryProxy in
            VStack {
                ZStack {
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: 1, dash: [0.5, 0.6], dashPhase: 0))
                        .trim(from: 0, to: value)
                        .rotationEffect(Angle(degrees: 180))
                        .frame(width: circleSize, height: circleSize)
                        .foregroundColor(color)
                        .overlay {
                            Text("\(Int(value*100))")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(color)
                        }
                    Circle()
                        .frame(width: circleSize, height: circleSize)
                        .foregroundColor(color)
                        .opacity(0.2)
                }
                Text(settingName)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
        }
        .frame(width: 80, height: 70)
    }
}

struct BottomSettingCircle_Previews: PreviewProvider {
    static var previews: some View {
        ColorSettingCircleView(value: 0, settingName: "Weqw", color: .white)
    }
}
