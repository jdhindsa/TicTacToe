//
//  ScorecardView.swift
//  TicTacToe
//
//  Created by Jason Dhindsa on 2021-07-09.
//

import SwiftUI

struct ScorecardView: View {
    // MARK: - PROPERTIES
    @Binding var p2Wins: Int
    @Binding var p1Wins: Int
    @Binding var draws: Int
    @Binding var shouldShowScorecard: Bool
    @Binding var isP2Computer: Bool
    @State var dismissScorecard = false
    
    var animation: Animation {
        Animation.linear(duration: 0.25)
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(UIColor(named: "red")!))
                .frame(width: screen.width - 40, height: 100)
                .cornerRadius(8.0)
            VStack(alignment: .leading) {
                HStack(spacing: 10.0) {
                    Text("\(self.isP2Computer ? "Computer" : "Player 2") Wins")
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(p2Wins)")
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 20)
                HStack(spacing: 10.0) {
                    Text("Player 1 Wins")
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(p1Wins)")
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 20)
                HStack(spacing: 10.0) {
                    Text("Draws")
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(draws)")
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 20)
            }//: VSTACK
            .padding(.horizontal, 25)
            .foregroundColor(Color(UIColor(named: "cream")!))

            Button(action: {
                self.shouldShowScorecard = false
                self.dismissScorecard = true
            }) {
                ZStack {
                    Circle()
                        .fill()
                        .foregroundColor(Color(UIColor(named: "orange")!))
                        .frame(width: 44, height: 44, alignment: .center)

                    Text("X")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color(UIColor(named: "cream")!))
                }//: ZSTACK
                .rotation3DEffect(.degrees(dismissScorecard ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .animation(animation)
            }//: BUTTON
            .padding(.top, 30)
            .offset(x: screen.width/2 - 27, y: -65)
        }//: ZSTACK
        .padding(.top, 75)
        .padding(.horizontal, 20)

    }//: BODY
}

struct ScorecardView_Previews: PreviewProvider {
    static var previews: some View {
        ScorecardView(
            p2Wins: .constant(1),
            p1Wins: .constant(2),
            draws: .constant(0),
            shouldShowScorecard: .constant(false),
            isP2Computer: .constant(false)
        )
    }
}
