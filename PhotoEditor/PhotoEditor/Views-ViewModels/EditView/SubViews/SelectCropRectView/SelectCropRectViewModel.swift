//
//  SelectCropRectViewModel.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 13.07.2023.
//

import Foundation

class SelectCropRectViewModel: ObservableObject {
    //resizing Rect
    @Published var rectHeight = 0.0
    @Published var rectWidth = 0.0
    @Published var rectHeightTranslation = 0.0
    @Published var rectWidthTranslation = 0.0
    @Published var isRectDragForResizingEnded = false
    @Published var defaultRectSize = CGSize(width: 0, height: 0)
    
    //position Rect
    @Published var rectY = 0.0
    @Published var rectX = 0.0
    @Published var rectYTranslation = 0.0
    @Published var rectXTranslation = 0.0
    @Published var isRectDragForPositionEnded = false
    
    //Изменение размера прямоугольника
    func applyResizeRectTranslation(rectTranslation: inout Double, maxSideSize: CGFloat, rectSideSize: CGFloat, translation: CGFloat, rectCoordinatePosition: CGFloat) {
        if rectSideSize + translation < 50 {
            rectTranslation = 50 - rectSideSize
        } else if rectSideSize + translation + rectCoordinatePosition >= maxSideSize {
            rectTranslation = maxSideSize - rectSideSize - rectCoordinatePosition
        } else {
            rectTranslation = translation
        }
    }
    
    //Изменение позиции прямоугольника
    func applyPositionRectTranslation(rectTranslation: inout Double, rectCoordinatePosition: CGFloat, translation: CGFloat, rectSideSize: CGFloat, maxSideSize: CGFloat) {
        if rectCoordinatePosition + translation < 0 {
            rectTranslation = -rectCoordinatePosition
        } else if (rectCoordinatePosition + translation) + rectSideSize > maxSideSize {
            rectTranslation = maxSideSize - rectSideSize - rectCoordinatePosition
        } else {
            rectTranslation = translation
        }
    }
    
    //Расчет CGRect для дальнейшего обрезания фотографии
    func calculateNewRect(rect: inout CGRect, imageSize: CGSize) {
        let widthDifference = imageSize.width / defaultRectSize.width
        let heightDifference = imageSize.height / defaultRectSize.height
        
        let originalX = rectX * widthDifference
        let originalHeight = rectHeight * heightDifference
        let originalY = ((defaultRectSize.height - rectY) * heightDifference) - originalHeight
        let originalWidth = rectWidth * widthDifference
        
        rect = CGRect(x: originalX, y: originalY, width: originalWidth, height: originalHeight)
    }
}
