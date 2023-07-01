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
                    .padding()
                LeaderboardTableView()
                Spacer()
            }
        }
        .background(Color("lightBackground"))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
