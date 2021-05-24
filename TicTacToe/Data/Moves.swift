//
//  Moves.swift
//  TicTacToe
//
//  Created by Jason Dhindsa on 2021-05-15.
//

import SwiftUI

struct Moves {
    var selectedBoardIndex: Int
    var player: Player
    var indicator: String {
        return player == .human ? PlayerSymbols.x_symbol.rawValue : PlayerSymbols.o_symbol.rawValue
    }
}

var ticTacToeSquares = 9
let winningMoveCombos: Set<Set<Int>> = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
]
var squarePositions: Set<Int> = [0, 1, 2, 3, 4, 5, 6, 7, 8]
var gameWonStatus: Bool = false
