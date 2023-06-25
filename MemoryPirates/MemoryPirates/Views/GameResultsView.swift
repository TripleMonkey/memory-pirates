//
//  GameResultsView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/24/23.
//

import SwiftUI

struct GameResultsView: View {
    
    var gameTime: Double
    var gameMoves: Int
    var date: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Date")
                Text("\(date.formatted())")
            }
            HStack {
                HStack {
                    Text("Time")
                    Text("\(formattedTime(seconds: gameTime))")
                }
                HStack {
                    Text("Chests Opened")
                    Text("\(gameMoves)")
                }
            }
        }
        .foregroundColor(Color("darkBackground"))
        .padding([.leading, .trailing])
    }
    
    func formattedTime(seconds: Double) -> String {
        // multiply by 100 to catpture miliseconds in int
        let time: Int = Int(seconds*100)
        // Seperate int into minutes, seconds, milliseconds
        let minSecMil = (((time/100)%3600)/60,
                         ((time/100)%3600)%60,
                         time%100)
        // Create return string from minSecMil
        var timeString: String
        if minSecMil.0 > 0 {
            timeString = "\(minSecMil.0):\(minSecMil.1).\(minSecMil.2)"
        } else {
            timeString = "\(minSecMil.1).\(minSecMil.2)"
        }
        return timeString
    }
}

struct GameResultsView_Previews: PreviewProvider {
    static var previews: some View {
        GameResultsView(gameTime: 533.339, gameMoves: 32, date: Date.now)
    }
}
