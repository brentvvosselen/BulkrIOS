import Alamofire
import ObjectMapper

class PostService{
    
    static let prefix: String = "http://127.0.0.1:3000/"
    
    static func getMyProjects(completion: @escaping (_ posts: [Post]) -> Void){
        let user: String = "brent.vanvosselen@live.be"
        Alamofire.request(prefix + "api/recipe/getAll/" + user).validate(statusCode: 200..<300).responseJSON {
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
    
    static func getMySaves(completion: @escaping (_ posts: [Post]) -> Void) {
        let user: String = "brent.vanvosselen@live.be"
        Alamofire.request(prefix + "api/recipes/saved/" + user).validate(statusCode: 200..<300).responseJSON {
            response in
            switch response.result {
            case .success:
            guard let responseJSON = response.result.value as? Array<[String: AnyObject]> else {
                //failure completion
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
        Alamofire.request(prefix + "api/feed/" + email + "/" + String(page)).validate(statusCode: 200..<300).responseJSON {
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
        Alamofire.request(prefix + "api/recipe/add/" + user, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON {
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
    
    static func likePost(_ id: String, completion: @escaping (_ message: String) -> Void) {
        let params = [
            "recipeid": id
        ]
        let user = "brent.vanvosselen@live.be"
        Alamofire.request(prefix + "api/recipes/like/" + user, method: .put, parameters: params, encoding: JSONEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success:
                completion("succes")
            case .failure(let error):
                return
            }
        }
    }
    
    static func unlikePost(_ id: String, completion: @escaping(_ message: String) -> Void) {
        let params = [
            "recipeid": id
        ]
        let user = "brent.vanvosselen@live.be"
        Alamofire.request(prefix + "api/recipes/unlike/" + user, method: .put, parameters: params, encoding: JSONEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success:
                completion("succes")
            case .failure(let error):
                return
            }
        }
    }
    
    static func savePost(_ id: String, completion: @escaping(_ message: String) -> Void) {
        let params = [
            "recipeid": id
        ]
        let user = "brent.vanvosselen@live.be"
        Alamofire.request(prefix + "api/recipe/save/" + user, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success:
                completion("succes")
            case .failure(let error):
                return
            }
        }
    }
    
}

