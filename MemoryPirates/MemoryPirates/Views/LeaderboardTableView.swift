//
//  LeaderboardTableView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/23/23.
//

import SwiftUI

struct LeaderboardTableView: View {
    
    @StateObject var gamesVM: LeaderboardViewModel = LeaderboardViewModel.shared
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Game History")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
            }
            List {
                ForEach(gamesVM.gameHistory) { game in
                    GameResultsView(gameTime: game.elapsedTime, gameMoves: Int(game.totalMoves), date: game.timeStarted ?? Date.now)
                }
            }
            .emptyListMessage(for: gamesVM.gameHistory.count, message: "Play to see your history here!")
        }
        .fontWeight(.bold)
        .background(Rectangle()
            .fill(.white)
            .opacity(0.9)
            .cornerRadius(10)
        )
        .foregroundColor(Color("darkBackground"))
        .padding()
    }
    
}

struct LeaderboardTableView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardTableView()
    }
}
