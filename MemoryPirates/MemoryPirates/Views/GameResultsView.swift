//
//  GameResultsView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/24/23.
//

import SwiftUI

struct GameResultsView: View {
    
    var gameTime: Double
    var gameMoves: Int
    var date: Date

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Date")
                Text("\(date.formatted())")
            }
            HStack {
                HStack {
                    Text("Time")
                    Text("\(gameTime)")
                }
                Spacer()
                HStack {
                    Text("Chests Opened")
                    Text("\(gameMoves)")
                }
            }
        }
        .foregroundColor(Color("darkBackground"))
        .padding([.leading, .trailing])
    }
}

struct GameResultsView_Previews: PreviewProvider {
    static var previews: some View {
        GameResultsView(gameTime: 30.33, gameMoves: 32, date: Date.now)
    }
}
