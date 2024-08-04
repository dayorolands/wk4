//
//  DrawingCanvasView.swift
//  wk4
//
//  Created by Dayo Adekoya on 7/29/24.
//

import SwiftUI
import SwiftData

struct DrawingCanvasView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var drawings: [Drawing]
    @State private var currentPath = Path()
    @State private var paths: [Path] = []
    @State private var currentPoints: [CGPoint] = []
    
    private func saveDrawing(points: [CGPoint]) {
        let newDrawing = Drawing(points: points)
        modelContext.insert(newDrawing)
    }
    
    private func clearDrawings()  {
        for drawing in drawings {
            modelContext.delete(drawing)
        }
        currentPath = Path()
        paths.removeAll()
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack {
                Canvas { context, size in
                    for drawing in drawings {
                        _ = Path { path in
                            path.addLines(drawing.points)
                            context.stroke(path, with: .color(Color.black), lineWidth: 2)
                        }
                    }
                }
            }
            .background(Color.white)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged { value in
                    self.currentPoints.append(value.location)
                    self.currentPath.addLine(to: value.location)
                }
                .onEnded { value in
                    self.paths.append(self.currentPath)
                    self.saveDrawing(points: self.currentPoints)
                    self.currentPath = Path()
                    self.currentPoints = []
                }
            )
            .onAppear {
                paths = drawings.map { drawing in
                    var path = Path()
                    path.addLines(drawing.points)
                    return path
                }
            }
            .cornerRadius(10)
            .shadow(radius: 5)
            
            Button(action: {
                clearDrawings()
            }) {
                Text("Clear")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
            
}

struct DrawingCanvas_Preview: PreviewProvider {
    static var previews: some View {
        DrawingCanvasView()
    }
}
