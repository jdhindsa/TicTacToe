//
//  GamePlayView.swift
//  TicTacToe
//
//  Created by Jason Dhindsa on 2021-05-12.
//

/*
    Features to add:
    1) Ability to select a user to play with (ie. save and retrieve user data)
    2) See statistics versus the computer AND vs other players
    3)
*/

import SwiftUI

let screen = UIScreen.main.bounds

struct GamePlayView: View {
    // MARK: - PROPERTIES
    /*
     if computerPlayer == false {
     player2 is a human
     } else {
     player2 is the computer
     }
     */
    @State var p2TotalWins = 0
    @State var p1TotalWins = 0
    @State var tiedGames = 0
    @State var gameboardBackground: Color = .white
    @State var shouldShowScorecard = false
    @Binding var isAIPlayer: Bool
    @State var humanVsHumanTotalMoves = 0
    @StateObject private var viewModel = GameViewModel()
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var animation: Animation {
        Animation.linear(duration: 0.75)
    }
    
    // MARK: - BODY
    var body: some View {
        VStack {
            Spacer()
            ScorecardView(
                p2Wins: $p2TotalWins,
                p1Wins: $p1TotalWins,
                draws: $tiedGames,
                shouldShowScorecard: $shouldShowScorecard,
                isP2Computer: $isAIPlayer
            )
            .offset(x: shouldShowScorecard ? 0.0 : screen.width,
                    y: 100.0) // Need to figure out the y-position based on the Nav Bar height!
            .animation(.easeInOut(duration: 1.0))
            GeometryReader { geometry in
                VStack {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(0..<ticTacToeSquares) { i in
                            ZStack {
                                Circle()
                                    .foregroundColor(
                                        shouldFlipCard(index: i) ?
                                            Color(UIColor(named: "orange")!) :
                                            Color(UIColor(named: "red")!)
                                    )
                                    .opacity(1.0)
                                    .frame(width: geometry.size.width/3-15, height: geometry.size.width/3-15, alignment: .center)
                                    .cornerRadius(7.5)
                                    .shadow(
                                        color: shouldFlipCard(index: i) ?
                                            Color(UIColor(named: "orange")!).opacity(0.80) :
                                            Color(UIColor(named: "red")!).opacity(0.80), radius: 4, x: 2, y: 0)
                                    .rotation3DEffect(.degrees(shouldFlipCard(index: i) ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                                    .animation(animation)
                                Image(systemName:
                                        shouldFlipCard(index: i) ?
                                        viewModel.moves[i]?.indicator ?? "pencil.circle.fill" :
                                        "square.and.arrow.down.fill"
                                )
                                .resizable()
                                .foregroundColor(Color(UIColor(named: "reallyDarkBlue")!))
                                .frame(width: 35, height: 35, alignment: .center)
                                .font(.system(size: 50, weight: .bold, design: .rounded))
                                .opacity(
                                    shouldFlipCard(index: i) ? 1.0 : 0.0
                                )
                            }//: ZSTACK
                            .onTapGesture {
                                processMove(index: i, isAIOpponent: isAIPlayer)
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
                            self.shouldShowScorecard = true
                            viewModel.resetGame()
                        }))
                })
                .onAppear {
                    self.gameboardBackground = Color(UIColor(named: "cream")!)
                }
            }//: GEOMETRY READER
            .padding(.top, 100)
            Spacer()
        }//: VSTACK
        .background(gameboardBackground)
        .ignoresSafeArea()
    }//: BODY
    
    // MARK - FUNCTIONS
    func shouldFlipCard(index: Int) -> Bool {
        return viewModel.moves[index]?.selectedBoardIndex == index ? true : false
    }
    
    func processMoveHumanVersusAI(index: Int) {
        if !viewModel.isSquareOccupied(in: viewModel.moves, forIndex: index) {
            viewModel.moves[index] = Moves(selectedBoardIndex: index, player: .p1)
            viewModel.isGameBoardDisabled = true
            // Check for a human win since the human player makes the 1st move
            if viewModel.checkForWin(player: .p1, in: viewModel.moves) {
                // Alerts automatically call resetGame()
                viewModel.alertItem = AlertContext.p1Win
                shouldShowScorecard = true
                p1TotalWins += 1
            } else {
                // Computer's move now...
                let movesMadeCount = Set(viewModel.moves.compactMap { $0 }.compactMap { $0.selectedBoardIndex }).count
                if movesMadeCount < ticTacToeSquares {
                    createComputerMove()
                } else {
                    // Check for a p1 win since p1 went last (9th move)
                    let p1Win = viewModel.checkForWin(player: .p1, in: viewModel.moves)
                    // Alerts automatically call resetGame()
                    if p1Win {
                        viewModel.alertItem = AlertContext.p1Win
                        shouldShowScorecard = true
                        p1TotalWins += 1
                    } else {
                        viewModel.alertItem = AlertContext.draw
                        shouldShowScorecard = true
                        tiedGames += 1
                    }
                }
            }
        }
    }
    
    func processMoveHumanVersusHuman(index: Int) {
        if !viewModel.isSquareOccupied(in: viewModel.moves, forIndex: index) {
            if humanVsHumanTotalMoves % 2 == 0 {
                viewModel.moves[index] = Moves(selectedBoardIndex: index, player: .p1)
            } else {
                viewModel.moves[index] = Moves(selectedBoardIndex: index, player: .p2)
            }
            humanVsHumanTotalMoves += 1
            
            if humanVsHumanTotalMoves < ticTacToeSquares &&
                humanVsHumanTotalMoves % 2 != 0 && viewModel.checkForWin(player: .p1, in: viewModel.moves) {
                viewModel.alertItem = AlertContext.p1Win // Alerts automatically call resetGame()
                p1TotalWins += 1
                humanVsHumanTotalMoves = 0
            } else if humanVsHumanTotalMoves < ticTacToeSquares &&
                        humanVsHumanTotalMoves % 2 == 0 &&
                        viewModel.checkForWin(player: .p2, in: viewModel.moves){
                viewModel.alertItem = AlertContext.p2Win // Alerts automatically call resetGame()
                p2TotalWins += 1
                humanVsHumanTotalMoves = 0
            } else if humanVsHumanTotalMoves == ticTacToeSquares &&
                        viewModel.checkForWin(player: .p1, in: viewModel.moves) {
                viewModel.alertItem = AlertContext.p1Win // Alerts automatically call resetGame()
                p1TotalWins += 1
                humanVsHumanTotalMoves = 0
            } else if humanVsHumanTotalMoves == ticTacToeSquares &&
                        !viewModel.checkForWin(player: .p1, in: viewModel.moves) {
                viewModel.alertItem = AlertContext.draw // Alerts automatically call resetGame()
                tiedGames += 1
                humanVsHumanTotalMoves = 0
            }
        }
    }
    
    func processMove(index: Int, isAIOpponent: Bool) {
        
        if isAIOpponent {
            processMoveHumanVersusAI(index: index)
        } else {
            processMoveHumanVersusHuman(index: index)
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
        
        viewModel.moves[computerMove] = Moves(selectedBoardIndex: computerMove, player: .p2)
        viewModel.isGameBoardDisabled = false
        
        if viewModel.checkForWin(player: .p2, in: viewModel.moves) {
            viewModel.alertItem = AlertContext.p2Win
            shouldShowScorecard = true
            p2TotalWins += 1
        }
    }
}

// MARK: - PREVIEW
struct GamePlayViewr_Previews: PreviewProvider {
    static var previews: some View {
        GamePlayView(isAIPlayer: .constant(true))
    }
}
