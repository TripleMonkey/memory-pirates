//
//  NavigationItemsView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/27/23.
//

import SwiftUI

struct NavigationItemsView: View {
    
    @StateObject private var gameVM = GameViewModel.shared
    @State var showResetAlert = false
    
    var body: some View {
        HStack{
            Spacer()
            // Reset button
            Button("reset") {
                showResetAlert = true
            }
            .opacity(gameVM.playButtonIsActive ? 0.0 : 1.0)
            .offset(y: 3)
            // Profile link
            NavigationLink(destination: ProfileView()
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline))
            {
                Label("Profile", systemImage: "person.fill")
                    .labelStyle(.iconOnly)
            }
        }
        .alert("Reset", isPresented: $showResetAlert, actions: {
            Button("Reset", role: .destructive) {
                gameVM.resetGame()
            }
        }, message: {
            Text("Current game progess will be lost")
        })
//        .onAppear() {
//            GameCenterManager().accessPoint.isActive = true
//        }
        Spacer()
    }
}

struct NavigationItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationItemsView()
    }
}
