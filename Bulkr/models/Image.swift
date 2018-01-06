import ObjectMapper

class Image: Mappable{
    
    var filename: String?
    var filetype: String?
    var value: String?
    
    required init?(map: Map) {
        
    }
    
    init(filename: String, filetype: String, value: String) {
        self.filename = filename
        self.filetype = filetype
        self.value = value
    }
    
    func mapping(map: Map) {
        filename <- map["filename"]
        filetype <- map["filetype"]
        value <- map["value"]
    }
}
