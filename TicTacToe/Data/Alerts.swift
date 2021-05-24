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
    static let humanWin = AlertItem(
        title: Text("You win!"),
        message: Text("You are so smart! You beat the computer!"),
        buttonTitle: Text("Hell Yeah Mother Fucker!")
    )
    static let computerWin = AlertItem(
        title: Text("You lost!"),
        message: Text("You programmed a super AI!"),
        buttonTitle: Text("Rematch?")
    )
    static let draw = AlertItem(
        title: Text("Draw!"),
        message: Text("What a battle!"),
        buttonTitle: Text("Try again?")
    )
}

// To use it:
//alertItem = AlertContext.humanWin
