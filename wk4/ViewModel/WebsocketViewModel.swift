//
//  WebsocketViewModel.swift
//  wk4
//
//  Created by Dayo Adekoya on 7/29/24.
//

import Foundation


class WebsocketViewModel: NSObject, ObservableObject {
    @Published var receivedMessage: [String] = []
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    func setupWebSocket() {
        let url = URL(string: "wss://echo.websocket.org")!
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }
    
    func ping() {
        DispatchQueue.global().asyncAfter(deadline: .now()+5, execute: {
            self.ping()
            self.webSocketTask?.sendPing{ error in
                if let error = error {
                    print("The web socket ping error is : \(error)")
                } else {
                    print("I believe the websocket is still active.")
                }
            }
        })
    }
    
    func sendMessage(_ sentMessage: String){
        let messageToSend = URLSessionWebSocketTask.Message.string(sentMessage)
        print("The message to send is \(messageToSend)")
        print("Sending message...")
        webSocketTask?.send(messageToSend, completionHandler: { error in
            if let error = error {
                print("Error sending message : \(error)")
            }
        })
    }
    
    func receiveMessage(){
        webSocketTask?.receive(completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        self.receivedMessage.append(text)
                    }
                case .data(let data):
                    print("Received data is: \(data)")
                @unknown default:
                    fatalError()
                }
                self.receiveMessage()
            case .failure(let error):
                print("Error receiving message: \(error)")
            }
        })
    }
    
    func closeWebsocket(){
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
}

extension WebsocketViewModel: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Websocket connection established.")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Websocet connection closed.")
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: (any Error)?) {
        if let error = error {
            print("URLSession became invalide with the error : \(error)")
        } else {
            print("URLSession becamse invalid without an error.")
        }
    }
}
