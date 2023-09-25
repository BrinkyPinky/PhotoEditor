//
//  EditView.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 19.06.2023.
//

import SwiftUI
import PhotosUI

struct EditView: View {
    @StateObject private var viewModel: EditViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(pickedImage: UIImage, imageEditingIsDone: @escaping (UIImage) -> ()) {
        self._viewModel = StateObject(wrappedValue: EditViewModel(image: pickedImage, imageEditingIsDone: imageEditingIsDone))
    }
    
    var body: some View {
        GeometryReader { geometryProxy in
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                //Изображение
                ZoomableScrollView {
                    Image(uiImage: (viewModel.effectedImage))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay {
                            if viewModel.currentPickedSettingType == .crop && !viewModel.isImageCropped {
                                SelectCropRectView(
                                    cropRect: $viewModel.cropRect,
                                    imageSize: viewModel.effectedImage.size)
                            }
                        }
                }
                .ignoresSafeArea()
                
                //Нижняя панель с настройками изображения
                VStack {
                    Spacer()
                    VStack {
                        if viewModel.currentPickedSettingType == .color {
                            //Настройка цветов изображения
                            ColorSettingPanelView(
                                currentPickedColorSetting: $viewModel.currentPickedColorSetting,
                                sliderValue: $viewModel.sliderValue,
                                colorSettings: $viewModel.colorSettings,
                                onSliderEndInteractAction: {
                                    viewModel.updateValueInColorSettingsArray(withValue: nil)
                                    viewModel.applyImageChanges()
                                },
                                onDragSliderAction: { sliderValue in
                                    viewModel.updateValueInColorSettingsArray(withValue: sliderValue)
                                })
                            .transition(.move(edge: .bottom).combined(with: .scale))
                        } else if viewModel.currentPickedSettingType == .effect {
                            //Настройка эффекта(фильтра) изображения
                            EffectSettingPanelView(
                                currentPickedEffectSetting: viewModel.currentPickedEffectSetting,
                                effectSettings: viewModel.effectSettings,
                                geometryProxy: geometryProxy,
                                changePickedEffect: { number in
                                    viewModel.changePickedEffect(with: number)
                                },
                                effectPicked: {
                                    viewModel.applyImageChanges()
                                })
                        } else if viewModel.currentPickedSettingType == .crop {
                            //Настройка обрезки изображения
                            CropSettingPanelView(
                                isImageCropped: $viewModel.isImageCropped,
                                cropRect: $viewModel.cropRect,
                                applyImageChanges: {
                                    viewModel.applyImageChanges()
                                })
                        }
                        //Общие категории настройки (Цвета, эффекты, кроп)
                        HStack {
                            ForEach(viewModel.settingsCategories) { settingCategoryModel in
                                SettingCategoryView(
                                    imageSystemName: settingCategoryModel.imageSystemName,
                                    isPicked: viewModel.currentPickedSettingType == settingCategoryModel.settingType ? true : false
                                )
                                .padding(.leading)
                                .animation(.easeInOut(duration: 0.2), value: viewModel.currentPickedSettingType)
                                .onTapGesture {
                                    viewModel.currentPickedSettingType = settingCategoryModel.settingType
                                }
                            }
                        }
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .opacity(0.5)
                            .ignoresSafeArea()
                            .frame(width: geometryProxy.size.width)
                            .foregroundColor(.black)
                    }
                }
                .animation(.easeInOut(duration: 0.15), value: viewModel.currentPickedSettingType)
                .animation(.easeInOut(duration: 0.15), value: viewModel.currentPickedColorSetting)
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    viewModel.imageEditingIsDone(viewModel.effectedImage)
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(pickedImage: UIImage(named: "Example")!, imageEditingIsDone: {_ in })
    }
}


struct CropSettingPanelView: View {
    @Binding var isImageCropped: Bool
    @Binding var cropRect: CGRect
    let applyImageChanges: () -> ()
    
    var body: some View {
        HStack {
            Button {
                applyImageChanges()
                isImageCropped = true
            } label: {
                Text("Apply")
                    .foregroundColor(.white)
                    .fontWeight(Font.Weight.black)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.indigo)
                    }
            }
            .disabled(isImageCropped)
            .opacity(isImageCropped ? 0.5 : 1)
            .animation(.easeInOut, value: isImageCropped)
            Button {
                cropRect = .zero
                applyImageChanges()
                isImageCropped = false
            } label: {
                Text("Reset")
                    .foregroundColor(.white)
                    .fontWeight(Font.Weight.black)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.indigo)
                    }
            }
        }
        .padding(16)
    }
}
