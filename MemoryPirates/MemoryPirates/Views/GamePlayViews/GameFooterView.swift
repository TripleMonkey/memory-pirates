//
//  GameFooterView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/25/23.
//

import SwiftUI

struct GameFooterView: View {
    
    @StateObject var gameVM = GameViewModel.shared
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("darkBackground"))
            Grid {
                HStack {
                    Spacer()
                    Text("Matched")
                    Text("\(gameVM.matchCount)/15")
                    Spacer()
                    Text("Chests Opened")
                    Text("\(gameVM.moves)")
                    Spacer()
                }
            }
            .foregroundColor(Color("lightText"))
            .shadow(color: .black, radius: 0, x: -2, y: 2)
        }
    }
}

struct GameFooterView_Previews: PreviewProvider {
    static var previews: some View {
        GameFooterView()
    }
}
