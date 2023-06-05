//
//  LayoutAttributesAnimator.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 5/6/23.
//

import UIKit

public protocol LayoutAttributesAnimator {
    func animate(collectionView: UICollectionView, attributes: AnimatedCollectionViewLayoutAttributes)
}
