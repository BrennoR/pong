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
    
    static let instance = AudioSettings()
    
    let paths = ["paddle_hit_3", "wall_hit_2", "goal_sound_2"]
    var sounds = [AVAudioPlayer]()
    var soundEnabled = UserDefaults.standard.value(forKey: "audioEnabled") as? Bool ?? true
    
    func setupAudio() {
        for path in paths {
            do {
                let audioPath = Bundle.main.path(forResource: path, ofType: "wav")
                let player = try AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
                sounds.append(player)
            } catch {
                print(error)
            }
            
            for sound in sounds {
                sound.prepareToPlay()
            }
            
        }
    }
    
    func playSound(soundIndex: Int) {
        if soundEnabled == true {
            DispatchQueue.global().async {
                self.sounds[soundIndex].play()
            }
        }
    }
}

