//
//  AudioOptionsView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/23/23.
//

import SwiftUI

struct AudioOptionsView: View {
    
    @State var muted = false
    @State var volume = 0.5
    
    var body: some View {
        VStack{
            Text("Audio")
                .font(.title3)
                .fontWeight(.bold)
                .padding()
            Toggle("Mute", isOn: $muted)
                .padding([.leading, .trailing])
            HStack{
                Text("Volume")
                    .padding(.trailing)
                Spacer()
                    .padding(.leading)
                Slider(value: $volume)
                    .tint(.green)
            }
            .padding([.leading, .trailing])
        }
        .padding()
        .fontWeight(.bold)
        .background(Rectangle()
            .fill(.white)
            .opacity(0.9)
            .cornerRadius(10)
        )
        .foregroundColor(Color("darkBackground"))
        .padding()
    }
}

struct AudioOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        AudioOptionsView()
    }
}
