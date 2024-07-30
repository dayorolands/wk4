//
//  ContentView.swift
//  wk4
//
//  Created by Dayo Adekoya on 7/26/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var websocketViewModel = WebsocketViewModel()
    var body: some View {
        VStack {
            DrawingCanvasView()
                .frame(height: 300)
                .border(Color.gray, width: 2)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            Spacer().frame(height: 20)

            MessageListView()
                .environmentObject(websocketViewModel)
                .border(Color.gray, width: 2)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
