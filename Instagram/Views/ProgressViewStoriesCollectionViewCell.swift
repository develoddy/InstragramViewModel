//
//  ViewStoriesCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 9/2/23.
//

import UIKit

class ProgressViewStoriesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static var identifier = "ProgressViewStoriesCollectionViewCell"
    
    var limit: Int? {
        didSet {
            configure()
        }
    }
    
    let progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.tintColor = .gray
        progress.progressTintColor = .systemBlue
        return progress
    }()
    

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        addSubview(progressView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        progressView.frame = CGRect(x: 10, y: 8, width: frame.size.width-20 , height: 20)
        progressView.setProgress(0, animated: false)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Helper
    
    func configure() {
        guard let limit = self.limit else {
            return
        }
        for x in 0..<limit {
            print("DEBUF: conteo is.. \(x)")
            DispatchQueue.main.asyncAfter(deadline: .now()+(Double(x)*0.25), execute: {
                //self.progressView.setProgress(Float(x)/14, animated: true)
                self.progressView.setProgress(Float(x)/19, animated: true)
            })
        }
    }
    
    
    // MARK: - Actions
}
