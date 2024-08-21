//
//  MazeView.swift
//  Maze
//
//  Created by Полина Лущевская on 27.06.24.
//

import SwiftUI


struct MazeView: View {
    @State private var maze = Maze(rows: 15, columns: 15)
    @State private var currentCell = Cell(x: 1, y: 0)
    @State private var message = "Find the correct path to the exit!"
    @State private var isWrongPath = false
    @State private var isGameFinished = false

    var body: some View {
        ScrollView {
            VStack {
                Text(message)
                    .padding()
                
                // Отображение сетки лабиринта
                ForEach(0..<maze.grid.count, id: \.self) { row in
                    HStack(spacing: 4) {
                        ForEach(0..<maze.grid[row].count, id: \.self) { col in
                            CellView(cellType: maze.grid[row][col], isCurrent: currentCell.x == row && currentCell.y == col)
                        }
                    }
                }
                
                HStack {
                    Button(action: { move(.up) }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    .accentColor(Color("Purply"))
                    Button(action: { move(.down) }) {
                        Image(systemName: "arrow.down.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    .accentColor(Color("Purply"))
                    Button(action: { move(.left) }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    .accentColor(Color("Purply"))
                    Button(action: { move(.right) }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    .accentColor(Color("Purply"))
                }
                .padding()
                
                if isGameFinished {
                    Button(action: {
                        resetGame()
                    }) {
                        Text("Start New Maze")
                            .padding()
                            .background(Color("Purply"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }

    func move(_ direction: Direction) {
        if isGameFinished {
            return
        }
        
        var newCell = currentCell
        switch direction {
        case .up: newCell.x -= 1
        case .down: newCell.x += 1
        case .left: newCell.y -= 1
        case .right: newCell.y += 1
        }
        
        // Проверка, что новое положение находится внутри границ лабиринта и является путем
        if newCell.x >= 0 && newCell.x < maze.grid.count && newCell.y >= 0 && newCell.y < maze.grid[0].count {
            if maze.grid[newCell.x][newCell.y] == .path || maze.grid[newCell.x][newCell.y] == .start || maze.grid[newCell.x][newCell.y] == .end {
                currentCell = newCell
                if currentCell == maze.end {
                    message = "Congratulations! You found the exit!"
                    isGameFinished = true
                } else if isWrongPath {
                    message = "You are back on the correct path. Keep going!"
                    isWrongPath = false
                }
            } else {
                message = "Wrong path! Try again."
                isWrongPath = true
            }
        } else {
            message = "Out of bounds! Try again."
            isWrongPath = true
        }
    }
    
    func resetGame() {
        maze = Maze(rows: 15, columns: 15)
        currentCell = Cell(x: 1, y: 0)
        message = "Find the correct path to the exit!"
        isWrongPath = false
        isGameFinished = false
    }
}

// Представление для отображения отдельной ячейки лабиринта
struct CellView: View {
    var cellType: CellType
    var isCurrent: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(colorForCellType())
                .frame(width: 20, height: 20)
                .border(Color.gray)
            if isCurrent {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 10, height: 10)
                    .border(Color.gray)
            }
            
            if cellType == .start {
                Image(systemName: "arrowtriangle.right.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .offset(x: 4, y: -4)
            } else if cellType == .end {
                Image(systemName: "arrowtriangle.left.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .offset(x: 4, y: -4)
            }
        }
    }
    
    private func colorForCellType() -> Color {
        switch cellType {
        case .path:
            return Color.white
        case .wall:
            return Color.black
        case .start, .end:
            return Color("Purply")
        }
    }
}

struct MazeView_Previews: PreviewProvider {
    static var previews: some View {
        MazeView()
    }
}
