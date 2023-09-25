//
//  ImagePicker.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 19.06.2023.
//

import SwiftUI

struct ImagePickerView: View {
    @StateObject private var viewModel = ImagePickerViewModel()
    
    //Выбранное изображение
    @Binding var selectedImage: imageModel?
    
    @Environment(\.dismiss) private var dismiss
    
    private let grid = [
        GridItem(.flexible(), spacing: 4, alignment: .center),
        GridItem(.flexible(), spacing: 4, alignment: .center),
        GridItem(.flexible(), spacing: 4, alignment: .center)
    ]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometryProxy in
                ScrollView {
                    LazyVGrid(columns: grid, spacing: 4) {
                        ForEach(viewModel.imageThumbnails) { thumbnailModel in
                            Image(uiImage: thumbnailModel.image)
                                .resizable()
                                .scaledToFill()
                                .aspectRatio(1, contentMode: .fill)
                                .frame(width: geometryProxy.size.width / 3 - 6, height: geometryProxy.size.width / 3 - 6)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay {
                                    selectionIndicator()
                                        .opacity(thumbnailModel == selectedImage ? 1 : 0)
                                }
                                .onTapGesture {
                                    withAnimation(Animation.easeInOut(duration: 0.2)) {
                                        selectedImage = thumbnailModel
                                    }
                                }
                        }
                    }
                    .padding(4)
                }
                .navigationTitle("Select a photo")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem {
                        Button("Done") {
                            dismiss()
                        }
                    }
                })
                .onAppear {
                    selectedImage = nil
                    viewModel.loadPhotoThumbnails()
                }
            }
        }
        .presentationDetents([.large, .medium])
    }
}

// MARK: Индикатор выбранного изображения (галочка справа сверху)
struct selectionIndicator: View {
    var body: some View {
        GeometryReader { geometryProxy in
            HStack {
                Spacer()
                VStack {
                    ZStack {
                        Circle()
                            .foregroundColor(.indigo)
                            .frame(width: geometryProxy.size.width/4)
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .bold()
                    }
                    Spacer()
                }
            }
            .padding(4)
        }
    }
}
