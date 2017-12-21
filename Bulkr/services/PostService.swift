import Alamofire

enum PostService{
    
    
    static func test(succes: @escaping (_ posts: [Post]) -> Void){
        Alamofire.request("http://127.0.0.1:3000/api/recipe/getAll/brent.vanvosselen@live.be").responseJSON {
            response in
            
            var posts: [Post] = []
            
            if let json = response.result.value {
                for item in json as! [Dictionary<String, Any>] {
                    posts.append(Post(id: item["_id"] as! String,
                                      title: item["title"] as! String,
                                      description: item["description"] as! String,
                                      likes: item["likes"] as! [User],
                                      saves: item["saves"] as! [User]))
                                      //createdAt: DateFormatter().date(from: item["createdAt"] as? String)!))
                                      //poster: item["poster"] as! User))
                }
            }
            
            print(posts)
            print("test")
            succes(posts)
           
            
            
        }
    }
    
}
