//
//  GameResultsView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/24/23.
//

import SwiftUI

struct GameResultsView: View {
    
    @StateObject var leaderboardVM = LeaderboardViewModel.shared
    
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
                    Text("\(leaderboardVM.formattedTime(seconds: gameTime))")
                }
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
        GameResultsView(gameTime: 533.339, gameMoves: 32, date: Date.now)
    }
}
