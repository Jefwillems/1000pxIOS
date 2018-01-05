import Alamofire

class RestService {
    
    private let baseUrl = "https://boiling-everglades-62506.herokuapp.com/api/"
    
    private init() { }
    
    var user: User?
    
    let sessionManager = SessionManager()
    
    static let shared = RestService()
    
    func login(username: String, password: String, completion: @escaping (_: Bool) -> Void) {
        let postUrl = "\(baseUrl)auth/login"
        let parameters: Parameters = [
            "username": username,
            "password": password
        ]
        
        sessionManager.request(postUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
            if
                let json = response.result.value as? [String: Any],
                let token = json["token"] as? String
            {
                self.sessionManager.adapter = AccessTokenAdapter(accessToken: token)
                self.sessionManager.request("\(self.baseUrl)auth/currentUser", method: .get, encoding: JSONEncoding.default)
                    .validate().responseJSON(completionHandler: { response in
                        if let user = response.result.value as? [String: Any] {
                            if
                                let username = user["username"],
                                let email = user["email"],
                                let likes = user["likes"] as? [String],
                                let pictures = user["pictures"] as? [String]
                            {
                                self.user = User(username: username as! String, email: email as! String)
                                self.user?.likes = likes
                                self.user?.pictures = pictures
                                print("TODO: get likes and pictures")
                                completion(true)
                            }
                        }
                    })
            } else {
                completion(false)
            }
        }
        
    }
    
    func like(id picture: String) {
        let postUrl = "\(baseUrl)img/like/\(picture)"
        let parameters: Parameters = [:]
        sessionManager.request(postUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON {
                response in
                if let json = response.result.value as? [String: Any] {
                    print("json: \(json)")
                }
        }
    }
    
    func unlike(id picture:String) {
        let postUrl = "\(baseUrl)img/unlike/\(picture)"
        let parameters: Parameters = [:]
        sessionManager.request(postUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                if let json = response.result.value as? [String: Any] {
                    print("json: \(json)")
                }
        }
    }
    
    func getFresh(completion: @escaping ([Picture]) -> Void) {
        let getUrl = "\(baseUrl)img/fresh"
        sessionManager.request(getUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseJSON {
                response in
                if let json = response.result.value as? [[String: Any]] {
                    var pictures: [Picture] = []
                    json.forEach({ picJson in
                        if let pic = self.pictureFrom(json: picJson){
                            pictures.append(pic)
                        }
                    })
                    completion(pictures)
                }
        }
    }
    
    private func pictureFrom(json: [String: Any]) -> Picture? {
        guard
            let id = json["_id"] as? String,
            let pathToPicture = json["pathToPicture"] as? String,
            let title = json["title"] as? String,
            let author = userFrom(json: json["author"] as! [String: Any])
            else {
                return nil
        }
        let pic = Picture(from: pathToPicture, title: title, id: id, author: author)
        if let likes = json["likes"] as? Int {
            pic.likes = likes
        }
        if let description = json["description"] as? String {
            pic.description = description
        }
        if let datePublished = json["datePublished"] as? String {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
            dateformatter.locale = Locale(identifier: "nl_BE")
            pic.datePublished = dateformatter.date(from: datePublished)!
        }
        return pic
    }
    
    private func userFrom(json:[String: Any]) -> User? {
        guard
            let username = json["username"] as? String,
            let email = json["email"] as? String
            else {
                return nil
        }
        let user = User(username: username, email: email)
        if let likes = json["likes"] as? [String] {
            user.likes = likes
        }
        if let pictures = json["pictures"] as? [String] {
            user.pictures = pictures
        }
        return user
    }
    
    
}


