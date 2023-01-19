
import Foundation

struct FeedCollectionViewCellViewModel {
    let post: Post
    
    var imageURL: URL? { return URL(string: post.imageURL)}
    
    var userProfileImageURL: URL? { return URL(string: post.ownerImageURL) }
    
    var username: String { return post.ownerUsername }
    
    var caption: String { return post.caption}
    
    var likes: Int { return post.likes }
    
    var likesLabelText : String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        } else {
            return "\(post.likes) likes"
        }
    }
    
    init(post: Post) {
        self.post = post
    }
}
