//
//  Message.swift
//  wk4
//
//  Created by Dayo Adekoya on 7/29/24.
//

import Foundation
import SwiftData

@Model
class Message: ObservableObject, Identifiable {
    var id: UUID
    @Attribute var text: String = ""
    
    init(text: String = "") {
        self.id = UUID()
        self.text = text
    }
}
