
//
//  InterfaceController.swift
//  MusicPlayer WatchKit Extension
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, WKCrownDelegate {
    
    enum SongState {
        case Playing
        case Paused
    }
    
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
    
}
