//
//  Alerts.swift
//  TicTacToe
//
//  Created by Jason Dhindsa on 2021-05-16.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let p1Win = AlertItem(
        title: Text("Player 1 wins!"),
        message: Text("You are so smart!"),
        buttonTitle: Text("Finish")
    )
    static let p2Win = AlertItem(
        title: Text("Player 2 wins!"),
        message: Text("Awesome job!"),
        buttonTitle: Text("Finish")
    )
    static let draw = AlertItem(
        title: Text("Draw!"),
        message: Text("What a battle!"),
        buttonTitle: Text("Try again?")
    )
}

// Usage:
//alertItem = AlertContext.humanWin
