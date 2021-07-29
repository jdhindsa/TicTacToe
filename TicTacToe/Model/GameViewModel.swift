//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Jason Dhindsa on 2021-05-17.<@5oubkHJz|c#iR6li!)
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Published var moves: [Moves?] = Array(repeating: nil, count: ticTacToeSquares)
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    var squarePositions: Set<Int> = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    var winningMoveCombos: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    
    func checkForWin(player: Player, in moves: [Moves?]) -> (Bool) {
        var isWinningSet = false
        let moveIndexSet = player == .p1 ?
            Set(moves.compactMap{$0}.filter { $0.player == .p1 }.compactMap { $0.selectedBoardIndex }) :
            Set(moves.compactMap{$0}.filter { $0.player == .p2 }.compactMap { $0.selectedBoardIndex })
        
        for winningSet in winningMoveCombos {
            if moveIndexSet.count > 3  && winningSet.isSubset(of: moveIndexSet) {
                isWinningSet = true
            } else if moveIndexSet.count <= 3 && moveIndexSet.isSubset(of: winningSet) && moveIndexSet == winningSet {
                isWinningSet = true
            }
        }
        return isWinningSet
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: ticTacToeSquares)
        isGameBoardDisabled = false
    }
    
    func isSquareOccupied(in moves: [Moves?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.selectedBoardIndex == index } )
    }
    
    func generateBlockingMoves(humanMoves: Set<Int>) -> [Int] {
        var blockingMoves = [Int]()
        for winningSet in winningMoveCombos {
            let potentialHumanWinMove = winningSet.subtracting(humanMoves)
            if potentialHumanWinMove.count == 1 && !isSquareOccupied(in: self.moves, forIndex: potentialHumanWinMove.first!) {
                blockingMoves.append(potentialHumanWinMove.first!)
                break
            }
        }
        return blockingMoves
    }
    
    func generateWinningMoves(computerMoves: Set<Int>) -> [Int] {
        var winningMoves = [Int]()
        for winningSet in winningMoveCombos {
            let potentialComputerWinMove = winningSet.subtracting(computerMoves)
            if potentialComputerWinMove.count == 1 && !isSquareOccupied(in: self.moves, forIndex: potentialComputerWinMove.first!) {
                winningMoves.append(potentialComputerWinMove.first!)
                break
            }
        }
        return winningMoves
    }
    
    func generateRandomComputerMove(moves: [Moves?]) -> Int {
        let squaresTaken = Set(moves.compactMap { $0 }.compactMap { $0.selectedBoardIndex })
        let availableSquares: Set<Int> = squarePositions.subtracting(squaresTaken)
        let countOfAvailableMoves = availableSquares.count
        let availableSquaresArray = Array(availableSquares)
        return availableSquaresArray[Int.random(in: 0...countOfAvailableMoves-1)]
    }
    
    func generateNextComputerMove(moves: [Moves?]) -> Int {
        
        var nextComputerMove: Int = 0
        
        let humanMovesSet = Set(moves.compactMap { $0 }.filter { $0.player == .p1 }.compactMap { $0.selectedBoardIndex })
        let computerMovesSet = Set(moves.compactMap { $0 }.filter { $0.player == .p2 }.compactMap { $0.selectedBoardIndex })
        
        // Need to first check if the computer can make a winning move...
        let winningMoves = generateWinningMoves(computerMoves: computerMovesSet)
        
        if winningMoves.count > 0 {
            nextComputerMove = winningMoves.first!
        } else {
            let blockingMoves = generateBlockingMoves(humanMoves: humanMovesSet)
            nextComputerMove = blockingMoves.count == 0 ?
                generateRandomComputerMove(moves: moves) :
                blockingMoves[Int.random(in: 0...blockingMoves.count-1)]
        }
        return nextComputerMove
    }
}
