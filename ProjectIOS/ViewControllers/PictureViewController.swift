import UIKit
class PictureViewController: UIViewController {
    
    var picture: Picture!
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var datePublished: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var likeBarBtnItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        self.title = picture.title
        self.titleLbl.text = picture.title
        downloadImage(urlString: picture.pathToPicture)
        self.descriptionLbl.text = picture.description
        // TODO format Date
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .long
        dateformatter.timeStyle = .none
        dateformatter.locale = Locale(identifier: Locale.preferredLanguages[0])
        self.datePublished.text = dateformatter.string(from: picture.datePublished)
        self.authorLbl.text = self.picture.author.username
        if picture.hasBeenLiked {
            self.likeBarBtnItem.tintColor = UIColor(red:1.00, green:0.18, blue:0.18, alpha:1.0)
        } else {
            self.likeBarBtnItem.tintColor = UIColor(red:0.49, green:0.65, blue:1.00, alpha:1.0)
        }
    }
    
    @IBAction func like(_ sender: Any) {
        //TODO: like picture with service.
        
        let user = RestService.shared.user!
        if picture.hasBeenLiked {
            let index = user.likes.index(where: { (picId) -> Bool in
                picId == self.picture.id
            })!
            user.likes.remove(at: index)
            RestService.shared.unlike(id: self.picture.id)
            self.likeBarBtnItem.tintColor = UIColor(red:0.49, green:0.65, blue:1.00, alpha:1.0)
        } else {
            user.likes.append(self.picture.id)
            RestService.shared.like(id: self.picture.id)
            self.likeBarBtnItem.tintColor = UIColor(red:1.00, green:0.18, blue:0.18, alpha:1.0)
        }
    }
    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    private func downloadImage(urlString: String) {
        if let url = URL(string: urlString){
            getDataFromUrl(url: url) { (data, response, error) in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.imageView?.image = UIImage(data: data)
                }
            }
        }
    }
   
}
