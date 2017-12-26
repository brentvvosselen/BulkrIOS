import ObjectMapper

class Image: Mappable{
    
    var filename: String?
    var filetype: String?
    var value: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        filename <- map["filename"]
        filetype <- map["filetype"]
        value <- map["value"]
    }
}
