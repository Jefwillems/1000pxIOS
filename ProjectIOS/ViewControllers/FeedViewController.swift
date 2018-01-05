import UIKit
class FeedViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pictures: [Picture]! = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPicture"?:
            //get selected picture, go
            let pictureViewController = segue.destination as! PictureViewController
            let selection = collectionView.indexPathsForSelectedItems!.first!
            pictureViewController.picture = pictures[selection.item]
            break
        default:
            fatalError("unknown segue.")
        }
    }
    
    override func viewDidLoad() {
        let columnLayout = ColumnFlowLayout(
            cellsPerRow: 3,
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        )
        self.collectionView.collectionViewLayout = columnLayout
        //self.collectionView.delegate = self
        //self.collectionView.dataSource = self
    }
}

extension FeedViewController: UICollectionViewDelegate {
    
}

extension FeedViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! PictureCell
        cell.picture = pictures[indexPath.item]
        return cell
    }
    
}
