//
//  SelectCropRectView.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 13.07.2023.
//

import SwiftUI

struct SelectCropRectView: View {
    @StateObject private var viewModel = SelectCropRectViewModel()
    
    @Binding var cropRect: CGRect
    var imageSize: CGSize
    
    var body: some View {
        GeometryReader { geometryProxy in
            Rectangle()
                .opacity(0.1)
                .border(.white, width: 3)
                .opacity(0.6)
                .overlay {
                    ZStack {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                            .fontWeight(Font.Weight.medium)
                            .padding(8)
                            .background {
                                Circle()
                                    .foregroundColor(.white)
                            }
                        //Resizing Drag Gesture
                            .gesture(DragGesture(coordinateSpace: .global).onChanged({ value in
                                viewModel.isRectDragForResizingEnded = false
                                
                                let widthTranslation = value.translation.width
                                let heightTranslation = value.translation.height
                                let maxWidth = geometryProxy.size.width
                                let maxHeight = geometryProxy.size.height
                                
                                viewModel.applyResizeRectTranslation(
                                    rectTranslation: &viewModel.rectWidthTranslation,
                                    maxSideSize: maxWidth,
                                    rectSideSize: viewModel.rectWidth,
                                    translation: widthTranslation,
                                    rectCoordinatePosition: viewModel.rectX)
                                viewModel.applyResizeRectTranslation(
                                    rectTranslation: &viewModel.rectHeightTranslation,
                                    maxSideSize: maxHeight,
                                    rectSideSize: viewModel.rectHeight,
                                    translation: heightTranslation,
                                    rectCoordinatePosition: viewModel.rectY)
                            }).onEnded({ _ in
                                viewModel.isRectDragForResizingEnded = true
                                viewModel.rectWidth += viewModel.rectWidthTranslation
                                viewModel.rectHeight += viewModel.rectHeightTranslation
                                viewModel.calculateNewRect(rect: &cropRect, imageSize: imageSize)
                            }))
                    }
                }
            //resizing
                .frame(
                    width: viewModel.isRectDragForResizingEnded ?
                    viewModel.rectWidth : viewModel.rectWidth + viewModel.rectWidthTranslation,
                    height: viewModel.isRectDragForResizingEnded ?
                    viewModel.rectHeight : viewModel.rectHeight + viewModel.rectHeightTranslation)
            //position
                .offset(
                    x: viewModel.isRectDragForPositionEnded ?
                    viewModel.rectX : viewModel.rectX + viewModel.rectXTranslation,
                    y: viewModel.isRectDragForPositionEnded ?
                    viewModel.rectY : viewModel.rectY + viewModel.rectYTranslation)
                .onAppear {
                    viewModel.rectWidth = geometryProxy.size.width
                    viewModel.rectHeight = geometryProxy.size.height
                    viewModel.defaultRectSize = geometryProxy.size
                }
            //position Drag Gesture
                .gesture(DragGesture().onChanged({ value in
                    viewModel.isRectDragForPositionEnded = false
                    
                    let widthTranslation = value.translation.width
                    let heightTranslation = value.translation.height
                    let maxWidth = geometryProxy.size.width
                    let maxHeight = geometryProxy.size.height
                    
                    viewModel.applyPositionRectTranslation(
                        rectTranslation: &viewModel.rectXTranslation,
                        rectCoordinatePosition: viewModel.rectX,
                        translation: widthTranslation,
                        rectSideSize: viewModel.rectWidth,
                        maxSideSize: maxWidth)
                    viewModel.applyPositionRectTranslation(
                        rectTranslation: &viewModel.rectYTranslation,
                        rectCoordinatePosition: viewModel.rectY,
                        translation: heightTranslation,
                        rectSideSize: viewModel.rectHeight,
                        maxSideSize: maxHeight)
                }).onEnded({ _ in
                    viewModel.isRectDragForPositionEnded = true
                    viewModel.rectX += viewModel.rectXTranslation
                    viewModel.rectY += viewModel.rectYTranslation
                    viewModel.calculateNewRect(rect: &cropRect, imageSize: imageSize)
                }))
        }
    }
}
