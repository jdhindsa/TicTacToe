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
                    TitleView(title: "Choose your Game Type:", foregroundColor: Color(#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)))
                    NavigationLink(destination: GamePlayView(isAIPlayer: .constant(false))) {
                        ButtonView(
                            buttonTitle: "Human vs Human",
                            backgroundColor: Color(#colorLiteral(red: 0.9921568627, green: 1, blue: 0.7137254902, alpha: 1)),
                            textColor: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                        )
                    }//: NAV LINK
                    .padding(.top, 25)
                    NavigationLink(destination: GamePlayView(isAIPlayer: .constant(true))) {
                        ButtonView(
                            buttonTitle: "Human vs Computer",
                            backgroundColor: Color(#colorLiteral(red: 0.9019607843, green: 0.2235294118, blue: 0.2745098039, alpha: 1)),
                            textColor: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
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
            .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
            .edgesIgnoringSafeArea(.all)
        }//: NAVIGATION VIEW
        .accentColor(Color(#colorLiteral(red: 0.9921568627, green: 1, blue: 0.7137254902, alpha: 1)))
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
    var textColor: Color
    
    // MARK: - BODY
    var body: some View {
        Text(buttonTitle)
            .frame(minWidth: 0, maxWidth: 300)
            .frame(height: 50)
            .background(backgroundColor)
            .foregroundColor(textColor)
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
