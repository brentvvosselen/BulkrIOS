import Alamofire
import ObjectMapper

class UserService {
    
    static let prefix: String = "http://127.0.0.1:3000/"
    
    static func login(as email: String, with password: String, completion: @escaping (_ boolean: Bool) -> Void, failure: @escaping(_ error: String) -> Void) {
        let params = [
            "email": email,
            "password": password
        ]
        Alamofire.request(prefix + "api/login", method: .post, parameters: params, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON {
            response in
            switch response.result {
            case .success:
                print("logged in")
                if let json = response.result.value as? NSDictionary{
                    let token = json["token"] as! String
                    
                    UserDefaults.standard.setValue(token, forKey: "token")
                    UserDefaults.standard.setValue(email, forKey: "userMail")
                    UserDefaults.standard.synchronize()
                }
                completion(true)
            case .failure(let error):
                print("not logged in")
                failure(error.localizedDescription)
            }
        }
    }
    
    static func register(with email: String, and password: String, completion: @escaping(_ boolean: Bool) -> Void, failure: @escaping(_ error: String) -> Void) {
        let params = [
            "email": email,
            "password": password
        ]
        Alamofire.request(prefix + "api/register", method: .post, parameters: params, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON {
            response in
            switch response.result {
            case .success:
                print("registered")
                if let json = response.result.value as? NSDictionary{
                    let token = json["token"] as! String
                    
                    UserDefaults.standard.setValue(token, forKey: "token")
                    UserDefaults.standard.setValue(email, forKey:"userMail")
                    UserDefaults.standard.synchronize()
                }
                completion(true)
            case .failure(let error):
                print("not registered")
                failure(error.localizedDescription)
            }
        }
    }
    
    static func getUserInfo(for email: String, completion: @escaping(_ user: User) -> Void, failure: @escaping(_ error: String) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "token")!
        ]
        Alamofire.request(prefix + "api/user/" + email, method: .get, headers: headers).validate(statusCode: 200..<300).responseJSON {
            response in
            switch response.result {
            case .success:
                //get return value
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    failure("No object found")
                    return
                }
                guard let user: User = Mapper<User>().map(JSON: responseJSON) else {
                    failure("User not found")
                    return
                }
                completion(user)
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    static func findUsers(searchString: String, completion: @escaping(_ users: [User]) -> Void, failure: @escaping(_ error: String) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "token")!
        ]
        Alamofire.request(prefix + "api/user/find/" + searchString, method: .get, headers: headers).validate(statusCode:200..<300).responseJSON {
            response in
            switch response.result {
            case .success:
                //get return value
                guard let responseJSON = response.result.value as? Array<[String: AnyObject]> else {
                    failure("No object found")
                    return
                }
                guard let users: [User] = Mapper<User>().mapArray(JSONArray: responseJSON) else {
                    failure("No users found")
                    return
                }
                completion(users)
            case .failure(let error):
                failure(error.localizedDescription)
                return
            }
        }
    }
    
    static func doesFollow(usermail: String, completion: @escaping(_ follows: Bool) -> Void, failure: @escaping(_ error: String) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "token")!
        ]
        if let user = UserDefaults.standard.string(forKey: "userMail") {
            Alamofire.request(prefix + "api/user/" + user + "/doesFollow/" + usermail, method: .get, headers: headers).validate(statusCode: 200..<300).responseJSON {
                response in
                switch response.result {
                case .success:
                    if let JSON = response.result.value {
                        print((JSON as? Bool)!)
                        completion(JSON as! Bool)
                    }else {
                        failure("No response")
                    }
                case .failure(let error):
                    failure("Error: \(error)" )
                }
            }
        } else {
            failure("No user found")
        }
    }
    
    static func follow(usermail: String, completion: @escaping(_ boolean: Bool) -> Void, failure: @escaping(_ error: String) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "token")!
        ]
        if let user = UserDefaults.standard.string(forKey: "userMail") {
            Alamofire.request(prefix + "api/user/" + user + "/follow/" + usermail, method: .post, headers: headers).validate(statusCode: 200..<300).responseJSON {
                response in
                switch response.result {
                case .success:
                    completion(true)
                case .failure(let error):
                    failure(error.localizedDescription)
                }
            }
        } else {
            failure("You are not logged in correctly")
        }
    }
    
    static func unfollow(usermail: String, completion: @escaping(_ boolean: Bool) -> Void, failure: @escaping(_ error: String) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "token")!
        ]
        if let user = UserDefaults.standard.string(forKey: "userMail") {
            Alamofire.request(prefix + "api/user/" + user + "/unfollow/" + usermail, method: .put, headers: headers).validate(statusCode: 200..<300).responseJSON {
                response in
                switch response.result {
                case .success:
                    completion(true)
                case .failure(let error):
                    failure(error.localizedDescription)
                }
            }
        } else {
            failure("You are not logged in correctly")
        }
    }
    
    
}
