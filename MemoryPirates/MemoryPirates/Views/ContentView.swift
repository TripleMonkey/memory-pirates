//
//  ContentView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/24/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(Color("lightBackground"))
                    .ignoresSafeArea()
                VStack{
                    GameHeaderView()
                    GameAreaView()
                    GameFooterView()
                }
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
