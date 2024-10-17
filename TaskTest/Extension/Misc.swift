//
//  Misc.swift
//  MultiTaskManager
//
//  Created by Billie H on 14/09/24.
//

import Foundation
import AVFoundation
var synthesizer = AVSpeechSynthesizer()

func talk(str:String) {
    let utterance = AVSpeechUtterance(string: str)
    synthesizer.speak(utterance)
}

extension Array{
    var last: some Any{
        return self[count-1]
    }
}

