//
//  FollowToggleView.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 13/1/23.
//

import UIKit

protocol FollowToggleViewDelegate: AnyObject {
    func followToggleViewDidTapFollower(_ toogleView: FollowToggleView)
    func followToggleViewDidTapFollowing(_ toogleView: FollowToggleView)
}


class FollowToggleView: UIView {

    enum State {
        case follower//playlist
        case following//album
    }
    
    var state: State = .follower
    
    weak var delegate: FollowToggleViewDelegate?
    
    let followerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        //button.setTitle("20 followers", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        return button
    }()
    
    let followingButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        //button.setTitle("10 Followings", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(followerButton)
        addSubview(followingButton)
        addSubview(indicatorView)
        
        followerButton.addTarget(self, action: #selector(didTapFollowers), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowings), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        followerButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        followingButton.frame = CGRect(x: followerButton.right, y: 0, width: 100, height: 40)
        layoutIndicator()
    }
    
    func layoutIndicator() {
        switch state {
        case .follower:
            indicatorView.frame = CGRect(x: 0, y: followerButton.bottom, width: 100, height: 2)
        case .following:
            indicatorView.frame = CGRect(x: 100, y: followerButton.bottom, width: 100, height: 2)
        }
    }
    
    @objc private func didTapFollowers() {
        state = .follower
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        
        delegate?.followToggleViewDidTapFollower(self)
    }
    
    @objc private func didTapFollowings() {
        state = .following
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.followToggleViewDidTapFollowing(self)
    }
    
    func update(for state: State) {
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }

}
