//
//  SortButton.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 7/3/23.
//

import SwiftUI

struct SortButton: View {
    
    @StateObject var leaderboardVM = LeaderboardViewModel.shared
    var sortValue: SortValue
    
    private var labelString: String {
        switch sortValue {
        case .bestTime:
            return "Best Time"
        case .fewestMoves:
            return "Fewest Moves"
        case .newestGames:
            return "Recent"
        case .oldestGames:
            return "Oldest"
        }
    }
    
    var body: some View {
        Button {
            leaderboardVM.sortSelector = sortValue
            leaderboardVM.fetchScores()
        } label: {
            Label(labelString, systemImage: "gear.fill")
                .labelStyle(.titleOnly)
        }
        .background(leaderboardVM.sortSelector == sortValue ? Color("lightBackground") : Color("darkBackground"))
        .foregroundColor(leaderboardVM.sortSelector == sortValue ? .white : Color("lightText"))
        .cornerRadius(25)
        .buttonStyle(.bordered)
    }
}

struct SortButton_Previews: PreviewProvider {
    static var previews: some View {
        SortButton(sortValue: .bestTime)
    }
}
