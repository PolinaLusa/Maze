//
//  MazeModel.swift
//  Maze
//
//  Created by Полина Лущевская on 27.06.24.
//

import Foundation


enum CellType {
    case path, wall, start, end
}

struct Cell: Equatable, Hashable {
    var x: Int
    var y: Int
}

enum Direction {
    case up, down, left, right
}

// Структура лабиринта
struct Maze {
    var grid: [[CellType]]
    var start: Cell
    var end: Cell
    
    // Инициализация лабиринта с заданным количеством строк и столбцов
    init(rows: Int, columns: Int) {
        grid = Array(repeating: Array(repeating: .wall, count: columns), count: rows)
        start = Cell(x: 1, y: 0)
        end = Cell(x: 1, y: 1)
        
        generateMaze(rows: rows, columns: columns)
    }
    
    // Метод генерации лабиринта
    mutating func generateMaze(rows: Int, columns: Int) {
        var visited: Set<Cell> = []
        var stack: [Cell] = [start]
        
        while !stack.isEmpty {
            let current = stack.last!
            visited.insert(current)
            grid[current.x][current.y] = .path // Установка текущей ячейки как путь
            
            var neighbors: [Cell] = []
            
            // Проверка и добавление соседей
            if current.x >= 2 {
                neighbors.append(Cell(x: current.x - 2, y: current.y))
            }
            if current.x <= rows - 3 {
                neighbors.append(Cell(x: current.x + 2, y: current.y))
            }
            if current.y >= 2 {
                neighbors.append(Cell(x: current.x, y: current.y - 2))
            }
            if current.y <= columns - 3 {
                neighbors.append(Cell(x: current.x, y: current.y + 2))
            }
            
            neighbors.shuffle()
            
            var foundNeighbor = false
            
            // Поиск непосещенного соседа
            for neighbor in neighbors {
                if !visited.contains(neighbor) {
                    stack.append(neighbor)
                    let wallX = (current.x + neighbor.x) / 2
                    let wallY = (current.y + neighbor.y) / 2
                    grid[wallX][wallY] = .path // Создание пути между текущей ячейкой и соседом
                    foundNeighbor = true
                    break
                }
            }
            
            if !foundNeighbor {
                stack.removeLast() // Возврат к предыдущей ячейке
            }
        }
        
        // Установка случайной конечной ячейки
        repeat {
            end = Cell(x: Int.random(in: 4..<rows), y: Int.random(in: 8..<columns))
        } while end == start
        
        grid[start.x][start.y] = .start
        grid[end.x][end.y] = .end
    }
    
    // Установка пути между двумя ячейками
    mutating func setPath(from: Cell, to: Cell) {
        grid[from.x][from.y] = .path
        grid[to.x][to.y] = .path
    }
    
    // Проверка, является ли ячейка путем
    func isPath(_ cell: Cell) -> Bool {
        return grid[cell.x][cell.y] == .path || grid[cell.x][cell.y] == .start || grid[cell.x][cell.y] == .end
    }
    
    // Метод для генерации случайного лабиринта
    static func randomMaze(rows: Int, columns: Int) -> Maze {
        let maze = Maze(rows: rows, columns: columns)
        return maze
    }
}
