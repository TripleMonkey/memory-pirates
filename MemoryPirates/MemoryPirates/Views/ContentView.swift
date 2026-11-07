//
//  ContentView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/24/23.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        GameCenterManager().authenticatePlayer()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack{
                    GameHeaderView()
                    GameAreaGridView()
                        // Let the grid claim space before the greedy header/footer backgrounds
                        .layoutPriority(1)
                    GameFooterView()
                }
            }
            .toolbar(content: {
                NavigationItemsView()
            })
            .toolbar(.visible, for: .navigationBar, .tabBar)
            .background(Color("lightBackground"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
