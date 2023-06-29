//
//  NavigationItemsView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/27/23.
//

import SwiftUI

struct NavigationItemsView: View {
    
    @StateObject var gameVM = GameViewModel.shared
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                // Reset button
                Button("reset") {
                    gameVM.prepareNewGame()
                }
                .offset(y: 3)
                // Profile link
                NavigationLink(destination: ProfileView()
                    .navigationTitle("Profile")) {
                        Label("Profile", systemImage: "person.fill")
                            .labelStyle(.iconOnly)
                    }
            }
            Spacer()
        }
    }
}

struct NavigationItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationItemsView()
    }
}
