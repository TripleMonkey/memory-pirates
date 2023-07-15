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
    // Set frame to 1/2 the screen width
    var frameWidth = UIScreen.main.bounds.width/2
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("darkBackground"))
            HStack {
                VStack(alignment: .leading) {
                    Text("Current Time")
                        .padding(.bottom)
                        .frame(width: frameWidth, alignment: .trailing)
                    Text("Best Time")
                        .frame(width: frameWidth, alignment: .trailing)
                }
                .padding()
                VStack(alignment: .trailing) {
                    Text(gameVM.currentElapsedTimeLabel)
                        .padding(.bottom)
                        .frame(width: frameWidth, alignment: .leading)
                    Text(leaderboardVM.bestTime)
                        .frame(width: frameWidth, alignment: .leading)
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
