//
//  ViewController.swift
//  speech_recognizer
//
//  Created by Woojin Ko on 3/8/20.
//  Copyright © 2020 Woojin Ko. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {

    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var detectedTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func startButtonTapped(_ sender: AnyObject) {
        self.recordAndRecognizeSpeech()
    }
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
//        if node == nil {
//            return
//        }
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in self.request.append(buffer)}
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            // A recognizer is not supported for the current locale
            return
        }
        
        if !myRecognizer.isAvailable {
            // A recognizer is not available right now
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                self.detectedTextLabel.text = bestString
            } else if let error = error {
                print(error)
            }
        })
        
    }
    
    


}

