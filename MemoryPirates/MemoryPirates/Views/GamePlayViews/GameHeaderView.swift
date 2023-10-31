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
    var halfWidth = UIScreen.main.bounds.width/2
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("darkBackground"))
            HStack {
                VStack(alignment: .leading) {
                    Text("Current Time")
                        .padding(.bottom)
                        .frame(width: halfWidth, alignment: .trailing)
                    Text("Best Time")
                        .frame(width: halfWidth, alignment: .trailing)
                    /*
                     Text views are placed in half width frames to 
                     prevent views from shifting while timer runs
                     */
                }
                .padding()
                VStack(alignment: .trailing) {
                    Text(gameVM.currentElapsedTimeLabel)
                        .padding(.bottom)
                        .frame(width: halfWidth, alignment: .leading)
                    Text(leaderboardVM.bestTime)
                        .frame(width: halfWidth, alignment: .leading)
                    /*
                     Text views are placed in half width frames to 
                     prevent views from shifting while timer runs
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
