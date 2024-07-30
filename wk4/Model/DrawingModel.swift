//
//  DrawingModel.swift
//  wk4
//
//  Created by Dayo Adekoya on 7/29/24.
//

import Foundation
import SwiftData

@Model
class Drawing: ObservableObject, Identifiable {
    var id: UUID
    @Attribute var points: [CGPoint] = []
    
    init(points: [CGPoint] = []) {
        self.id = UUID()
        self.points = points
    }
}
