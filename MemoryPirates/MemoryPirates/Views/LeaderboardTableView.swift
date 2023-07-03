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
            VStack {HStack {
                Spacer()
                Text("Game History")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
            }
                HStack {
                    SortButton(sortValue: .bestTime)
                    SortButton(sortValue: .fewestMoves)
                    SortButton(sortValue: .newestGames)
//                    Button {
//                        gamesVM.sortSelector = .bestTime
//                        gamesVM.fetchScores()
//                    } label: {
//                        Label("Best Time", systemImage: "gear.fill")
//                            .labelStyle(.titleOnly)
//                    }
//                    .background(gamesVM.sortSelector == .bestTime ? Color("lightBackground") : Color("darkBackground"))
//                    .foregroundColor(gamesVM.sortSelector == .bestTime ? .white : Color("lightText"))
//                    .cornerRadius(25)
//                    .buttonStyle(.bordered)
//                    Button {
//                        gamesVM.sortSelector = .fewestMoves
//                        gamesVM.fetchScores()
//                    } label: {
//                        Label("Fewest Moves", systemImage: "gear.fill")
//                            .labelStyle(.titleOnly)
//                    }
//                    .background(gamesVM.sortSelector == .fewestMoves ? Color("lightBackground") : Color("darkBackground"))
//                    .foregroundColor(gamesVM.sortSelector == .fewestMoves ? .white : Color("lightText"))
//                    .cornerRadius(25)
//                    .buttonStyle(.bordered)
//                    Button {
//                        gamesVM.sortSelector = .newestGames
//                        gamesVM.fetchScores()
//                    } label: {
//                        Label("Recent", systemImage: "gear.fill")
//                            .labelStyle(.titleOnly)
//                    }
//                    .background(gamesVM.sortSelector == .newestGames ? Color("lightBackground") : Color("darkBackground"))
//                    .foregroundColor(gamesVM.sortSelector == .newestGames ? .white : Color("lightText"))
//                    .cornerRadius(25)
//                    .buttonStyle(.bordered)
                }
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
