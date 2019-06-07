//
//  SoundPlayer.swift
//  ProximityAlarm
//
//  Created by Manuel Olmos Gil on 07/06/2019.
//  Copyright © 2019 Manuel Olmos Gil. All rights reserved.
//

import Foundation
import AVFoundation

class SoundPlayer: NSObject {

    private var audioPlayer: AVAudioPlayer?

    func play() {
        stop()
        guard let soundURL = Bundle.main.url(forResource: "old_school_bell",
                                             withExtension: "mp3") else {
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func stop() {
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying {
            audioPlayer.stop()
        }
    }
}
