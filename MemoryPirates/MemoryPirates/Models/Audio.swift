/*
 Student:    Nigel Krajewski
 Term:       202012
 Course:     MDV3730-O
 */

//
//  Audio.swift
//  GameOfMemory
//
//  Created by Nigel Krajewski on 12/6/20.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

// Function to play sound from parameters entered
func playAudio(sound: String, type: String) {
    // get path to sound
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        // Use do-try to get sound from path
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            // Play sound
            audioPlayer?.play()
        }
        catch {
            // Print error if unsuccessful
            print("Error: Sound file not found. Check path.")
        }
    }
}
