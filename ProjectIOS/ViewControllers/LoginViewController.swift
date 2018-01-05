import UIKit

class LoginViewController : UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        self.usernameField.setBottomBorder()
        self.passwordField.setBottomBorder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showFeed"?:
            let feedViewController = segue.destination as! FeedViewController
            RestService.shared.getFresh(completion: { pictures in
                feedViewController.pictures = pictures
                feedViewController.collectionView.reloadData()
            })
        default:
            fatalError("Unknown segue.")
        }
    }
    
    
    @IBAction func btnPressed(_ sender: UIButton) {
        let username = self.usernameField.text!
        let password = self.passwordField.text!
        RestService.shared.login(username: username, password: password) {
            if $0 {
                self.performSegue(withIdentifier: "showFeed", sender: self)
            } else {
                self.errorLbl.text = "Wrong login! Try again."
                self.errorLbl.isHidden = false
            }
        }
        
    }
}


