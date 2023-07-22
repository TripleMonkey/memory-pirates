//
//  AVPlayerModel.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 7/4/23.
//

import Foundation
import AVFoundation

class AVPlayerModel {
    
    var audioPlayer: AVAudioPlayer?
    
    let defaults = UserDefaults.standard
    
    // Function to play sound from parameters entered
    func playAudio(sound: String, type: String) {
        // get path to sound
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            // Use do-try to get sound from path
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                // Set Volume
                if defaults.bool(forKey: "muted") {
                    audioPlayer?.volume = 0.0
                } else {
                    audioPlayer?.volume = defaults.float(forKey: "volume")
                }
                // Play sound
                audioPlayer?.play()
            }
            catch {
                // Print error if unsuccessful
                print("Error: Sound file not found. Check path.")
            }
        }
    }
}
