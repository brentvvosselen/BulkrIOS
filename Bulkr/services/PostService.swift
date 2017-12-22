import Alamofire
import ObjectMapper

enum PostService{
    
    
    /*static func test(succes: @escaping (_ posts: [Post]) -> Void){
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
    }*/
    
    static func getMyProjects(completion: @escaping (_ posts: [Post]) -> Void){
        Alamofire.request("http://127.0.0.1:3000/api/recipe/getAll/brent.vanvosselen@live.be").validate(statusCode: 200..<300).responseJSON {
            response in
            switch response.result {
            case .success:
                //get return value
                guard let responseJSON = response.result.value as? Array<[String: AnyObject]> else {
                    //set failure completion
                    return
                }
                guard let posts: [Post] = Mapper<Post>().mapArray(JSONArray: responseJSON) else {
                    //set failure completion
                    return
                }
                completion(posts)
            case .failure(let error):
                //set failure
                return
            }
        }
    
}

}
