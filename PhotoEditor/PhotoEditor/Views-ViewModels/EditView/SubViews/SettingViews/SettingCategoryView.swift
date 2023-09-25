//
//  SettingCategory.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 01.07.2023.
//

import SwiftUI

struct SettingCategoryView: View {
    let imageSystemName: String
    let isPicked: Bool
    
    var body: some View {
        VStack {
            Image(systemName: imageSystemName)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 30)
                .foregroundColor(.white)
                .padding(.bottom, 4)
            Circle()
                .frame(width: 10)
                .foregroundColor(.orange)
                .opacity(isPicked ? 1 : 0)
        }
    }
}

struct SettingCategory_Previews: PreviewProvider {
    static var previews: some View {
        SettingCategoryView(imageSystemName: "photo", isPicked: true)
    }
}
