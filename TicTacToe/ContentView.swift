//
//  ContentView.swift
//  TicTacToe
//
//  Created by Jason Dhindsa on 2021-05-12.
//

/*
    Helpful articles:
        1. https://www.linkedin.com/pulse/rotating-views-along-any-axis-swiftui-stephen-feuerstein/
        2. https://betterprogramming.pub/how-to-build-a-rotation-animation-in-swiftui-e8fb889ccf7e
 */

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTIES
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @StateObject private var viewModel = GameViewModel()
    var animation: Animation {
        Animation.linear(duration: 0.75)
    }
    
    // MARK: - BODY
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(0..<ticTacToeSquares) { i in
                        ZStack {
                            Rectangle()
                                .foregroundColor(viewModel.moves[i]?.selectedBoardIndex == i ? Color(#colorLiteral(red: 0.8980392157, green: 0.3490196078, blue: 0.2039215686, alpha: 1)) : Color(#colorLiteral(red: 0.6078431373, green: 0.7725490196, blue: 0.2392156863, alpha: 1)))
                                .opacity(0.8)
                                .frame(width: geometry.size.width/3-15, height: geometry.size.width/3-15, alignment: .center)
                                .cornerRadius(7.5)
                                .shadow(color: viewModel.moves[i]?.selectedBoardIndex == i ? Color(#colorLiteral(red: 0.8980392157, green: 0.3490196078, blue: 0.2039215686, alpha: 1)).opacity(0.4) : Color(#colorLiteral(red: 0.6078431373, green: 0.7725490196, blue: 0.2392156863, alpha: 1)).opacity(0.4), radius: 4, x: 2, y: 0)
                                .rotation3DEffect(.degrees(viewModel.moves[i]?.selectedBoardIndex == i ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                                .animation(animation)
                            Image(systemName: viewModel.moves[i]?.indicator ?? "sun.max.circle")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .font(.system(size: 50, weight: .bold, design: .rounded))
                        }//: ZSTACK
                        .onTapGesture {
                            processMove(index: i)
                        }//: ON TAP GESTURE
                    }//: FOREACH
                }//: LAZYVGRID
                Spacer()
            }//: VSTACK
            .disabled(viewModel.isGameBoardDisabled)
            .padding(.horizontal, 10)
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(
                    title: alertItem.title,
                    message: alertItem.message,
                    dismissButton: .default(alertItem.buttonTitle, action: {
                        viewModel.resetGame()
                    }))
            })
            
        }//: GEOMETRY READER
    }//: BODY
    
    // MARK - FUNCTIONS
    
    /*
        Moves Order:
        1 - Human
        2 - Computer
        3 - Human
        4 - Computer
        5 - Human
        6 - Computer
        7 - Human
        8 - Computer
        9 - Human
    */
    
    func processMove(index: Int) {
        if !viewModel.isSquareOccupied(in: viewModel.moves, forIndex: index) {
            viewModel.moves[index] = Moves(selectedBoardIndex: index, player: .human)
            viewModel.isGameBoardDisabled = true
            // Check for a human win since the human player makes the 1st move
            if viewModel.checkForWin(player: .human, in: viewModel.moves) {
                // Alerts automatically call resetGame()
                viewModel.alertItem = AlertContext.humanWin
            } else {
                // Computer's move now...
                let movesMadeCount = Set(viewModel.moves.compactMap { $0 }.compactMap { $0.selectedBoardIndex }).count
                if movesMadeCount < 9 {
                    createComputerMove()
                } else {
                    // Check for a human win since the human went last (9th move)
                    let humanWin = viewModel.checkForWin(player: .human, in: viewModel.moves)
                    // Alerts automatically call resetGame()
                    viewModel.alertItem = humanWin == true ? AlertContext.humanWin : AlertContext.draw
                }
            }
        }
    }
    
    func createComputerMove() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            processGenerateNextComputerMoveAILogic()
        }
    }
    
    func processGenerateNextComputerMoveAILogic() {
        var computerMove = viewModel.generateNextComputerMove(moves: viewModel.moves)
        repeat {
            computerMove = viewModel.generateNextComputerMove(moves: viewModel.moves)
        } while viewModel.isSquareOccupied(in: viewModel.moves, forIndex: computerMove)
        
        viewModel.moves[computerMove] = Moves(selectedBoardIndex: computerMove, player: .computer)
        viewModel.isGameBoardDisabled = false
        
        let computerWin = viewModel.checkForWin(player: .computer, in: viewModel.moves)
        if computerWin {
            viewModel.alertItem = AlertContext.computerWin // Alerts automatically call resetGame()
        }
    }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
