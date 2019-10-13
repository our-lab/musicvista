//
//  PlaylistController.swift
//  onlymusic-watch WatchKit Extension
//
//  Created by Anshul  Mohil on 12/10/19.
//  Copyright © 2019 Anshul  Mohil. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation
import UIKit
//TODO: Need to separate UI controllers of 2 or more screen
class PlaylistController: WKInterfaceController, WKCrownDelegate{
    
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
    
 let numberOfSteps = 3
    var listDirectories: [String] = []
    @IBOutlet var volumeSlider: WKInterfaceSlider!

    @IBOutlet var playlistTable: WKInterfaceTable!
    override init() {
        // intialise library with main directory
//        let fm = FileManager.default
//        let path = Bundle.main.resourcePath!
//
//        do {
//            listDirectories = fm.subpaths(atPath: path)!
//
//            //todo: remove debug statement
//            for item in listDirectories {
//                print("Found \(item)")
//            }
//        }
//
        var directoryContents: [URL] = []
        do {
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let Path = documentURL.appendingPathComponent("resources").absoluteURL
            directoryContents = try FileManager.default.contentsOfDirectory(at: Path, includingPropertiesForKeys: nil, options: [])
        }
        catch {
            print(error.localizedDescription)
        }
        for item in directoryContents{
            print("Found \(item)")
        }
//        let allJsonNamePath = PlaylistController.listAllFileNamesExtension(nameDirectory:"resources", extensionWanted: ".mp3")
//        for item in allJsonNamePath{
//            print("Found \(item)")
//        }
    }
    static func listAllFileNamesExtension(nameDirectory: String, extensionWanted: String) -> (names : [String], paths : [URL]) {
        
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let Path = documentURL.appendingPathComponent(nameDirectory).absoluteURL
        
        do {
            try FileManager.default.createDirectory(atPath: Path.relativePath, withIntermediateDirectories: true)
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: Path, includingPropertiesForKeys: nil, options: [])
            
            // if you want to filter the directory contents you can do like this:
            let FilesPath = directoryContents.filter{ $0.pathExtension == extensionWanted }
            let FileNames = FilesPath.map{ $0.deletingPathExtension().lastPathComponent }
            
            return (names : FileNames, paths : FilesPath);
            
        } catch {
            print(error.localizedDescription)
        }
        
        return (names : [], paths : [])
    }
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        // Create a new variable to store the instance of PlayerTableViewController
//        let destinationVC = segue.destinationViewController as PlayerController
//        destinationVC.playListPath =  PlayListDTO(directoryPath: "Some")
//    }
//
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//
//        // Create a variable that you want to send based on the destination view controller
//        // You can get a reference to the data by using indexPath shown below
//        let selectedProgram = programy[indexPath.row]
//
//        // Create an instance of PlayerTableViewController and pass the variable
//        let destinationVC = PlayerTableViewController()
//        destinationVC.programVar = selectedProgram
//
//        // Let's assume that the segue name is called playerSegue
//        // This will perform the segue and pre-load the variable for you to use
//        destinationVC.performSegueWithIdentifier("playerSegue", sender: self)
//    }
//
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        crownSequencer.focus()
        crownSequencer.delegate = self
        
        volumeSlider.setNumberOfSteps(numberOfSteps)
        // Here playlistTable is the @IBOutlet name
        // and Playlist is the row identifier
        playlistTable.setNumberOfRows(listDirectories.count, withRowType: "Playlist")
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}

