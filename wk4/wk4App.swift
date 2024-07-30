//
//  wk4App.swift
//  wk4
//
//  Created by Dayo Adekoya on 7/26/24.
//

import SwiftUI
import SwiftData

@main
struct wk4App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Message.self, Drawing.self])
    }
}
