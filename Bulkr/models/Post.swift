import Foundation
import ObjectMapper

class Post: Mappable{
    
    var id: String?
    var title: String?
    var description: String?
    var likes: [User]?
    var saves: [User]?
    var createdAt: Date?
    var poster: User?
    var picture: Image?
    
    
    required init?(map: Map) {
        
    }
    
    init(title: String, description: String?){
        self.title = title
        self.description = description
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        title <- map["title"]
        description <- map["description"]
        likes <- map["likes"]
        saves <- map["saves"]
        poster <- map["poster"]
        picture <- map["picture"]
    }


}
