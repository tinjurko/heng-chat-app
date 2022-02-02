//
//  SoundService.swift
//  henging_app
//
//  Created by Tin Jurkovic on 01.02.2022..
//

import Foundation
import AVFoundation

enum SoundsEnum {
    case sent
    case recieved
}
class SoundService {
    static let shared = SoundService()

    func playSound(sound: SoundsEnum) {
        let systemSoundID: SystemSoundID!

        switch sound {
        case .sent:
            systemSoundID = 1004
        case .recieved:
            systemSoundID = 1308
        }

        AudioServicesPlaySystemSound(systemSoundID)
    }
}
