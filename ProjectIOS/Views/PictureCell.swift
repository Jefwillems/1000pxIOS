import UIKit
class PictureCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView?
    
    @IBOutlet weak var titleLbl:UILabel!
    
    var picture: Picture! {
        didSet {
            self.titleLbl.text = picture.title
            downloadImage(urlString: picture.pathToPicture)
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
                    self.image?.image = UIImage(data: data)
                }
            }
        }
    }
    
    func prepareView() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
}

