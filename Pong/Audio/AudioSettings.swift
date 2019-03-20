//
//  AudioSettings.swift
//  Pong
//
//  Created by Brenno Ribeiro on 3/17/19.
//  Copyright © 2019 Brenno Ribeiro. All rights reserved.
//

import Foundation
import AVFoundation

class AudioSettings {
    
    static let instance = AudioSettings()   // singleton
    
    let paths = ["paddle_hit", "wall_hit", "goal_sound"]  // audio file paths
    var sounds = [AVAudioPlayer]()  // AVAudioPlayer array
    
    // UserDefault value for enabling and disabling sound
    var soundEnabled = UserDefaults.standard.value(forKey: "audioEnabled") as? Bool ?? true
    
    func setupAudio() {
        // creates AVAudioPlayers and appends them to sounds with different audio files
        for path in paths {
            do {
                let audioPath = Bundle.main.path(forResource: path, ofType: "wav")
                let player = try AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
                sounds.append(player)
            } catch {
                print(error)
            }
            
            // initializes AVAudioPlayers for operation
            for sound in sounds {
                sound.prepareToPlay()
            }
            
        }
    }
    
    // play sound helper function
    func playSound(soundIndex: Int) {
        if soundEnabled == true {
            DispatchQueue.global().async {  // helps prevent lag
                self.sounds[soundIndex].play()
            }
        }
    }
}

