//
//  ProfileView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/23/23.
//

import SwiftUI

struct ProfileView: View {
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("darkBackground"))
            VStack {
                Spacer()
                AudioOptionsView()
                LeaderboardTableView()
                Spacer()
            }
        }
        .background(Color("lightBackground"))
        .onAppear() {
            GameCenterManager().accessPoint.isActive = false
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
