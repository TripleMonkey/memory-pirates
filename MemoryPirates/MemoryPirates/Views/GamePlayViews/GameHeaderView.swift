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
                Spacer()
                VStack(alignment: .leading) {
                    Text("Current Time")
                        .padding(.bottom)
                    Text("Best Time")
                }
                .padding()
                Spacer()
                VStack(alignment: .trailing) {
                    Text(gameVM.currentElapsedTimeLabel)
                        .padding(.bottom)
                    Text(leaderboardVM.bestTime)
                }
                .padding()
                Spacer()
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
