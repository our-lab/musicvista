//
//  PlayListDTO.swift
//  onlymusic-watch WatchKit Extension
//
//  Created by Anshul  Mohil on 12/10/19.
//  Copyright © 2019 Anshul  Mohil. All rights reserved.
//

import Foundation
class PlayListDTO{
    var directory: String
    init(directoryPath: String) {
        directory = directoryPath
    }
}