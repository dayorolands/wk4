//
//  MessageListView.swift
//  wk4
//
//  Created by Dayo Adekoya on 7/29/24.
//

import SwiftUI
import SwiftData

struct MessageListView: View {
    @ObservedObject private var websocketViewModel = WebsocketViewModel()
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Message.id) var messages: [Message]
    @State private var newMessage = ""
    
    private func saveMessage(message: String) {
        let messageToSave = Message(text: message)
        modelContext.insert(messageToSave)
        do{
            try modelContext.save()
        } catch {
            print("Failed to save message : \(error.localizedDescription)")
        }
    }
    
    private func deduplicatedMessages() -> [Message] {
        let receivedMessageObjects = websocketViewModel.receivedMessage.map { Message(text: $0) }
        let combinedMessages = messages + receivedMessageObjects

        var uniqueMessages: [Message] = []
        var seenTexts: Set<String> = []

        for message in combinedMessages {
            if !seenTexts.contains(message.text) {
                uniqueMessages.append(message)
                seenTexts.insert(message.text)
            }
        }

        return uniqueMessages
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        let allMessages = deduplicatedMessages()
                        ForEach(allMessages, id: \.id) { message in
                            Text(message.text)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.vertical, 2)
                                .id(message.id)
                        }
                    }
                    .padding()
                    .onChange(of: websocketViewModel.receivedMessage, perform: { messages in
                        if let lastMessageIndex = messages.indices.last {
                            withAnimation {
                                proxy.scrollTo(lastMessageIndex, anchor: .bottom)
                            }
                        }
                    })
                }
                
                HStack {
                    TextField("Enter message", text: $newMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        if !newMessage.isEmpty {
                            saveMessage(message: newMessage)
                            websocketViewModel.sendMessage(newMessage)
                            self.hideKeyboard()
                            newMessage = ""
                        }
                    }) {
                        Text("Send")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.trailing)
                }
                .padding()
            }
            .onAppear {
                websocketViewModel.setupWebSocket()
                websocketViewModel.ping()
                //loadPersistedMessages()
            }
            .onReceive(websocketViewModel.$receivedMessage) { newMessages in
                print("The messages here \(newMessages)")
                for message in newMessages {
                    saveMessage(message: message)
                }
            }
            .onDisappear {
                websocketViewModel.closeWebsocket()
            }
        }
    }
    
    private func loadPersistedMessages() {
        websocketViewModel.receivedMessage = messages.map { $0.text }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
