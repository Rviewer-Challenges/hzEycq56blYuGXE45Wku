//
//  GameViewModel.swift
//  Simpson Memory
//
//  Created by Jonathan Torres on 20/05/22.
//

import SwiftUI


extension GameView {
    class ViewModel: ObservableObject {
        private let imgsName = [
        "apu",
        "barney",
        "bart1",
        "bart2",
        "bart3",
        "bob",
        "burns",
        "comics",
        "family",
        "homero1",
        "jefe_gorgory",
        "krusty",
        "lisa",
        "maggie",
        "marge1",
        "martin",
        "milhouse",
        "moe",
        "nelson",
        "skinner",
        "smithers"
    ]
        
        @Published var currentBoard: Board = Board(columns: 4, rows: 4)
        @Published var faces: [String] = Array(repeating: "", count: 16)
        @Published var moves: [Move?] = Array(repeating: nil, count: 16)
        @Published var difficulty: TypeBoard = .easy
        @Published var currentMoves = 0
        @Published var prevMove: Move? = nil
        @Published var isBoardDisable = false
        @Published var points: Int = 0
        
        func isPositionFlipped(in moves: [Move?], forIndex index: Int) -> Bool {
            return moves.contains(where: {$0?.boardIndex == index })
        }
        
        func processPlayerMove(for position: Int) {
            if isPositionFlipped(in: moves, forIndex: position) { return }
            let currentMove = Move(cardName: "\(faces[position])", boardIndex: position)
            
            if currentMoves < 1 {
                prevMove = currentMove
            }
            if currentMoves < 2 {
                currentMoves += 1
                moves[position] = currentMove
            }
            if currentMoves == 2 {
                isBoardDisable = true
                guard let prevMove = prevMove else {
                    return
                }
                if prevMove.cardName == currentMove.cardName {
                    currentMoves = 0
                    self.prevMove = nil
                    self.points += 1
                    isBoardDisable = false
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        withAnimation(Animation.easeOut(duration: 0.5)) {
                            self.moves[position] = nil
                            self.moves[prevMove.boardIndex] = nil
                            self.currentMoves = 0
                            self.prevMove = nil
                            self.isBoardDisable = false
                        }
                    }
                }
            }
        }
        
        func initBorad() {
            changeBoard()
        }
        
        func changeBoard() {
            switch difficulty {
            case .easy:
                currentBoard = Board(columns: 4, rows: 4)
            case .medium:
                currentBoard = Board(columns: 4, rows: 6)
            case .hard:
                currentBoard = Board(columns: 5, rows: 6)
            }
            randomBoard()
            moves = Array(repeating: nil, count: currentBoard.total)
            currentMoves = 0
            self.points = 0
            prevMove = nil
        }
        
        func randomBoard() {
            var possibleItems = imgsName.shuffled()
            var possibleFaces: [String] = []
            for _ in 0..<(currentBoard.total/2) {
                let randomIndex = (0..<possibleItems.count).randomElement()!
                possibleFaces.append(possibleItems[randomIndex])
                possibleFaces.append(possibleItems[randomIndex])
                possibleItems.remove(at: randomIndex)
            }
            possibleFaces.shuffle()
            self.faces = possibleFaces
        }
    }
}
