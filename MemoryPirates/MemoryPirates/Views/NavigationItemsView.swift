//
//  NavigationItemsView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/27/23.
//

import SwiftUI

struct NavigationItemsView: View {
    var body: some View {
        VStack{
            HStack{
                Spacer()
                // Reset button
                Button("reset") {
                    // TODO: add reset function here
                }
                .padding(.trailing)
                // Profile link
                NavigationLink(destination: ProfileView()
                    .navigationTitle("Profile")) {
                    Label("Profile", systemImage: "person.fill")
                        .labelStyle(.iconOnly)
                }
                .padding(.trailing)
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
