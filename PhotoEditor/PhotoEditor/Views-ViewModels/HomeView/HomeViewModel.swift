//
//  HomeViewModel.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 17.06.2023.
//

import Foundation
import Photos
import SwiftUI

class HomeViewModel: ObservableObject {
    //Все сообщения
    @Published var messages = [MessageModel]()
    
    //Показана ли imagePickerView
    @Published var imagePickerIsPresented = false
    
    //Показан ли экран редактирования изображения
    @Published var editViewIsPresented = false
    
    //Текущее выбранное изображение
    @Published var pickedImage: imageModel?
    
    //Стадия приложения
    @Published var applicationStage: ApplicationStagesEnumeration = .photoAccessDenied
    
    //Изображение отредактированно
    lazy var imageEditingIsDone: (UIImage) -> () = { [unowned self] image in
        editedImage = image
        messages.append(.init(message: "", isApplicationSendMessage: true, messageType: .image, image: image))
        applicationStage = .photoEdited
        messages.append(.init(message: applicationStage.systemMessageText, isApplicationSendMessage: true, messageType: .text, image: nil))
    }
    
    private var editedImage: UIImage? = nil
    
    //Запуск приложения. Проверяет на нужные разрешения и отсылает приветственное сообщение.
    func onAppear() {
        guard applicationStage == .photoAccessDenied || applicationStage == .pickPhoto else { return }
        
        messages.append(MessageModel(
            message: "Hi! This is another useless photo editor.",
            isApplicationSendMessage: true,
            messageType: .text,
            image: nil
        ))
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [unowned self] status in
            DispatchQueue.main.async {
                switch status {
                case .denied, .notDetermined, .restricted:
                    self.messages.append(.init(
                        message: self.applicationStage.systemMessageText,
                        isApplicationSendMessage: true,
                        messageType: .text,
                        image: nil
                    ))
                default:
                    self.applicationStage = .pickPhoto
                    self.messages.append(.init(
                        message: self.applicationStage.systemMessageText,
                        isApplicationSendMessage: true,
                        messageType: .text,
                        image: nil
                    ))
                }
            }
        }
    }
    
    
    //Действия для основной кнопки
    func buttonAction() {
        switch applicationStage {
        case .photoAccessDenied:
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        case .pickPhoto:
            imagePickerIsPresented.toggle()
        case .photoPicked:
            editViewIsPresented.toggle()
        case .photoEdited:
            saveImage()
        }
    }
    
    //Действия для дополнительной кнопки
    func additionalButtonAction() {
        switch applicationStage {
        case .photoPicked:
            imagePickerIsPresented.toggle()
        case .photoEdited:
            applicationStage = .pickPhoto
            self.messages.append(.init(
                message: applicationStage.systemMessageText,
                isApplicationSendMessage: true,
                messageType: .text,
                image: nil))
        default: return
        }
    }
    
    //Загрузка изображения в хорошем качестве и добавление сообщения с изображением в messages.
    func loadHighQualityImage() {
        guard let pickedImage = pickedImage else { return }
        let imageOptions = PHImageRequestOptions()
        imageOptions.deliveryMode = .highQualityFormat
        imageOptions.isSynchronous = true
        
        PHImageManager().requestImage(
            for: pickedImage.asset,
            targetSize: PHImageManagerMaximumSize,
            contentMode: .aspectFit,
            options: imageOptions
        ) { image, _ in
            guard let image = image else { return }
            self.pickedImage = imageModel(asset: pickedImage.asset, image: image)
        }
        
        photoPicked()
    }
    
    //Добавляет сообщение с изображением когда изображение выбрано
    private func photoPicked() {
        messages.append(.init(message: "", isApplicationSendMessage: false, messageType: .image, image: self.pickedImage?.image))
        applicationStage = .photoPicked
        messages.append(.init(
            message: applicationStage.systemMessageText,
            isApplicationSendMessage: true,
            messageType: .text,
            image: nil
        ))
    }
    
    func saveImage() {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { [unowned self] status in
            guard status == .authorized else {
                messages.append(.init(
                    message: "Give the app access to your photos.",
                    isApplicationSendMessage: true,
                    messageType: .text,
                    image: nil))
                return
            }
            
            PHPhotoLibrary.shared().performChanges { [unowned self] in
                
                PHAssetChangeRequest.creationRequestForAsset(from: editedImage!)
            } completionHandler: { [unowned self] success, error in
                if success {
                    messages.append(.init(
                        message: "Image saved successfully",
                        isApplicationSendMessage: true,
                        messageType: .text,
                        image: nil))
                } else if let error = error {
                    messages.append(.init(
                        message: "Error saving image: \(error.localizedDescription)",
                        isApplicationSendMessage: true,
                        messageType: .text,
                        image: nil))
                }
            }
        }
    }
}
