
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
//TODO: Need to separate UI controllers of 2 or more screen
class PlayerController: WKInterfaceController, WKCrownDelegate {
    
    // User will create List directories refered as playlist:
    // Library screen is a list of directories-->playlist in local:
    //list of files will be loaded when user choose a perticular directory.
    
    //Task1: Create directory and access file inside directory:
    // Task2: Map all files inside directory key as file names.
    //Task3: Map.keyset would be paylist:
    //Task4: See how to display thumbnail of the file
    //-------- UI -----------//
    // Each up swipe on screen will pick next file from the list
    // Each down swipe on screen will pick previous file from the list
    // Each Left swipe will list all the directories ie. playlist
    // Each right swipe will display top file from the list.
    var  playListPath: PlayListDTO?
    
    enum SongState {
        case Playing
        case Paused
        case Next
        case Previous
    }
    var player: AVAudioPlayer?
    var songState: SongState = .Paused
    var currentVolumeLevel: Float = 1.0
    let numberOfSteps = 3
    
    @IBOutlet var playButton: WKInterfaceButton!
    @IBOutlet var volumeSlider: WKInterfaceSlider!
    @IBOutlet var nextSong: WKInterfaceButton!
    @IBOutlet weak var previousSong: WKInterfaceButton!
    
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
    @IBAction func nextsongTapped(){
            songState = .Next
            nextSong.setBackgroundImage(UIImage(named: "FastForward"))
            playNextSong()
    }
    @IBAction func prevSongTapped(){
            songState = .Previous
            previousSong.setBackgroundImage(UIImage(named: "Rewind"))
            playPreviousSong()
    }
    var listDirectories: [String] = []
    
    override init() {
        // intialise library with main directory
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
    
        do {
            listDirectories = try fm.contentsOfDirectory(atPath: path)
    
            for item in listDirectories {
                print("Found \(item)")
            }
        } catch {
                print("faild to get read the resource")
            // failed to read directory – bad permissions, perhaps?
        }
    }

    //Play and Pause button actions
    @IBAction func playButtonTapped() {
        if songState == .Paused {
            songState = .Playing
            playButton.setBackgroundImage(UIImage(named: "Pause"))
//            playSound()
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
    
    func playSound(providedPath: String) {
        
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
    func playNextSong() {
        
    }
    
    func playPreviousSong(){}
}
