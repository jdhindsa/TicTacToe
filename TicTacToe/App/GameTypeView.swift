//
//  GameTypeView.swift
//  TicTacToe
//
//  Created by Jason Dhindsa on 2021-06-18.
//

import SwiftUI

struct GameTypeView: View {
    var body: some View {
        NavigationView {
            HStack {
                Spacer()
                VStack {
                    TitleView(title: "Choose your Game Type:", foregroundColor: Color(UIColor(named: "darkBlue")!))
                    NavigationLink(destination: GamePlayView(isAIPlayer: .constant(false))) {
                        ButtonView(
                            buttonTitle: "Human vs Human",
                            backgroundColor: Color(UIColor(named: "orange")!),
                            foregroundColor: Color(UIColor(named: "darkBlue")!)
                        )
                    }//: NAV LINK
                    .padding(.top, 10)
                    NavigationLink(destination: GamePlayView(isAIPlayer: .constant(true))) {
                        ButtonView(
                            buttonTitle: "Human vs Computer",
                            backgroundColor: Color(UIColor(named: "darkBlue")!),
                            foregroundColor: Color(UIColor(named: "cream")!)
                        )
                    }//: NAV LINK
                    .padding(.top, 10)
                    Image("people-with-laptop")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400, alignment: .center)
                    Spacer()
                }//: VSTACK
                .navigationBarHidden(true)
                .navigationBarTitle("")
                Spacer()
            }//: HSTACK
            .background(Color(UIColor(named: "cream")!))
            .edgesIgnoringSafeArea(.all)
        }//: NAVIGATION VIEW
        .accentColor(Color(UIColor(named: "red")!))
    }
}

struct TitleView: View {
    // MARK: - PROPERTIES
    var title: String
    var foregroundColor: Color
    
    // MARK: - BODY
    var body: some View {
        Text(title)
            .font(.system(size: 25, weight: .bold, design: .rounded))
            .foregroundColor(foregroundColor)
            .padding(.top, 90)
    }
}

struct ButtonView: View {
    // MARK: - PROPERTIES
    var buttonTitle: String
    var backgroundColor: Color
    var foregroundColor: Color
    
    // MARK: - BODY
    var body: some View {
        Text(buttonTitle)
            .frame(minWidth: 0, maxWidth: 300)
            .frame(height: 50)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(15)
            .padding()
            .font(.system(size: 20, weight: .semibold, design: .rounded))
            .shadow(color: Color.black.opacity(0.3),
                    radius: 3,
                    x: 3,
                    y: 3)
    }
}

struct ChooseGameType_Previews: PreviewProvider {
    static var previews: some View {
        GameTypeView()
    }
}
