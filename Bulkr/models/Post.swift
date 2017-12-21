import Foundation

struct Post {
    var id: String
    var title: String
    var description: String?
    var likes: [User]?
    var saves: [User]?
    var createdAt: Date?
    var poster: User?
    var picture: Image?
    
    init(id: String, title: String, description: String, likes: [User], saves: [User]){
        self.id = id
        self.title = title
        self.description = description
        self.likes = likes
        self.saves = saves
    }
    
    
    
}
