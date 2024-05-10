//
//  SpeechManager.swift
//  M2C
//
//  Created by Abdul Samad Butt on 15/08/2022.
//

import Foundation
import AVKit

class SpeechManager {
    var synthesizer = AVSpeechSynthesizer()
    
    static let shared = SpeechManager()
    
    func speakAudio(dialouge: String){
        let utterance_3 = AVSpeechUtterance(string: dialouge)
        utterance_3.preUtteranceDelay = 0
        utterance_3.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance_3.volume = 100
        synthesizer.stopSpeaking(at: .word)
        synthesizer.speak(utterance_3)
    }
    
    func mute(){
        synthesizer = AVSpeechSynthesizer()
        synthesizer.stopSpeaking(at: .immediate)
    }
}
