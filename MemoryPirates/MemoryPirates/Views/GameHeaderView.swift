//
//  GameHeaderView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/25/23.
//

import SwiftUI

struct GameHeaderView: View {
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("darkBackground"))
                .background(Color("lightBackground"))
            HStack {
                Spacer()
                VStack(alignment: .leading) {
                    Text("Current Time")
                        .padding(.bottom)
                    Text("Best Time")
                }
                .padding()
                Spacer()
                VStack(alignment: .trailing) {
                    Text("00:00.00")
                        .padding(.bottom)
                    Text("00:53.36")
                }
                .padding()
                Spacer()
            }
            .foregroundColor(Color("lightText"))
            .shadow(color: .black, radius: 0, x: -2, y: 2)
        }
        .frame(height: UIScreen.main.bounds.height*0.12)
    }
}

struct GameHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GameHeaderView()
    }
}
