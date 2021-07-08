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
                    TitleView(title: "Choose your Game Type:", foregroundColor: Color(#colorLiteral(red: 0.9411764706, green: 0.937254902, blue: 0.9215686275, alpha: 1)))
                    NavigationLink(destination: HvCGameView(computerPlayer: .constant(false))) {
                        ButtonView(buttonTitle: "Human vs Human", backgroundColor: Color(#colorLiteral(red: 0.9411764706, green: 0.937254902, blue: 0.9215686275, alpha: 1)))
                    }//: NAV LINK
                    .padding(.top, 25)
                    NavigationLink(destination: HvCGameView(computerPlayer: .constant(true))) {
                        ButtonView(buttonTitle: "Human vs Computer", backgroundColor: Color(#colorLiteral(red: 0.9960784314, green: 0.9803921569, blue: 0.8784313725, alpha: 1)))
                    }//: NAV LINK
                    .padding(.top, 25)
                    Spacer()
                }//: VSTACK
                .navigationBarHidden(true)
                .navigationBarTitle("")
                Spacer()
            }//: HSTACK
            .background(Color(#colorLiteral(red: 0.02745098039, green: 0.231372549, blue: 0.2980392157, alpha: 1)))
            .edgesIgnoringSafeArea(.all)
        }
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
    
    // MARK: - BODY
    var body: some View {
        Text(buttonTitle)
            .frame(minWidth: 0, maxWidth: 300)
            .padding()
            .foregroundColor(.black)
            .background(backgroundColor)
            .cornerRadius(12)
            .font(.title)
    }
}

struct ChooseGameType_Previews: PreviewProvider {
    static var previews: some View {
        GameTypeView()
    }
}
