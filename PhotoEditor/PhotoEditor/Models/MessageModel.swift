//
//  MessageModel.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 17.06.2023.
//

import Foundation
import PhotosUI

enum MessageType {
    case text, image
}

struct MessageModel: Identifiable, Equatable {
    let id = UUID()
    let message: String
    let isApplicationSendMessage: Bool
    let messageType: MessageType
    let image: UIImage?
}
