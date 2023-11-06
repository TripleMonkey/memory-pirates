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
        VStack { // Start VStack1
            VStack { // Start VStack2
                HStack {
                    Spacer()
                    Text("Game History")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundStyle(Color("darkBackground"))
                    Spacer()
                }
                HStack {
                    SortButton(sortValue: .bestTime)
                    SortButton(sortValue: .fewestMoves)
                    SortButton(sortValue: .newestGames)
                }
            } // End VStack2
            Spacer()
            List {
                ForEach(gamesVM.gameHistory) { game in
                    GameResultsView(gameTime: game.elapsedTime, gameMoves: Int(game.totalMoves), date: game.timeStarted ?? Date.now)
                }
            }
            .emptyListMessage(listCount: gamesVM.gameHistory.count, message: "Play to see your history here!")
            Spacer()
        } //End VStack1
        .fontWeight(.bold)
        .background(Rectangle()
            .fill(.white)
            .opacity(0.9)
            .cornerRadius(10)
        )
        .padding()
    }
}

struct LeaderboardTableView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardTableView()
    }
}
