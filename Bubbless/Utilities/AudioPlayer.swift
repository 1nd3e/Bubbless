//
//  AudioPlayer.swift
//  Bubbless
//
//  Created by Vladislav Kulikov on 06.05.2020.
//  Copyright © 2020 Vladislav Kulikov. All rights reserved.
//

import AVFoundation

class AudioPlayer {
    
    // MARK: - Types
    
    static let shared = AudioPlayer()
    
    // MARK: - Properties
    
    var player: AVAudioPlayer?
    
    // MARK: - Methods
    
    func play(fileNamed name: String, ofType type: String) {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            let url = URL(fileURLWithPath: path)
            
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.numberOfLoops = -1
                player?.volume = 1.0
                
                player?.prepareToPlay()
                player?.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
