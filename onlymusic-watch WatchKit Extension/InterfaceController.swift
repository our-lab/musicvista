
//
//  InterfaceController.swift
//  onlymusic-watch
//
//  Created by Anshul  Mohil on 11/08/19.
//  Copyright © 2019 Anshul  Mohil. All rights reserved.
//
import WatchKit
import Foundation
import AVFoundation

class InterfaceController: WKInterfaceController, WKCrownDelegate {
    
    enum SongState {
        case Playing
        case Paused
    }
    var player: AVAudioPlayer?
    var songState: SongState = .Paused
    var currentVolumeLevel: Float = 1.0
    let numberOfSteps = 3
    
    @IBOutlet var playButton: WKInterfaceButton!
    @IBOutlet var volumeSlider: WKInterfaceSlider!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        crownSequencer.focus()
        crownSequencer.delegate = self
        
        volumeSlider.setNumberOfSteps(numberOfSteps)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func playButtonTapped() {
        if songState == .Paused {
            songState = .Playing
            playButton.setBackgroundImage(UIImage(named: "Pause"))
            playSound()
        } else {
            songState = .Paused
            playButton.setBackgroundImage(UIImage(named: "Play"))
        }
    }
    
    @IBAction func sliderAction(_ value: Float) {
        currentVolumeLevel = value
    }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        let predictedVolumeLevel = currentVolumeLevel + Float(rotationalDelta) * 10
        
        if predictedVolumeLevel > 0.0 && predictedVolumeLevel <= Float(numberOfSteps) {
            currentVolumeLevel = predictedVolumeLevel
            
            volumeSlider.setValue(currentVolumeLevel)
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Dangal", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
