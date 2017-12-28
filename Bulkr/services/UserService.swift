import Alamofire
import ObjectMapper

class UserService {
    
    static let prefix: String = "http://127.0.0.1:3000/"
    
    static func login(as email: String, with password: String, completion: @escaping (_ boolean: Bool) -> Void) {
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
                    UserDefaults.standard.setValue(email, forKey:"userMail")
                    UserDefaults.standard.synchronize()
                }
                completion(true)
            case .failure(let error):
                print("not logged in")
                return
            }
        }
    }
    
    static func register(with email: String, and password: String, completion: @escaping(_ boolean: Bool) -> Void) {
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
                return
            }
        }
    }
    
    static func getUserInfo(for email: String, completion: @escaping(_ user: User) -> Void) {
        Alamofire.request(prefix + "api/user/" + email, method: .get).validate(statusCode: 200..<300).responseJSON {
            response in
            switch response.result {
            case .success:
                //get return value
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    //set failure
                    return
                }
                guard let user: User = Mapper<User>().map(JSON: responseJSON) else {
                    //set failure completion
                    return
                }
                completion(user)
            case .failure(let error):
                //set failure
                return
            }
        }
    }
    
    static func findUsers(searchString: String, completion: @escaping(_ users: [User]) -> Void) {
        Alamofire.request(prefix + "api/user/find/" + searchString, method: .get).validate(statusCode:200..<300).responseJSON {
            response in
            switch response.result {
            case .success:
                //get return value
                guard let responseJSON = response.result.value as? Array<[String: AnyObject]> else {
                    //failure completion
                    return
                }
                guard let users: [User] = Mapper<User>().mapArray(JSONArray: responseJSON) else {
                    //set failure completion
                    return
                }
                completion(users)
            case .failure(let error):
                //set failure
                return
            }
        }
    }
    
    
}
