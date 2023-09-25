//
//  ImagePickerViewModel.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 19.06.2023.
//

import Foundation
import Photos

class ImagePickerViewModel: ObservableObject {
    
    //все изображения
    @Published var imageThumbnails = [imageModel]()
    
    //загрузка изображений при появлении экрана
    func loadPhotoThumbnails() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.includeHiddenAssets = false
        
        let fetchResults = PHAsset.fetchAssets(with: .image, options: options)
        
        let imageOptions = PHImageRequestOptions()
        imageOptions.deliveryMode = .highQualityFormat
        imageOptions.isSynchronous = false
        
        let size = CGSize(width: 300, height: 300)
        
        let imageManager = PHImageManager()
        
        fetchResults.enumerateObjects { asset, _, _ in
            imageManager.requestImage(for: asset, targetSize: size, contentMode: .default, options: imageOptions) { [weak self] image, _ in
                guard let self = self, let image = image else { return }
                self.imageThumbnails.append(.init(asset: asset, image: image))
            }
        }
    }
}
