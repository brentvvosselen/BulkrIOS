import Alamofire
import ObjectMapper

enum PostService{
    
    
    
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
    
    static func getMyFeed(at page: Int, completion: @escaping (_ posts: [Post]) -> Void){
        let email: String = "brent.vanvosselen@live.be"
        Alamofire.request("http://127.0.0.1:3000/api/feed/" + email + "/" + String(page)).validate(statusCode: 200..<300).responseJSON {
            response in
            switch response.result {
            case .success:
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
                //set failure completion
            return
            }
            
        }
    }
    
    static func addPost(_ post: Post, completion: @escaping (_ message: String) -> Void){
        let params = [
            "title": post.title,
            "description": post.description
        ]
        let user = "brent.vanvosselen@live.be"
        Alamofire.request("http://127.0.0.1:3000/api/recipe/add/" + user, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success:
                print("succes")
                completion("succes")
            case .failure(let error):
                return
            }
        
 
        }
    }

}
