//
//  ListCommentsCollectionViewCellViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 20/1/23.
//

import UIKit

struct ListCommentsCollectionViewCellViewModel {
    
    private let comment: Comment
    
    var profileImageURL: URL? { return URL(string: comment.profileImageURL) }
    
    //var commentText: String { return comment.commentText }
    
    //var username: String { return comment.username }
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    func commentLabelText() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(comment.username) ", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .semibold) ])
        attributedString.append(NSAttributedString(string: comment.commentText, attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)]))
        return attributedString
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = comment.commentText
        label.lineBreakMode = .byCharWrapping
        label.setWidth(width)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
