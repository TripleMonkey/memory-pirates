//
//  ContentView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/24/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var showingOptions: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Rectangle()
                    .fill(Color("lightBackground"))
                    .ignoresSafeArea()
                // Foreground views
                VStack{
                    GameHeaderView()
                    GameAreaView()
                    GameFooterView()
                }
                // Navigation Items
                NavigationItemsView()
                    .padding()
            }
        }
        .background(Color("lightBackground"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
