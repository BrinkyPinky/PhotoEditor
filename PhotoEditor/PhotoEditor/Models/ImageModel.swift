//
//  ImageAssetModel.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 19.06.2023.
//

import PhotosUI

struct imageModel: Identifiable, Equatable {
    let id = UUID()
    let asset: PHAsset
    let image: UIImage
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
