
import UIKit

struct FeedCollectionViewCellViewModel {
    var post: Post
    
    var imageURL: URL? { return URL(string: post.imageURL)}
    
    var userProfileImageURL: URL? { return URL(string: post.ownerImageURL) }
    
    var username: String { return post.ownerUsername }
    
    var caption: String { return post.caption}
    
    var likes: Int { return post.likes }
    
    var likeButtonTintColor: UIColor {
        return post.didLike ? .red : .black
    }
    
    var likeButtonImage: UIImage? {
        let imageName = post.didLike ? "heart.fill" : "heart"
        return UIImage(systemName: imageName)
    }
    
    var likesLabelText : String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        } else {
            return "\(post.likes) like"
        }
    }
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        return formatter.string(from: post.timestamp.dateValue(), to: Date())
    }
    
    init(post: Post) {
        self.post = post
    }
}
