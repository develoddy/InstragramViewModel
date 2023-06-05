//
//  IGError.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 5/6/23.
//

import Foundation

public enum IGError: Error, CustomStringConvertible {

    case invalidImageURL
    case downloadError

    public var description: String {
        switch self {
        case .invalidImageURL: return "Invalid Image URL"
        case .downloadError: return "Unable to download image"
        }
    }
}

