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
                if #available(iOS 26.0, *) {
                    // Hide the shared Liquid Glass capsule so only the buttons show
                    ToolbarItem {
                        NavigationItemsView()
                    }
                    .sharedBackgroundVisibility(.hidden)
                } else {
                    ToolbarItem {
                        NavigationItemsView()
                    }
                }
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
