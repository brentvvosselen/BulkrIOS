import Alamofire
import ObjectMapper

class PostService{
    
    static let prefix: String = "http://127.0.0.1:3000/"
    
    static func getMySaves(completion: @escaping (_ posts: [Post]) -> Void, failure: @escaping(_ error: String) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "token")!
        ]
        if let user = UserDefaults.standard.string(forKey: "userMail") {
            Alamofire.request(prefix + "api/recipes/saved/" + user, headers: headers).validate(statusCode: 200..<300).responseJSON {
                response in
                switch response.result {
                case .success:
                guard let responseJSON = response.result.value as? Array<[String: AnyObject]> else {
                    failure("no object found")
                    return
                }
                guard let posts: [Post] = Mapper<Post>().mapArray(JSONArray: responseJSON) else {
                    failure("No posts found")
                    return
                }
                print(responseJSON)
                completion(posts)
                case .failure(let error):
                    failure(error.localizedDescription)
                }
            }
        } else {
            failure("You are not logged in correctly")
        }
    }
    
    static func getMyFeed(at page: Int, completion: @escaping (_ posts: [Post]) -> Void, failure: @escaping(_ error: String) -> Void){
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "token")!
        ]
        if let user = UserDefaults.standard.string(forKey: "userMail") {
            Alamofire.request(prefix + "api/feed/" + user + "/" + String(page), headers: headers).validate(statusCode: 200..<300).responseJSON {
                response in
                switch response.result {
                case .success:
                    guard let responseJSON = response.result.value as? Array<[String: AnyObject]> else {
                        failure("No object found")
                        return
                    }
                    guard let posts: [Post] = Mapper<Post>().mapArray(JSONArray: responseJSON) else {
                        failure("No posts found")
                        return
                    }
                    completion(posts)
                case .failure(let error):
                    failure(error.localizedDescription)
                }
            }
        } else {
            failure("You are not logged in correctly")
        }
    }
    
    static func addPost(_ post: Post, completion: @escaping (_ message: String) -> Void, failure: @escaping(_ error: String) -> Void){
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "token")!
        ]
        print(post.picture?.filename)
        let params = [
            "title": post.title,
            "description": post.description,
            (post.picture != nil ? "picture" : ""): [
                "filename": post.picture?.filename,
                "filetype": post.picture?.filetype,
                "value": post.picture?.value
            ]
            ] as [String : Any]
        if let user = UserDefaults.standard.string(forKey: "userMail") {
            Alamofire.request(prefix + "api/recipe/add/" + user, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {
                response in
                switch response.result {
                case .success:
                    print("succes")
                    completion("succes")
                case .failure(let error):
                    failure(error.localizedDescription)
                }
            }
        } else {
            failure("You are not logged in correctly")
        }
    }
    
    static func likePost(_ id: String, completion: @escaping (_ message: String) -> Void, failure: @escaping(_ error: String) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "token")!
        ]
        let params = [
            "recipeid": id
        ]
        if let user = UserDefaults.standard.string(forKey: "userMail") {
            Alamofire.request(prefix + "api/recipes/like/" + user, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {
                response in
                switch response.result {
                case .success:
                    completion("succes")
                case .failure(let error):
                    failure(error.localizedDescription)
                }
            }
        } else {
            failure("You are not logged in correctly")
        }
    }
    
    static func unlikePost(_ id: String, completion: @escaping(_ message: String) -> Void, failure: @escaping(_ error: String) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "token")!
        ]
        let params = [
            "recipeid": id
        ]
        if let user = UserDefaults.standard.string(forKey: "userMail") {
            Alamofire.request(prefix + "api/recipes/unlike/" + user, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {
                response in
                switch response.result {
                case .success:
                    completion("succes")
                case .failure(let error):
                    failure(error.localizedDescription)
                }
            }
        } else {
            failure("You are not logged in correctly")
        }
    }
    
    static func savePost(_ id: String, completion: @escaping(_ message: String) -> Void, failure: @escaping(_ error: String) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "token")!
        ]
        let params = [
            "recipeid": id
        ]
        if let user = UserDefaults.standard.string(forKey: "userMail") {
            Alamofire.request(prefix + "api/recipe/save/" + user, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {
                response in
                switch response.result {
                case .success:
                    completion("succes")
                case .failure(let error):
                    failure(error.localizedDescription)
                }
            }
        } else {
            failure("You are not logged in correctly")
        }
    }
    
}

