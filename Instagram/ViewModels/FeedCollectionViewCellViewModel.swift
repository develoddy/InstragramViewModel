
import Foundation

struct FeedCollectionViewCellViewModel {
    //let caption: String
    //var imageURL: String
    private let post: Post
    
    var imageURL: URL? {
        return URL(string: post.imageURL)
    }
    
    var caption: String {
        return post.caption
    }
    
    var likes: Int {
        return post.likes
    }
    
    init(post: Post) {
        self.post = post
    }
}
