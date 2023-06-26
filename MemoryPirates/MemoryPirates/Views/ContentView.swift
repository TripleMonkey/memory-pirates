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
            VStack{
                Spacer()
                GameHeaderView()
                GameAreaView()
                GameFooterView()
            }
            .background(Color("lightBackground"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
