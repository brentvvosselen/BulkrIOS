import ObjectMapper

class User: Mappable {
   
    var id: String?
    var email: String?
    var saves: [Post]?
    var posts: [Post]?
    
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        email <- map["email"]
        saves <- map["saves"]
        posts <- map["posts"]
    }
}
