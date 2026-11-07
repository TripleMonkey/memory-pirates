//
//  GameHeaderView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/25/23.
//

import SwiftUI

struct GameHeaderView: View {
    
    @StateObject var gameVM = GameViewModel.shared
    @StateObject var leaderboardVM = LeaderboardViewModel.shared
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("darkBackground"))
            HStack {
                VStack(alignment: .leading) {
                    Text("Current Time")
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Text("Best Time")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    /*
                     Both columns expand equally to split the available width,
                     preventing views from shifting while timer runs
                     */
                }
                .padding()
                VStack(alignment: .trailing) {
                    Text(gameVM.currentElapsedTimeLabel)
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(leaderboardVM.bestTime)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    /*
                     Both columns expand equally to split the available width,
                     preventing views from shifting while timer runs
                     */
                }
                .padding()
            }
            .foregroundColor(Color("lightText"))
            .shadow(color: .black, radius: 0, x: -2, y: 2)
        }
    }
}

struct GameHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GameHeaderView()
    }
}
