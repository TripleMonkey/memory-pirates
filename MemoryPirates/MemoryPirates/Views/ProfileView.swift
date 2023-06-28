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
            // Background Fill
            Rectangle()
                .fill(Color("lightBackground"))
                .ignoresSafeArea()
            // Foreground views
            Rectangle()
                .fill(Color("darkBackground"))
            VStack {
                Spacer()
                AudioOptionsView()
                    .padding()
                LeaderboardTableView()
                Spacer()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
