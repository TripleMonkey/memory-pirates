//
//  OptionsView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/23/23.
//

import SwiftUI

struct OptionsView: View {
    
    var body: some View {
        VStack {
            Spacer()
            AudioOptionsView()
            .padding()
            LeaderboardTableView()
            Spacer()
        }
        .background(Color("darkBackground"))
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
