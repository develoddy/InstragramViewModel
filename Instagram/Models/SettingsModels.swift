//
//  File.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 5/1/23.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
