//
//  ContentView.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 17.06.2023.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometryProxy in
                NavigationLink("", isActive: $viewModel.editViewIsPresented) {
                    if viewModel.pickedImage != nil {
                        EditView(
                            pickedImage: viewModel.pickedImage!.image,
                            imageEditingIsDone: viewModel.imageEditingIsDone
                        )
                    }
                }
                VStack {
                    //MessagesView
                    ScrollViewReader { scrollView in
                        ScrollView {
                            LazyVStack {
                                ForEach(viewModel.messages) { messageModel in
                                    MessagesView(messageModel: messageModel, geometryProxy: geometryProxy)
                                        .id(messageModel.id)
                                        .transition(.scale)
                                }
                            }
                            .animation(.easeOut(duration: 0.2), value: viewModel.messages)
                            .padding(.top, 16)
                            .onChange(of: viewModel.messages) { _ in
                                withAnimation {
                                    scrollView.scrollTo(viewModel.messages.last?.id, anchor: .center)
                                }
                            }
                            .padding(.bottom, 8)
                        }
                    }
                    .padding(.bottom, -8)
                    
                    Spacer()
                    
                    //Нижняя панель с кнопками
                    ActionButtonsView(
                        geometryProxy: geometryProxy,
                        applicationStage: viewModel.applicationStage,
                        buttonAction: viewModel.buttonAction,
                        additionalButtonAction: viewModel.additionalButtonAction
                    )
                }
            }
            .navigationTitle("Useless PhotoEditor")
            .sheet(isPresented: $viewModel.imagePickerIsPresented) {
                guard viewModel.pickedImage != nil else { return }
                viewModel.loadHighQualityImage()
            } content: {
                ImagePickerView(selectedImage: $viewModel.pickedImage)
            }
            .onAppear {
                viewModel.onAppear()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// MARK: Вью со всеми сообщениями которые присылает пользователь или приложение. В своем роде гид по приложению
struct MessagesView: View {
    let messageModel: MessageModel
    let geometryProxy: GeometryProxy
    
    var body: some View {
        VStack {
            HStack {
                if !messageModel.isApplicationSendMessage {
                    Spacer()
                }
                
                switch messageModel.messageType {
                case .text:
                    Text(messageModel.message)
                        .foregroundColor(
                            messageModel.isApplicationSendMessage ?
                                .init(uiColor: .secondarySystemBackground) : .white
                        )
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(messageModel.isApplicationSendMessage ? .primary : .indigo)
                            
                        }
                        .padding([.leading, .trailing], 16)
                        .padding(.trailing, geometryProxy.size.width/10)
                case .image:
                    //nil быть не может
                    Image(uiImage: messageModel.image!)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.indigo, style: .init(lineWidth: 2))
                        })
                        .padding(.trailing, 16)
                        .padding(.leading, geometryProxy.size.width/3)
                }
                
                if messageModel.isApplicationSendMessage {
                    Spacer()
                }
            }
        }
    }
}

// MARK: View с кнопками
struct ActionButtonsView: View {
    let geometryProxy: GeometryProxy
    var applicationStage: ApplicationStagesEnumeration
    let buttonAction: () -> Void
    let additionalButtonAction: () -> Void
    
    var body: some View {
        VStack {
            //Дополнительная кнопка
            if applicationStage == .photoPicked || applicationStage == .photoEdited {
                Button {
                    additionalButtonAction()
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.indigo)
                        .frame(width: geometryProxy.size.width/1.1, height: 50)
                        .overlay {
                            Text(applicationStage.additionalButtonText)
                                .foregroundColor(.white)
                                .bold()
                                .padding()
                        }
                }
                .padding(.bottom, 8)
            }
            
            //Основная кнопка действия
            Button {
                buttonAction()
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.indigo)
                    .frame(width: geometryProxy.size.width/1.1, height: 50)
                    .overlay {
                        Text(applicationStage.buttonText)
                            .foregroundColor(.white)
                            .bold()
                            .padding()
                    }
            }
        }
        .padding(.top, 32)
        .padding(.bottom)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .ignoresSafeArea()
                .frame(width: geometryProxy.size.width)
        }
        .animation(.easeInOut(duration: 0.2), value: applicationStage)
    }
}
