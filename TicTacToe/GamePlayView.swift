//
//  HvCGameView.swift
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

struct GamePlayView: View {
    
    // MARK: - PROPERTIES
    @State var compWins = 0
    @State var humanWins = 0
    @State var draws = 0
    @State var backgroundColor: Color = .white
    @Binding var computerPlayer: Bool
    
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
        VStack {
            Spacer()
            GeometryReader { geometry in
                VStack {
                    HumanVsComputerScorecard(
                        compWins: $compWins,
                        humanWins: $humanWins,
                        draws: $draws
                    )
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(0..<ticTacToeSquares) { i in
                            ZStack {
                                Rectangle()
                                    .foregroundColor(shouldFlipCard(index: i) ? Color(#colorLiteral(red: 0.4196078431, green: 0.6666666667, blue: 0.4588235294, alpha: 1)) : Color(#colorLiteral(red: 0.4117647059, green: 0.4549019608, blue: 0.4862745098, alpha: 1)))
                                    .opacity(0.8)
                                    .frame(width: geometry.size.width/3-15, height: geometry.size.width/3-15, alignment: .center)
                                    .cornerRadius(7.5)
                                    .shadow(
                                        color: shouldFlipCard(index: i) ?
                                            Color(#colorLiteral(red: 0.4196078431, green: 0.6666666667, blue: 0.4588235294, alpha: 1)).opacity(0.4) :
                                            Color(#colorLiteral(red: 0.4117647059, green: 0.4549019608, blue: 0.4862745098, alpha: 1)).opacity(0.4), radius: 4, x: 2, y: 0)
                                    .rotation3DEffect(.degrees(shouldFlipCard(index: i) ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                                    .animation(animation)
                                Image(systemName:
                                        shouldFlipCard(index: i) ?
                                        viewModel.moves[i]?.indicator ?? "pencil.circle.fill" :
                                        "square.and.arrow.down.fill"
                                )
                                .resizable()
                                .frame(width: 35, height: 35, alignment: .center)
                                .font(.system(size: 50, weight: .bold, design: .rounded))
                                .opacity(
                                    shouldFlipCard(index: i) ? 1.0 : 0.0
                                )
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
                .onAppear {
                    self.backgroundColor = computerPlayer ? Color(#colorLiteral(red: 0.9960784314, green: 0.9803921569, blue: 0.8784313725, alpha: 1)) : Color(#colorLiteral(red: 0.9411764706, green: 0.937254902, blue: 0.9215686275, alpha: 1))
                }
            }//: GEOMETRY READER
            .padding(.top, 100)
            Spacer()
        }//: VSTACK
        .background(backgroundColor)
        .ignoresSafeArea()

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
    
    func shouldFlipCard(index: Int) -> Bool {
        return viewModel.moves[index]?.selectedBoardIndex == index ? true : false
    }
    
    func processMove(index: Int) {
        if !viewModel.isSquareOccupied(in: viewModel.moves, forIndex: index) {
            viewModel.moves[index] = Moves(selectedBoardIndex: index, player: .human)
            viewModel.isGameBoardDisabled = true
            // Check for a human win since the human player makes the 1st move
            if viewModel.checkForWin(player: .human, in: viewModel.moves) {
                // Alerts automatically call resetGame()
                viewModel.alertItem = AlertContext.humanWin
                humanWins += 1
            } else {
                // Computer's move now...
                let movesMadeCount = Set(viewModel.moves.compactMap { $0 }.compactMap { $0.selectedBoardIndex }).count
                if movesMadeCount < 9 {
                    createComputerMove()
                } else {
                    // Check for a human win since the human went last (9th move)
                    let humanWin = viewModel.checkForWin(player: .human, in: viewModel.moves)
                    // Alerts automatically call resetGame()
                    if humanWin {
                        viewModel.alertItem = AlertContext.humanWin
                        humanWins += 1
                    } else {
                        viewModel.alertItem = AlertContext.draw
                        draws += 1
                    }
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
        
        if viewModel.checkForWin(player: .computer, in: viewModel.moves) {
            viewModel.alertItem = AlertContext.computerWin // Alerts automatically call resetGame()
            compWins += 1
        }
    }
}

// MARK: - PREVIEW
struct HumanVsComputer_Previews: PreviewProvider {
    static var previews: some View {
        GamePlayView(computerPlayer: .constant(true))
    }
}

struct HumanVsComputerScorecard: View {
    
    // MARK: - PROPERTIES
    @Binding var compWins: Int
    @Binding var humanWins: Int
    @Binding var draws: Int
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10.0) {
                Text("Computer Wins")
                Spacer()
                Text("\(compWins)")
            }
            .padding(.horizontal, 20)
            HStack(spacing: 10.0) {
                Text("Human Wins")
                Spacer()
                Text("\(humanWins)")
            }
            .padding(.horizontal, 20)
            HStack(spacing: 10.0) {
                Text("Draws")
                Spacer()
                Text("\(draws)")
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
    }
}
