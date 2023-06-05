//
//  IGResult.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 5/6/23.
//

import Foundation

public enum IGResult<V, E> {
    case success(V)
    case failure(E)
}

