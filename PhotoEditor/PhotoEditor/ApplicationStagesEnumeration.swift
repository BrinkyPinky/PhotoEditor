//
//  MessagesEnum.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 18.06.2023.
//

// MARK: Все этапы через которые пользователь может пройти при редактировании фотографии
enum ApplicationStagesEnumeration {
    case photoAccessDenied, pickPhoto, photoPicked, photoEdited
    
    //Текст который приложение отправляет пользователю в виде сообщений
    var systemMessageText: String {
        switch self {
        case .photoAccessDenied:
            return "First of all, the application needs to give your permission to use the photos. You can do this in the settings by clicking on the button below."
        case .pickPhoto:
            return "Now click on the button below and select a photo from the gallery."
        case .photoPicked:
            return "Great! You can edit a photo or choose another one."
        case .photoEdited:
            return "You're done with it. Now you can save this image or start over."
        }
    }
    
    //Текста для кнопки действия
    var buttonText: String {
        switch self {
        case .photoAccessDenied:
            return "Settings"
        case .pickPhoto:
            return "Pick photo"
        case .photoPicked:
            return "Edit"
        case .photoEdited:
            return "Save"
        }
    }
    
    //Дополнительный текст для кнопки которая может появляться не всегда
    var additionalButtonText: String {
        switch self {
        case .photoPicked:
            return "Pick photo"
        case .photoEdited:
            return "Start over"
        default:
            return ""
        }
    }
}
